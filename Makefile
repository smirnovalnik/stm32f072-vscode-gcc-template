# Цель (название образа)
TARGET = learning_stand

# Переменные сборки
# Включить отладочную информацию или нет
DEBUG ?= 1
# Уровень оптимизации
OPT ?= -O0

# Инструменты
# Префикс бинарников
PREFIX = arm-none-eabi-
# Путь к бинарникам gcc компилятора может быть определен при вызове через переменную GCC_PATH ($ make GCC_PATH=xxx)
# или может быть добавлен в переменные среды PATH.
ifdef GCC_PATH
CC = $(GCC_PATH)/$(PREFIX)gcc
AS = $(GCC_PATH)/$(PREFIX)gcc -x assembler-with-cpp
CP = $(GCC_PATH)/$(PREFIX)objcopy
SZ = $(GCC_PATH)/$(PREFIX)size
else
CC = $(PREFIX)gcc
AS = $(PREFIX)gcc -x assembler-with-cpp
CP = $(PREFIX)objcopy
SZ = $(PREFIX)size
endif
HEX = $(CP) -O ihex
BIN = $(CP) -O binary -S

RM = rm -fR
ifeq ($(OS),Windows_NT)
  RM = del /q
endif

# Пути
# Директория с результатом построения
BUILD_DIR = build

# Исходные коды
# Исходные коды на языке C
C_SOURCES = $(wildcard ./src/*.c) \
./lib/stm32f0xx_hal_driver/Src/stm32f0xx_hal.c \
./lib/stm32f0xx_hal_driver/Src/stm32f0xx_hal_cortex.c \
./lib/stm32f0xx_hal_driver/Src/stm32f0xx_hal_flash.c \
./lib/stm32f0xx_hal_driver/Src/stm32f0xx_hal_gpio.c \
./lib/stm32f0xx_hal_driver/Src/stm32f0xx_hal_exti.c \
./lib/stm32f0xx_hal_driver/Src/stm32f0xx_hal_rcc_ex.c

# Исходные коды на языке ассемблер
ASM_SOURCES = \
src/startup_stm32f072xb.s

# Флаги CFLAGS
# Выбор центрального процессора
CPU = -mcpu=cortex-m0

# Включение поддержки fpu
# Отсутсвует для Cortex-M0/M0+/M3
FPU =

# ABI для чисел плавающей запятой
# soft, softfp или hard
FLOAT-ABI =

# Параметры центрального процессора
MCU = $(CPU) -mthumb $(FPU) $(FLOAT-ABI)

# Подключение макроопределений для gcc
# Для ассемблера
AS_DEFS =

# Для C
C_DEFS = \
-DSTM32F072xB

# Подключение заголовочных файлов
# Для ассемблера
AS_INCLUDES =

# Для C
C_INCLUDES = \
-Isrc \
-Ilib/cmsis_core/Include \
-Ilib/cmsis_device_f0/Include \
-Ilib/stm32f0xx_hal_driver/Inc

# Итоговые флаги gcc
ASFLAGS = $(MCU) $(AS_DEFS) $(AS_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections
CFLAGS = $(MCU) $(C_DEFS) $(C_INCLUDES) $(OPT) -Wall -fdata-sections -ffunction-sections

# Подключение отладочной информации
ifeq ($(DEBUG), 1)
CFLAGS += -g -gdwarf-2
endif

# Создание информации о зависимостях
CFLAGS += -std=c17 -MMD -MP -MF"$(@:%.o=%.d)"

# Флаги LDFLAGS
# Скрипт компоновщика
LDSCRIPT = STM32F072RBTx_FLASH.ld

# Внешние библиотеки
LIBS = -lc -lm -lnosys
LIBDIR =
LDFLAGS = $(MCU) -specs=nano.specs -T$(LDSCRIPT) $(LIBDIR) $(LIBS) -Wl,-Map=$(BUILD_DIR)/$(TARGET).map,--cref -Wl,--gc-sections

# Цель по умолчанию: build all
all: $(BUILD_DIR)/$(TARGET).elf $(BUILD_DIR)/$(TARGET).hex $(BUILD_DIR)/$(TARGET).bin

# Построение
# Список объектов на языке C
OBJECTS = $(addprefix $(BUILD_DIR)/,$(notdir $(C_SOURCES:.c=.o)))
vpath %.c $(sort $(dir $(C_SOURCES)))
# Список объектов на языке ассемблер
OBJECTS += $(addprefix $(BUILD_DIR)/,$(notdir $(ASM_SOURCES:.s=.o)))
vpath %.s $(sort $(dir $(ASM_SOURCES)))

# Компиляция исходных файлов на языке C
$(BUILD_DIR)/%.o: %.c Makefile | $(BUILD_DIR)
	@echo Compiling $(notdir $< )
	@$(CC) -c $(CFLAGS) -Wa,-a,-ad,-alms=$(BUILD_DIR)/$(notdir $(<:.c=.lst)) $< -o $@

# Компиляция исходных файлов на языке ассемблер
$(BUILD_DIR)/%.o: %.s Makefile | $(BUILD_DIR)
	@echo Assembling $(notdir $< )
	@$(AS) -c $(CFLAGS) $< -o $@

# Компоновка (создание elf файла)
$(BUILD_DIR)/$(TARGET).elf: $(OBJECTS) Makefile
	@echo Linking
	@$(CC) $(OBJECTS) $(LDFLAGS) -o $@
	$(SZ) $@

# Преобразование elf файл в hex
$(BUILD_DIR)/%.hex: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(HEX) $< $@

# Преобразование elf файл в bin
$(BUILD_DIR)/%.bin: $(BUILD_DIR)/%.elf | $(BUILD_DIR)
	$(BIN) $< $@

# Создание директории для построения
$(BUILD_DIR):
	-mkdir $@

# Печать переменной из Makefile
print-%: ; @echo $*=$($*)

# Очистка директории с результатом построения
.PHONY: clean
clean:
	-@$(RM) $(BUILD_DIR)

# Прошивка МК
.PHONY: download
download:
	openocd -f interface/stlink.cfg -f target/stm32f0x.cfg -c "program $(BUILD_DIR)/$(TARGET).elf verify reset exit"

# Зависимости
-include $(wildcard $(BUILD_DIR)/*.d)
