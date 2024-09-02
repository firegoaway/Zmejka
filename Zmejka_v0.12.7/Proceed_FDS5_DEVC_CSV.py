import pandas as pd
import time
import csv
import configparser

def read_ini_file(self, ini_file):
    config = configparser.ConfigParser()
    with open(ini_file, 'r', encoding='utf-16') as f:
        config.read_file(f)
    return config['filePath']['filePath']

def modify_csv(filePath):
    # Загружаем CSV файл
    df = pd.read_csv(filePath, header=None)

    # Вносим правки во вторую полосу (заголовки)
    if df.shape[0] > 1:
        # Переименовываем "FDS Time" в "Time"
        df.iloc[1, 0] = "Time"

    # Сносим вторую колонку
    df = df.drop(columns=1)

    # Сохраняем CSV
    df.to_csv(filePath, header=False, index=False)

def add_quotes_to_headers(filePath):
    with open(filePath, mode='r', newline='') as infile:
        reader = list(csv.reader(infile))

        # Предполагается, что первая полоса - это единицы измерения
        measure_units = reader[0]
        
        # Отрабатываем вторую полосу (заголовки)
        headers = reader[1]
        headers = [f'"{header}"' if header != 'Time' else header for header in headers]

        # Остальная часть данных
        data = reader[2:]

    # Вносим изменения
    with open(filePath, mode='w', newline='') as outfile:
        writer = csv.writer(outfile, quoting=csv.QUOTE_MINIMAL)
        writer.writerow(measure_units)  # Не трогаем единицы измерения
        outfile.write(','.join(headers) + '\n')  # Каждый заголовок уточняем в лоб
        writer.writerows(data)  # Пишем остальную часть данных


ini_path = 'filePath.ini'
fds_path = self.read_ini_file(ini_path)

modify_csv(filePath)
time.sleep(1) # Ждём секунду, на всякий случай
add_quotes_to_headers(filePath)

