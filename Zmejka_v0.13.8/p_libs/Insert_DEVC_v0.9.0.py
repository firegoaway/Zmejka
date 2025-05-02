import os
import sys
import configparser
import re
import time
import subprocess
from pathlib import Path
from PyQt6.QtWidgets import (QApplication, QMainWindow, QWidget, QLabel, QLineEdit, 
                            QVBoxLayout, QHBoxLayout, QGridLayout, QPushButton, 
                            QTextEdit, QMessageBox, QGroupBox, QStatusBar, QTabWidget,
                            QComboBox, QCheckBox, QFormLayout, QProgressBar,
                            QSpacerItem, QSizePolicy, QFrame, QScrollArea, QFileDialog)
from PyQt6.QtCore import Qt, QSize, QLocale, QRegularExpression
from PyQt6.QtGui import (QPalette, QColor, QDoubleValidator, QFont, QIcon, 
                        QRegularExpressionValidator)

class InsertDEVCApp(QMainWindow):
    def __init__(self, unique_id=None):
        super().__init__()
        current_directory = os.path.dirname(__file__)
        parent_directory = os.path.abspath(os.path.join(current_directory, os.pardir))
        icon_path = os.path.join(parent_directory, '.gitpics', 'favicon_DEVC.ico')
        self.setWindowIcon(QIcon(icon_path))
        
        # Установка свойств приложения
        self.setWindowTitle("Insert_DEVC v0.9.0")
        self.setMinimumSize(600, 660)
        
        self.unique_id = unique_id
        self.script_dir = os.path.dirname(os.path.abspath(__file__))
        self.base_dir = os.path.dirname(self.script_dir)
        
        # Установка интерфейса
        self._setup_palette()
        self._setup_ui()
        
        # Загрузка уникального ID, если он получен
        if unique_id:
            self.load_unique_id()
            
    def _setup_palette(self):
        """Установка цветовой палитры для приложения."""
        palette = QPalette()
        # Определение современной, светлой цветовой схемы
        palette.setColor(QPalette.ColorRole.Window, QColor(248, 250, 252))  # Очень светло-синяя
        palette.setColor(QPalette.ColorRole.WindowText, QColor(30, 41, 59))  # Темно-синяя
        palette.setColor(QPalette.ColorRole.Base, QColor(255, 255, 255))  # Чистая белая
        palette.setColor(QPalette.ColorRole.AlternateBase, QColor(241, 245, 249))  # Светло-синяя
        palette.setColor(QPalette.ColorRole.ToolTipBase, QColor(255, 255, 255))  # Чистая белая
        palette.setColor(QPalette.ColorRole.ToolTipText, QColor(30, 41, 59))  # Темно-синяя
        palette.setColor(QPalette.ColorRole.Text, QColor(30, 41, 59))  # Темно-синяя
        palette.setColor(QPalette.ColorRole.Button, QColor(186, 230, 253))  # Светло-синяя кнопки
        palette.setColor(QPalette.ColorRole.ButtonText, QColor(3, 105, 161))  # Темно-синяя текст на кнопках
        palette.setColor(QPalette.ColorRole.Highlight, QColor(125, 211, 252))  # Светло-синяя выделение
        palette.setColor(QPalette.ColorRole.HighlightedText, QColor(30, 41, 59))  # Темно-синяя текст для контраста
        self.setPalette(palette)
        
    def _setup_ui(self):
        """Установка основных компонентов интерфейса."""
        # Установка шрифта приложения
        app_font = QFont("Segoe UI", 10)
        QApplication.setFont(app_font)
        
        # Создание строки состояния
        self.statusBar = QStatusBar()
        self.statusBar.setStyleSheet("QStatusBar { background-color: rgb(241, 245, 249); color: rgb(30, 41, 59); }")
        self.setStatusBar(self.statusBar)
        self.statusBar.showMessage("Готово")
        
        # Создание области прокрутки
        scroll_area = QScrollArea()
        scroll_area.setWidgetResizable(True)
        scroll_area.setFrameShape(QFrame.Shape.NoFrame)
        self.setCentralWidget(scroll_area)
        
        # Создание центрального виджета
        central_widget = QWidget()
        scroll_area.setWidget(central_widget)
        
        # Основной макет
        main_layout = QVBoxLayout(central_widget)
        main_layout.setContentsMargins(20, 20, 20, 20)
        main_layout.setSpacing(15)
        
        # Заголовок приложения
        header = QLabel("Конструктор областей ввода DEVC в модели FDS")
        header.setFont(QFont("Segoe UI", 16, QFont.Weight.Bold))
        header.setAlignment(Qt.AlignmentFlag.AlignCenter)
        header.setStyleSheet("color: rgb(3, 105, 161); padding: 10px;")
        main_layout.addWidget(header)
        
        # Создание таб виджета
        self.tab_widget = QTabWidget()
        self.tab_widget.setStyleSheet("""
            QTabWidget::pane {
                border: 1px solid #bfdbfe;
                border-radius: 5px;
                background-color: white;
            }
            QTabBar::tab {
                background-color: #e0f2fe;
                color: #0284c7;
                padding: 8px 16px;
                margin-right: 2px;
                border-top-left-radius: 4px;
                border-top-right-radius: 4px;
            }
            QTabBar::tab:selected {
                background-color: #bae6fd;
                color: #0369a1;
                font-weight: bold;
            }
            QTabBar::tab:hover:!selected {
                background-color: #7dd3fc;
            }
        """)
        main_layout.addWidget(self.tab_widget)
        
        # Создание главной таб
        self.main_tab = QWidget()
        
        self.tab_widget.addTab(self.main_tab, "Главная")
        
        # Установка главной таб
        self._setup_main_tab()
        
        # Добавление кнопки применения внизу
        self.apply_button = QPushButton("Применить")
        self.apply_button.setStyleSheet(self._get_button_style())
        self.apply_button.setMinimumHeight(40)
        self.apply_button.clicked.connect(self.on_apply)
        main_layout.addWidget(self.apply_button)
        
    def _setup_main_tab(self):
        """Sets up the main tab with input fields."""
        main_layout = QVBoxLayout(self.main_tab)
        main_layout.setContentsMargins(15, 15, 15, 15)
        main_layout.setSpacing(15)
        
        # Раздел выбора параметра
        param_group = QGroupBox("Параметр, воздействующий на ИП ДОТ")
        param_group.setStyleSheet(self._get_group_box_style())
        param_layout = QVBoxLayout(param_group)
        param_layout.setSpacing(10)
        
        # Комбо-бокс выбора параметра
        quantity_layout = QHBoxLayout()
        quantity_label = QLabel("Выберите параметр:")
        quantity_label.setMinimumWidth(150)
        self.quantity_combo = QComboBox()
        self.quantity_combo.addItems([
            "VISIBILITY", 
            "EXTINCTION COEFFICIENT", 
            "OPTICAL DENSITY", 
            "TEMPERATURE"
        ])
        self.quantity_combo.setStyleSheet(self._get_combo_style())
        self.quantity_combo.currentIndexChanged.connect(self.on_quantity_selected)
        quantity_layout.addWidget(quantity_label)
        quantity_layout.addWidget(self.quantity_combo)
        param_layout.addLayout(quantity_layout)
        
        # Прогресс-бар для параметра
        self.quantity_progress = QProgressBar()
        self.quantity_progress.setStyleSheet(self._get_progress_bar_style())
        self.quantity_progress.setValue(0)
        param_layout.addWidget(self.quantity_progress)
        
        main_layout.addWidget(param_group)
        
        # Раздел параметров помещения
        room_group = QGroupBox("Параметры помещения")
        room_group.setStyleSheet(self._get_group_box_style())
        room_layout = QFormLayout(room_group)
        room_layout.setSpacing(15)
        
        # Высота помещения
        hz_layout = QHBoxLayout()
        self.hz_input = QLineEdit()
        self.hz_input.setStyleSheet(self._get_input_style())
        self.hz_input.setPlaceholderText("Введите высоту помещения")
        
        # Использование регулярного выражения для проверки ввода
        regex_pattern = QRegularExpression(r'[0-9.]+')
        decimal_regex = QRegularExpressionValidator(regex_pattern)
        self.hz_input.setValidator(decimal_regex)
        
        hz_layout.addWidget(self.hz_input)
        hz_layout.addWidget(QLabel("м"))
        room_layout.addRow("Высота помещения (Hпом):", hz_layout)
        
        # Прогресс-бар для высоты
        self.hz_progress = QProgressBar()
        self.hz_progress.setStyleSheet(self._get_progress_bar_style())
        self.hz_progress.setValue(0)
        room_layout.addRow("", self.hz_progress)
        
        # Отметка пола
        zh_layout = QHBoxLayout()
        self.zh_input = QLineEdit()
        self.zh_input.setStyleSheet(self._get_input_style())
        self.zh_input.setPlaceholderText("Введите отметку пола")
        
        # Использование регулярного выражения для проверки ввода
        regex_pattern_negative = QRegularExpression(r'-?[0-9.]+')
        self.zh_input.setValidator(QRegularExpressionValidator(regex_pattern_negative))
        
        zh_layout.addWidget(self.zh_input)
        zh_layout.addWidget(QLabel("м"))
        room_layout.addRow("Абсолютная отметка пола (Zпом):", zh_layout)
        
        # Прогресс-бар для отметки пола
        self.zh_progress = QProgressBar()
        self.zh_progress.setStyleSheet(self._get_progress_bar_style())
        self.zh_progress.setValue(0)
        room_layout.addRow("", self.zh_progress)
        
        main_layout.addWidget(room_group)
        
        # Раздел одиночного извещателя
        detector_group = QGroupBox("Конфигурация пожарных извещателей")
        detector_group.setStyleSheet(self._get_group_box_style())
        detector_layout = QVBoxLayout(detector_group)
        
        self.only_one_check = QCheckBox("Помещение подлежит оборудованию 1 пожарным извещателем")
        self.only_one_check.setStyleSheet(self._get_checkbox_style())
        self.only_one_check.toggled.connect(self.on_only_one_changed)
        detector_layout.addWidget(self.only_one_check)
        
        # Площадь помещения (только видима, когда флажок отмечен)
        area_layout = QHBoxLayout()
        area_label = QLabel("Площадь помещения:")
        self.area_input = QLineEdit()
        self.area_input.setStyleSheet(self._get_input_style())
        self.area_input.setPlaceholderText("Введите площадь")
        
        # Использование регулярного выражения для проверки ввода
        regex_pattern_area = QRegularExpression(r'[0-9.]+')
        self.area_input.setValidator(QRegularExpressionValidator(regex_pattern_area))
        
        self.area_input.setEnabled(False)
        area_layout.addWidget(area_label)
        area_layout.addWidget(self.area_input)
        area_layout.addWidget(QLabel("м²"))
        detector_layout.addLayout(area_layout)
        
        main_layout.addWidget(detector_group)
        
        # Добавление растягивающегося пространства
        main_layout.addStretch()
    
    def _get_group_box_style(self):
        """Возвращает стиль для групповых боксов."""
        return """
            QGroupBox {
                font-weight: bold;
                border: 1px solid #bfdbfe;
                border-radius: 8px;
                margin-top: 1ex;
                background-color: rgba(255, 255, 255, 200);
            }
            QGroupBox::title {
                subcontrol-origin: margin;
                left: 10px;
                padding: 0 5px;
            }
        """
    
    def _get_input_style(self):
        """Возвращает стиль для полей ввода."""
        return """
            QLineEdit {
                padding: 8px;
                border: 1px solid #cbd5e1;
                border-radius: 5px;
                background-color: white;
            }
            QLineEdit:focus {
                border: 2px solid #7dd3fc;
            }
        """
    
    def _get_combo_style(self):
        """Возвращает стиль для комбо-боксов."""
        return """
            QComboBox {
                padding: 8px;
                border: 1px solid #cbd5e1;
                border-radius: 5px;
                background-color: white;
                min-width: 200px;
            }
            QComboBox:focus {
                border: 2px solid #7dd3fc;
            }
            QComboBox::drop-down {
                subcontrol-origin: padding;
                subcontrol-position: top right;
                width: 20px;
                border-left-width: 1px;
                border-left-color: #cbd5e1;
                border-left-style: solid;
                border-top-right-radius: 5px;
                border-bottom-right-radius: 5px;
            }
        """
    
    def _get_button_style(self):
        """Возвращает стиль для кнопок."""
        return """
            QPushButton {
                background-color: #bae6fd;
                color: #0369a1;
                border: none;
                border-radius: 5px;
                padding: 10px 15px;
                font-weight: bold;
                min-width: 120px;
            }
            QPushButton:hover {
                background-color: #7dd3fc;
            }
            QPushButton:pressed {
                background-color: #0284c7;
                color: white;
            }
            QPushButton:disabled {
                background-color: #e2e8f0;
                color: #94a3b8;
            }
        """
    
    def _get_checkbox_style(self):
        """Возвращает стиль для флажков."""
        return """
            QCheckBox {
                padding: 5px;
            }
            QCheckBox::indicator {
                width: 18px;
                height: 18px;
            }
            QCheckBox::indicator:unchecked {
                border: 2px solid #94a3b8;
                border-radius: 4px;
                background-color: white;
            }
            QCheckBox::indicator:checked {
                border: 2px solid #0284c7;
                border-radius: 4px;
                background-color: #0284c7;
            }
        """
    
    def _get_progress_bar_style(self):
        """Возвращает стиль для прогресс-баров."""
        return """
            QProgressBar {
                border: 1px solid #cbd5e1;
                border-radius: 5px;
                text-align: center;
                background-color: white;
                height: 12px;
            }
            QProgressBar::chunk {
                background-color: #0ea5e9;
                border-radius: 4px;
            }
        """
    
    def on_quantity_selected(self, index):
        """Обработка выбора параметра."""
        # Обновление прогресс-бара
        self.quantity_progress.setValue(100)
        self.statusBar.showMessage(f"Выбран параметр: {self.quantity_combo.currentText()}")
    
    def on_only_one_changed(self, checked):
        """Обработка изменения состояния флажка 'один извещатель'."""
        self.area_input.setEnabled(checked)
        if checked:
            self.statusBar.showMessage("Активирован режим одиночного извещателя")
        else:
            self.statusBar.showMessage("Активирован режим стандартного расположения извещателей")
    
    def validate_inputs(self):
        """Проверка всех введенных пользователем данных."""
        # Проверка выбора параметра
        if self.quantity_combo.currentIndex() == -1:
            QMessageBox.warning(self, "Ошибка ввода", "Выберите параметр, воздействующий на ИП ДОТ!")
            return False
        
        # Проверка высоты помещения
        hz = self.hz_input.text().strip()
        try:
            hz_float = float(hz)
            if hz_float <= 0:
                raise ValueError("Высота должна быть положительным числом")
        except ValueError:
            QMessageBox.warning(self, "Ошибка ввода", "Введите корректное значение высоты помещения!")
            self.hz_input.setFocus()
            return False
        
        # Обновление прогресс-бара для высоты
        self.hz_progress.setValue(100)
        
        # Проверка отметки пола
        zh = self.zh_input.text().strip()
        if not zh:
            QMessageBox.warning(self, "Ошибка ввода", "Введите значение высотной отметки пола!")
            self.zh_input.setFocus()
            return False
        
        # Обновление прогресс-бара для отметки пола
        self.zh_progress.setValue(100)
        
        # Проверка площади помещения, если выбран один извещатель
        if self.only_one_check.isChecked():
            fpom = self.area_input.text().strip()
            if not fpom:
                QMessageBox.warning(self, "Ошибка ввода", "Введите значение площади помещения!")
                self.area_input.setFocus()
                return False
        
        return True
    
    def on_apply(self):
        """Обработка нажатия кнопки 'Применить'."""
        # Проверка введенных данных
        if not self.validate_inputs():
            return
        
        # Получение значений
        quantity = self.quantity_combo.currentText()
        hz = float(self.hz_input.text())
        zh = float(self.zh_input.text())
        
        # Сохранение значения параметра в INI файл
        self.write_to_ini("IniQuantity.ini", "IniQuantity", "Quantity", quantity)
        
        # Сохранение высоты в INI файл
        self.write_to_ini("IniHZ.ini", "IniHZ", "HZ", self.hz_input.text())
        
        # Сохранение отметки пола в INI файл
        self.write_to_ini("IniZh.ini", "IniZh", "Zh", self.zh_input.text())
        
        # Обработка площади помещения, если флажок отмечен
        if self.only_one_check.isChecked():
            fpom = self.area_input.text()
            self.write_to_ini("IniFpom.ini", "IniFpom", "Fpom", fpom)
        
        # Обработка файла FDS
        self.process_fds_file(quantity, hz, zh)
        
        # Выход из приложения
        QApplication.quit()
    
    def process_fds_file(self, quantity, hz, zh):
        """Обработка файла FDS для добавления DEVC записей."""
        # Чтение пути к файлу из INI
        file_path = None
        
        if self.unique_id:
            ini_path = os.path.join(self.base_dir, "inis", f"filePath_{self.unique_id}.ini")
            file_path = self.read_from_ini(ini_path, "filePath", "filePath")
        
        if not file_path:
            # Если путь к файлу не найден, запросите у пользователя выбрать файл
            file_path, _ = QFileDialog.getOpenFileName(
                self, "Выберите файл FDS", "", "FDS файлы (*.fds);;Все файлы (*)"
            )
            
            if not file_path:
                QMessageBox.warning(self, "Отмена", "Операция отменена пользователем.")
                return
        
        if not os.path.exists(file_path):
            QMessageBox.critical(self, "Ошибка", f"Файл не найден: {file_path}")
            return
            
        # Установка путей входного и выходного файлов
        input_file = file_path
        folder_path = os.path.dirname(input_file)
        file_name = os.path.splitext(os.path.basename(input_file))[0]
        output_file = os.path.join(folder_path, f"{file_name}_tout.fds")
        
        # Установка порога срабатывания и направления срабатывания в зависимости от параметра
        if quantity == "VISIBILITY":
            setpoint = 28.5709
            trip_direction = -1
        elif quantity == "EXTINCTION COEFFICIENT":
            setpoint = 0.2
            trip_direction = 1
        elif quantity == "OPTICAL DENSITY":
            setpoint = 0.023
            trip_direction = 1
        elif quantity == "TEMPERATURE":
            setpoint = 58
            trip_direction = 1
        
        # Сохранение порога срабатывания в INI файл
        self.write_to_ini("IniSetpoint.ini", "IniSetpoint", "setpoint", str(setpoint))
        
        # Чтение файла FDS
        try:
            with open(input_file, 'r', encoding='utf-8') as f:
                fds_contents = f.read()
        except Exception as e:
            QMessageBox.critical(self, "Ошибка", f"Не удалось прочитать файл: {str(e)}")
            return
            
        # Обработка файла
        lines = fds_contents.split('\n')
        new_contents = []
        mesh_index = 0
        
        for line in lines:
            line = line.strip()
            
            # Обновление CHID, если найдено
            if "&HEAD" in line and "CHID=" in line:
                line = re.sub(r"CHID='([^']*)'", r"CHID='\1_tout'", line)
            
            # Обработка MESH строк
            if "&MESH" in line:
                mesh_index += 1
                
                # Извлечение параметров сетки
                match = re.search(r"IJK=(\d+),(\d+),(\d+).*?XB=([-\d\.]+),([-\d\.]+),([-\d\.]+),([-\d\.]+),([-\d\.]+),([-\d\.]+)", line)
                if match:
                    i, j, k = int(match.group(1)), int(match.group(2)), int(match.group(3))
                    x1, x2 = float(match.group(4)), float(match.group(5))
                    y1, y2 = float(match.group(6)), float(match.group(7))
                    z1, z2 = float(match.group(8)), float(match.group(9))
                    
                    delta_x = (x2 - x1) / i
                    delta_y = (y2 - y1) / j
                    delta_z = (z2 - z1) / k
                    
                    # Расчет координаты Z для устройств
                    z = round(round(zh + hz - delta_z, 2) - (delta_z / 3) - 0.01, 2)
                    
                    # Сохранение Z в INI файл
                    self.write_to_ini("IniZ.ini", "IniZ", "Z", str(z))
                    
                    # Генерация DEVC строк
                    for x_index in range(i):
                        x = x1 + x_index * delta_x
                        for y_index in range(j):
                            y = y1 + (y_index - 1) * delta_y
                            
                            actual_x = round(x + delta_x, 2)
                            actual_y = round(y + delta_y, 2)
                            
                            devc_line = f"&DEVC ID='DEVC_X{x_index + 1}Y{y_index + 1}_MESH_{mesh_index}' " \
                                      f"QUANTITY='{quantity}' XYZ={actual_x},{actual_y},{z}, " \
                                      f"SETPOINT={setpoint}, TRIP_DIRECTION={trip_direction}/"
                            
                            new_contents.append(devc_line)
            
            # Добавление исходной строки
            new_contents.append(line)
            
        # Сохранение deltaZ в INI файл
        self.write_to_ini("InideltaZ.ini", "InideltaZ", "deltaZ", str(delta_z))
        
        # Запись в выходной файл
        try:
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write('\n'.join(new_contents))
            QMessageBox.information(self, "Успешно", f"Новый файл создан: {output_file}")
        except Exception as e:
            QMessageBox.critical(self, "Ошибка", f"Не удалось создать файл: {str(e)}")
    
    def load_unique_id(self):
        """Загрузка уникального ID из соответствующего INI файла без бесконечного ожидания."""
        if not self.unique_id:
            self.statusBar.showMessage("Unique ID не указан. Используется режим без ID.")
            return
            
        # Проверка наличия INI файла с UniqueID
        unique_id_path = os.path.join(self.base_dir, "inis", f"UniqueID_{self.unique_id}.ini")
        
        # Максимальное ожидание 2 секунды
        max_wait_time = 2  # секунды
        start_time = time.time()
        flag_path = os.path.join(self.base_dir, "inis", f"flag_{self.unique_id}.txt")
        
        while not os.path.exists(flag_path) and time.time() - start_time < max_wait_time:
            time.sleep(0.1)
        
        if not os.path.exists(unique_id_path):
            self.statusBar.showMessage(f"INI файл для ID {self.unique_id} не найден.")
            return
            
        # Чтение UniqueID из INI, если он существует
        config = configparser.ConfigParser()
        try:
            config.read(unique_id_path, encoding='utf-16')
            if config.has_section("UniqueID") and config.has_option("UniqueID", "UniqueID"):
                self.unique_id = config.get("UniqueID", "UniqueID")
                self.statusBar.showMessage(f"Unique ID загружен: {self.unique_id}")
            else:
                self.statusBar.showMessage(f"В INI файле {unique_id_path} не найдена секция/опция UniqueID.")
        except Exception as e:
            self.statusBar.showMessage(f"Ошибка чтения UniqueID: {str(e)}")
            # Не выходить - позволить приложению продолжать работу
    
    def write_to_ini(self, ini_file, section, key, value):
        """Запись значения в INI файл."""
        ini_path = os.path.join(self.base_dir, "inis", ini_file)
        config = configparser.ConfigParser()
        if os.path.exists(ini_path):
            config.read(ini_path, encoding='utf-16')
        
        if not config.has_section(section):
            config.add_section(section)
        
        config.set(section, key, value)
        
        with open(ini_path, 'w', encoding='utf-16') as f:
            config.write(f)
    
    def read_from_ini(self, ini_path, section, key):
        """Чтение значения из INI файла."""
        if not os.path.exists(ini_path):
            return None
        
        config = configparser.ConfigParser()
        config.read(ini_path, encoding='utf-16')
        
        try:
            return config.get(section, key)
        except:
            return None

if __name__ == "__main__":
    unique_id = sys.argv[1] if len(sys.argv) > 1 else None
    
    app = QApplication(sys.argv)
    window = InsertDEVCApp(unique_id)
    window.show()
    sys.exit(app.exec())
