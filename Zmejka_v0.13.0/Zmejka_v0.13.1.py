import os
import configparser
import flet as ft
from flet import FilePicker, FilePickerResultEvent

from fds_handler import check_and_run_fds

def main(page: ft.Page):
    def create_ini_file(full_path, file_name, folder_path):
        script_dir = os.path.dirname(os.path.abspath(__file__))
        ini_folder = os.path.join(script_dir, 'inis')
        os.makedirs(ini_folder, exist_ok=True)

        ini_path = os.path.join(ini_folder, 'dotfdsinfo.ini')
        config = configparser.ConfigParser()
        
        dotfdsrp = os.path.dirname(full_path)
        
        config['FILE_INFO'] = {
            'dotfdsfp': full_path,
            'dotfdsfn': file_name,
            'dotfdsrp': folder_path,
        }
        
        with open(ini_path, 'w') as configfile:
            config.write(configfile)
    
    def read_ini_file():
        script_dir = os.path.dirname(os.path.abspath(__file__))
        ini_folder = os.path.join(script_dir, 'inis')
        ini_path = os.path.join(ini_folder, 'dotfdsinfo.ini')
        
        config = configparser.ConfigParser()
        if os.path.exists(ini_path):
            config.read(ini_path)
            full_path = config.get('FILE_INFO', 'dotfdsfp', fallback='')
            file_name = config.get('FILE_INFO', 'dotfdsfn', fallback='')
            folder_path = config.get('FILE_INFO', 'dotfdsrp', fallback='')
            return full_path, file_name, folder_path
        else:
            return '', ''

    def file_picker_callback(e: FilePickerResultEvent):
        if e.files:
            selected_file = e.files[0]
            full_path = selected_file.path
            file_directory = os.path.dirname(full_path)
            file_basename = os.path.basename(full_path)
            
            folder_path.value = file_directory
            file_name.value = file_basename
            page.update()
            
            create_ini_file(full_path, file_basename, file_directory)
    
    folder_path = ft.TextField(label="Folder Path", width=500)
    file_name = ft.TextField(label="File Name", width=500)
    
    initial_dotfdsfp, initial_dotfdsfn, initial_dotfds_folderpath = read_ini_file()
    folder_path.value = initial_dotfds_folderpath
    file_name.value = initial_dotfdsfn
    
    file_picker = FilePicker(on_result=file_picker_callback)
    
    browse_button = ft.OutlinedButton("Browse .fds", on_click=lambda _: file_picker.pick_files(allowed_extensions=["fds"]))
    start_button = ft.OutlinedButton("Start", on_click=lambda _: check_and_run_fds())
    pause_button = ft.OutlinedButton("Pause", on_click=lambda _: pause_fds())
    stop_button = ft.OutlinedButton("Stop", on_click=lambda _: stop_fds())
    kill_button = ft.OutlinedButton("Kill", on_click=lambda _: kill_fds())
    
    page.add(
        ft.Row([folder_path, browse_button]),
        ft.Row([file_name, start_button, pause_button, stop_button, kill_button]),
        file_picker
    )
    

if __name__ == "__main__":
    ft.app(target=main)
