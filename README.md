# Zmejka

> Язык программы: **AHK**

> Интерфейс: **нативный**

## Особенности и описание работы утилиты
Программа взаимодействует с Fire Dynamics Simulator, raw-файлами .fds и консольной средой FDS, позволяя запускать, останавливать и продолжать моделирование пожара в любой удобный момент времени.

## Как установить и пользоваться
|	№ п/п	|	Действие	|
|---------|---------|
|	1	|	Скачайте последнюю версию **Zmejka_SFX.exe** в разделе [Releases](https://github.com/firegoaway/Zmejka/releases);	|
|	2	|	Запустите **Zmejka_SFX.exe**.	|
|	3	|	Нажмите **"Browse .fds"** и выберите файл сценария .fds	|
|	4a	|	Нажмите **"Check FDS"** и дождитесь завершения установки актуальной версии FDS	|
|	4b	|	Нажмите **"Browse fds.exe"** и укажите путь к fds.exe вручную	|
|	5	|	**"Start"** - запуск и возобновление моделирования пожара	|
|	6	|	**"Pause"** - поставить моделирование пожара на паузу	|
|	7	|	**"Stop"** - остановка моделирования пожара	|
|	8	|	**"Kill"** - прервать моделирование пожара без сохранения прогресса	|

## Статус разработки
> Альфа

## Реализованные функции
1. Старт, стоп, пауза и продолжение моделирования пожара
2. Скачивание актуальной версии FDS с официального репозитория при первом запуске
3. Проверка наличия установленного репозитория FDS
4. Снятие процесса модирования пожара (kill)

## Планируемые функции
5. Перебор структуры fds-файла и выявление ошибок
6. Автоматическое распараллеливание процессов FDS
7. Просмотр журнала и состояния моделирования для нескольких процессов FDS
8. Таблица сценариев
9. Настройки

## Профилактика вирусов и угроз
- Утилита "Zmejka" предоставляется "как есть".
- Актуальная версия утилиты доступна в разделе [Releases](https://github.com/firegoaway/Zmejka/releases).
- Файлы, каким-либо образом полученные не из текущего репозитория, несут потенциальную угрозу вашему ПК.
- Файл с расширением .exe, полученный из данного репозитория, имеет уникальную Хэш-сумму, позволяющую отличить оригинальную утилиту от подделки.
- Хэш-сумма обновляется только при обновлении версии утилиты и всегда доступна в конце файла **README.md**.

# Актуальная Хэш-сумма
> **c3a20e6f665e3a69a71cefec6a44647c**