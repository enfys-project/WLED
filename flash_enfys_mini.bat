@echo off
rem Full USB flash for the Enfys mini (ESP32-S3FN8, 8MB, native USB).
rem Writes the complete flash layout INCLUDING the partition table (0x8000) and otadata (0xe000);
rem without those the chip keeps whatever table it shipped with (e.g. ESPHome's 60KB filesystem).
rem
rem Build first:   pio run -e enfys_mini
rem Optional FS:   pio run -e enfys_mini -t buildfs   (packs ./wled00/data unless PLATFORMIO_DATA_DIR is set)
rem
rem Usage: flash_enfys_mini.bat COMx [erase] [fs]
rem   erase  wipe the whole chip first (needed when changing partition layout)
rem   fs     also write .pio\build\enfys_mini\littlefs.bin at 0x410000
rem          (otherwise WLED formats an empty filesystem on first boot)

setlocal
set PORT=%1
set B=.pio\build\enfys_mini
set BOOTAPP0=%USERPROFILE%\.platformio\packages\framework-arduinoespressif32\tools\partitions\boot_app0.bin
if "%PORT%"=="" (echo usage: %~nx0 COMx [erase] [fs] & exit /b 1)

if /i "%2"=="erase" (esptool --port %PORT% erase_flash || exit /b 1)

set FS=
if /i "%2"=="fs" set FS=0x410000 %B%\littlefs.bin
if /i "%3"=="fs" set FS=0x410000 %B%\littlefs.bin

esptool --port %PORT% write_flash 0x0 %B%\bootloader.bin 0x8000 %B%\partitions.bin 0xe000 "%BOOTAPP0%" 0x10000 %B%\firmware.bin %FS%
