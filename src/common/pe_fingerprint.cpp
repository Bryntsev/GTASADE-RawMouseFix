#include "common/pe_fingerprint.h"

#include <Windows.h>
#include <wincrypt.h>

#include <filesystem>
#include <cstring>
#include <iomanip>
#include <optional>
#include <sstream>
#include <string>
#include <vector>

namespace sade {
namespace {

template <typename T>
bool read_at(HANDLE file, std::uint64_t offset, T& value) {
  LARGE_INTEGER li{};
  li.QuadPart = static_cast<LONGLONG>(offset);
  if (!SetFilePointerEx(file, li, nullptr, FILE_BEGIN)) {
    return false;
  }
  DWORD read = 0;
  return ReadFile(file, &value, sizeof(T), &read, nullptr) && read == sizeof(T);
}

bool read_bytes(HANDLE file, std::uint64_t offset, std::vector<std::uint8_t>& bytes) {
  LARGE_INTEGER li{};
  li.QuadPart = static_cast<LONGLONG>(offset);
  if (!SetFilePointerEx(file, li, nullptr, FILE_BEGIN)) {
    return false;
  }
  DWORD read = 0;
  return ReadFile(file, bytes.data(), static_cast<DWORD>(bytes.size()), &read, nullptr) && read == bytes.size();
}

std::string hex_bytes(const std::vector<std::uint8_t>& bytes) {
  std::ostringstream out;
  out << std::hex << std::setfill('0');
  for (const auto b : bytes) {
    out << std::setw(2) << static_cast<unsigned>(b);
  }
  return out.str();
}

std::string sha256_file(const std::wstring& path) {
  HANDLE file = CreateFileW(path.c_str(), GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
  if (file == INVALID_HANDLE_VALUE) {
    return {};
  }

  HCRYPTPROV provider = 0;
  HCRYPTHASH hash = 0;
  if (!CryptAcquireContextW(&provider, nullptr, nullptr, PROV_RSA_AES, CRYPT_VERIFYCONTEXT) ||
      !CryptCreateHash(provider, CALG_SHA_256, 0, 0, &hash)) {
    CloseHandle(file);
    if (provider) {
      CryptReleaseContext(provider, 0);
    }
    return {};
  }

  std::vector<std::uint8_t> buffer(1024 * 1024);
  DWORD read = 0;
  while (ReadFile(file, buffer.data(), static_cast<DWORD>(buffer.size()), &read, nullptr) && read > 0) {
    CryptHashData(hash, buffer.data(), read, 0);
  }

  std::vector<std::uint8_t> digest(32);
  DWORD digest_size = static_cast<DWORD>(digest.size());
  CryptGetHashParam(hash, HP_HASHVAL, digest.data(), &digest_size, 0);

  CryptDestroyHash(hash);
  CryptReleaseContext(provider, 0);
  CloseHandle(file);
  return hex_bytes(digest);
}

std::string sha256_bytes(const std::vector<std::uint8_t>& bytes) {
  HCRYPTPROV provider = 0;
  HCRYPTHASH hash = 0;
  if (!CryptAcquireContextW(&provider, nullptr, nullptr, PROV_RSA_AES, CRYPT_VERIFYCONTEXT) ||
      !CryptCreateHash(provider, CALG_SHA_256, 0, 0, &hash)) {
    if (provider) {
      CryptReleaseContext(provider, 0);
    }
    return {};
  }
  CryptHashData(hash, bytes.data(), static_cast<DWORD>(bytes.size()), 0);
  std::vector<std::uint8_t> digest(32);
  DWORD digest_size = static_cast<DWORD>(digest.size());
  CryptGetHashParam(hash, HP_HASHVAL, digest.data(), &digest_size, 0);
  CryptDestroyHash(hash);
  CryptReleaseContext(provider, 0);
  return hex_bytes(digest);
}

std::string file_version(const std::wstring& path) {
  DWORD handle = 0;
  const DWORD size = GetFileVersionInfoSizeW(path.c_str(), &handle);
  if (size == 0) {
    return {};
  }
  std::vector<std::uint8_t> data(size);
  if (!GetFileVersionInfoW(path.c_str(), 0, size, data.data())) {
    return {};
  }
  VS_FIXEDFILEINFO* info = nullptr;
  UINT len = 0;
  if (!VerQueryValueW(data.data(), L"\\", reinterpret_cast<void**>(&info), &len) || info == nullptr) {
    return {};
  }
  std::ostringstream out;
  out << HIWORD(info->dwFileVersionMS) << '.' << LOWORD(info->dwFileVersionMS) << '.'
      << HIWORD(info->dwFileVersionLS) << '.' << LOWORD(info->dwFileVersionLS);
  return out.str();
}

}  // namespace

std::optional<BuildFingerprint> read_pe_fingerprint(const std::wstring& path) {
  HANDLE file = CreateFileW(path.c_str(), GENERIC_READ, FILE_SHARE_READ, nullptr, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, nullptr);
  if (file == INVALID_HANDLE_VALUE) {
    return std::nullopt;
  }

  BuildFingerprint fp;
  fp.path = path;
  std::error_code size_error;
  fp.size = std::filesystem::file_size(path, size_error);
  if (size_error) {
    fp.size = 0;
  }
  fp.sha256 = sha256_file(path);
  fp.file_version = file_version(path);

  IMAGE_DOS_HEADER dos{};
  if (!read_at(file, 0, dos) || dos.e_magic != IMAGE_DOS_SIGNATURE) {
    CloseHandle(file);
    return std::nullopt;
  }

  IMAGE_NT_HEADERS64 nt{};
  if (!read_at(file, dos.e_lfanew, nt) || nt.Signature != IMAGE_NT_SIGNATURE) {
    CloseHandle(file);
    return std::nullopt;
  }

  fp.is_x64 = nt.FileHeader.Machine == IMAGE_FILE_MACHINE_AMD64 && nt.OptionalHeader.Magic == IMAGE_NT_OPTIONAL_HDR64_MAGIC;
  fp.pe_timestamp = nt.FileHeader.TimeDateStamp;
  fp.image_base = nt.OptionalHeader.ImageBase;
  fp.entry_point_rva = nt.OptionalHeader.AddressOfEntryPoint;
  fp.size_of_image = nt.OptionalHeader.SizeOfImage;

  const auto section_offset = static_cast<std::uint64_t>(dos.e_lfanew) + sizeof(std::uint32_t) + sizeof(IMAGE_FILE_HEADER) +
                              nt.FileHeader.SizeOfOptionalHeader;
  for (std::uint16_t i = 0; i < nt.FileHeader.NumberOfSections; ++i) {
    IMAGE_SECTION_HEADER section{};
    if (!read_at(file, section_offset + i * sizeof(IMAGE_SECTION_HEADER), section)) {
      continue;
    }
    const std::string name(reinterpret_cast<const char*>(section.Name),
                           strnlen_s(reinterpret_cast<const char*>(section.Name), IMAGE_SIZEOF_SHORT_NAME));
    if (name == ".text" && section.SizeOfRawData > 0) {
      std::vector<std::uint8_t> text(section.SizeOfRawData);
      if (read_bytes(file, section.PointerToRawData, text)) {
        fp.text_sha256 = sha256_bytes(text);
      }
      break;
    }
  }

  CloseHandle(file);
  return fp;
}

}  // namespace sade
