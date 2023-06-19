# Шаблон программы на языке C для gcc и vscode

Установка всех компонентов происходит в командной строке.
Последовательность действий зависит от операционной системы.

Для работы потребуется кросс-компилятор `arm-none-eabi-gcc`, утилита сборки `make`, отладчик `openocd` и
текстовый редактор `Visual Studio Code` с расширениями.

В качестве текстого редактора можно использовать другой, например `Neovim`, `Notepad++`,
но наличие расширения для графической отладки следует проверять самостоятельно

## Установка компонентов

### Windows

Открыть командную строку `PowerShell` в режиме администратора.

- Скачать и установить пакетный менеджер `Chocolatey`

    Пакетный менеджер позволит быстро устанавливать необходимые программы не прибегая к поиску установочных файлов в интернете.

    Установка выполняется командой:

    ```shell
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    ```

    Проверить установку следует командой:

    ```shell
    choco --version
    ```

    Если установка прошла успешно, то в командной строке напечатается версия программы, например

    ```shell
    2.0.0
    ```

- Установить кросс-компилятор `arm-none-eabi-gcc` и другие инструмент:

    ```shell
    choco install gcc-arm-embedded
    choco install make
    choco install openocd
    ```

  Проверка правильности установки:

  ```shell
  arm-none-eabi-gcc --version
  make --version
  openocd --version
  ```

  Каждая команда должна вернуть свою версию.

- Скачать и установить [текстовый редактор vscode](#текстовый-редактор-vscode).

### Linux

- Установка в системах с пакетным менеджером `apt`:

  ```shell
  sudo apt install arm-none-eabi-gcc
  sudo apt install make
  sudo apt install openocd
   ```

  Проверка правильности установки:

  ```shell
  arm-none-eabi-gcc --version
  make --version
  openocd --version
  ```

  Каждая команда должна вернуть свою версию.

- Скачать и установить [текстовый редактор vscode](#текстовый-редактор-vscode).

### MacOS

- Установка в системах с пакетным менеджером `brew`:

  ```shell
  brew tap ArmMbed/homebrew-formulae
  brew install arm-none-eabi-gcc
  brew install openocd
  ```

  Проверка правильности установки:

  ```shell
  arm-none-eabi-gcc --version
  make --version
  openocd --version
  ```

  Каждая команда должна вернуть свою версию.

- Скачать и установить [текстовый редактор vscode](#текстовый-редактор-vscode).

### Текстовый редактор vscode

Инструкция применима для всех операционных систем.

Загрузить и установить с сайта версию [Visual Studio Code](https://code.visualstudio.com/) в соответствие с вашей операционной системой.

Установить расширения (extensions):

- Для работы с кодом на языке C/C++ - [C/C++ for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)

- Для визуализации отладки - [Cortex-Debug](https://marketplace.visualstudio.com/items?itemName=marus25.cortex-debug)

- Для подсветки синтаксиса ассемблера - [Arm Assembly](https://marketplace.visualstudio.com/items?itemName=dan-c-underwood.arm)

- Для подсветки синтаксиса скрипта компоновщика - [LinkerScript](https://marketplace.visualstudio.com/items?itemName=ZixuanWang.linkerscript)

- Для подсветки map файлов - [GNU Linker Map files](https://marketplace.visualstudio.com/items?itemName=trond-snekvik.gnu-mapfiles)

## Работа с шаблоном

Сборка проекта:

```bash
make all
```

Очистка проекта:

```bash
make clean
```

Загрузка образа в МК:

```bash
make flash
```
