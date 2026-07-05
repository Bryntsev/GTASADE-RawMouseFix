# GTASADE Raw Mouse Fix

Экспериментальный фикс raw mouse input для **Grand Theft Auto: San Andreas - The Definitive Edition** на Windows.

Это публичная тестовая сборка, а не финальная отполированная версия. Текущая сборка `v27` в тестах автора впервые дала близкий к правильному результат: камера в игре двигается от физических Raw Input delta мыши, а высокая частота опроса вроде 1000 Гц больше не усугубляет оригинальную проблему управления.

## Что делает мод

- Заменяет проблемный путь управления камерой мышью на физические raw delta мыши.
- Позволяет нормально играть с высокой частотой опроса мыши, включая 1000 Гц в тестах автора.
- Использует ASI-плагин и небольшой companion `.exe`.
- Не использует `SendInput` и не автоматизирует gameplay.
- Не изменяет `SanAndreas.exe` на диске.

## Текущий статус

`v0.1.0-test` / `v27-rawinput-companion` - тестовый релиз. В игре на системе автора проблема с камерой фактически решена, но нужны проверки на другом железе, Windows, FPS, мышах и с другими модами.

Отзывы, баги и отчеты о совместимости лучше писать в GitHub Issues или Discussions.

## Установка

1. Закройте игру.
2. Скачайте последний архив из GitHub Releases.
3. Распакуйте файлы:
   - `SADE.HighFpsRawMouseFix.asi`
   - `SADE.HighFpsRawMouseFix.RawInputCompanion.exe`
   - `SADE.HighFpsRawMouseFix.ini`
4. Скопируйте их в:

   ```text
   GTA San Andreas - The Definitive Edition\Gameface\Binaries\Win64\scripts
   ```

5. Запустите игру.

## Удаление

Закройте игру и удалите из `Gameface\Binaries\Win64\scripts`:

- `SADE.HighFpsRawMouseFix.asi`
- `SADE.HighFpsRawMouseFix.RawInputCompanion.exe`
- `SADE.HighFpsRawMouseFix.ini`

## Рекомендуемые настройки игры

Мод исправляет ввод мыши, но не исправляет все high-FPS проблемы ремастера.

Рекомендуемый лимит FPS в настройках игры:

- `60 FPS`, или
- `120 FPS`

На более высоком FPS у ремастера могут начинаться глюки анимаций или gameplay. Это отдельная проблема самой игры, не связанная напрямую с этим модом.

## Известные нюансы

- В меню игры пункты могут выделяться немного странно. В тестах автора меню остается рабочим и кнопки нажимаются.
- Текущей версии нужен внешний companion `.exe`.
- Мод пока не умеет надежно выставлять лимит FPS в настройках игры.
- Основное тестирование пока проведено на системе автора.

## Совместимость

Автор проверял мод вместе с Fusion Fix для GTA Trilogy Definitive Edition и не заметил проблем совместимости. Это не гарантия для всех конфигураций, поэтому отчеты о совместимости приветствуются.

## Антивирусы и безопасность

Мод предназначен для single-player.

Он использует:

- ASI-плагин, который загружается игрой;
- companion `.exe`;
- Raw Input;
- shared memory между ASI и companion-процессом.

Такая комбинация может вызывать false positive у некоторых антивирусов, даже если сборка чистая. Скачивайте мод только с официальной страницы GitHub Releases, сверяйте SHA256 и при желании проверяйте архив через VirusTotal.

Результаты VirusTotal для текущей публичной тестовой сборки:

- Release ZIP: `1/66`, MaxSecure определяет `Trojan.Malware.300983.susgen`.
- ASI-плагин: `1/70`, Microsoft определяет `PUA:Win32/Puwaders.C!ml`.
- Raw Input companion EXE: `1/70`, MaxSecure определяет `Trojan.Malware.300983.susgen`.

Эти срабатывания выглядят как generic/heuristic false positive из-за самого способа работы мода: неподписанный ASI-плагин, hooks внутри процесса игры, companion `.exe`, Raw Input и shared memory. Исходный код открыт, поэтому его можно проверить и собрать самостоятельно.

Если антивирус блокирует мод, может потребоваться восстановить заблокированный файл и добавить исключение для файлов мода или для папки `scripts` игры. Делайте это только если файлы скачаны с официального GitHub Release и SHA256 совпадает.

Не используйте мод в multiplayer или средах с античитом.

## Сборка

Требования:

- Windows x64
- Visual Studio 2022 Build Tools
- CMake 3.21+

Пример:

```powershell
.\tools\build.ps1 -Configuration Release
.\tools\package_observe_only.ps1 -Configuration Release
```

Пакет релиза содержит `.asi`, companion `.exe` и дефолтный `SADE.HighFpsRawMouseFix.ini`.
