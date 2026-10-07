rem esptool erase_flash
esptool.exe write_flash 0x0000 .\.pio\build\enfys_mini\bootloader.bin
esptool.exe write_flash 0x10000 .\.pio\build\enfys_mini\firmware.bin
esptool.exe write_flash 0x410000 .\.pio\build\enfys_mini\spiffs.bin

