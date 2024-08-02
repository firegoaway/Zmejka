import flet as ft
import subprocess
from pathlib import Path

# Define paths
ahk_embed_path = Path(__file__).parent / "ahk_embed"
ahk_exe = ahk_embed_path / "AutoHotkeyU64.exe"

# Function to run AHK scripts
def run_ahk_script(script_name, *args):
    script_path = ahk_embed_path / script_name
    if script_path.exists():
        cmd = [ahk_exe, script_path, *args]
        subprocess.run(cmd)
    else:
        print(f"Script {script_path} not found.")

# Main function for GUI
def main(page: ft.Page):
    # Read ini files
    ini_path = Path.cwd()
    fds_path = ""
    mpi_path = ""

    fds_ini = ini_path / "FDSpath.ini"
    mpi_ini = ini_path / "MPIpath.ini"

    if fds_ini.exists():
        with open(fds_ini, "r") as ini:
            fds_path = ini.read().strip().split("=")[-1]

    if mpi_ini.exists():
        with open(mpi_ini, "r") as ini:
            mpi_path = ini.read().strip().split("=")[-1]

    # Basic GUI elements
    folder_path = ft.TextField(label="Folder Path", value="Enter fds file folder path here", width=240)
    file_name = ft.TextField(label="File Name", value="File name is stored here", width=240)
    fds_path_input = ft.TextField(label="FDS Path", value=fds_path, width=240)
    mpi_path_input = ft.TextField(label="MPI Path", value=mpi_path, width=240)
    allow_dt_restart = ft.Checkbox(label="Allow DT_RESTART")

    def browse_file(e):
        file_dialog = ft.FilePicker(on_result=set_file)
        page.overlay.append(file_dialog)
        file_dialog.pick_files(allow_multiple=False, file_type="file", allowed_extensions=["fds"])

    def set_file(e: ft.FilePickerResultEvent):
        if e.files:
            folder_path.value = e.files[0].path
            page.update()

    def browse_exe(e, field):
        exe_dialog = ft.FilePicker(on_result=lambda e: set_exe(e, field))
        page.overlay.append(exe_dialog)
        exe_dialog.pick_files(allow_multiple=False, file_type="file", allowed_extensions=["exe"])

    def set_exe(e: ft.FilePickerResultEvent, field):
        if e.files:
            field.value = e.files[0].path
            page.update()

    def check_fds(e):
        run_ahk_script("libs\CheckFDSInstallation.ahk")

    def start_calculation(e):
        run_ahk_script(
            "libs\StartButton.ahk",
            fds_path_input.value,
            mpi_path_input.value,
            folder_path.value,
            file_name.value
        )

    def pause_calculation(e):
        run_ahk_script(
            "libs\PauseButton.ahk",
            folder_path.value,
            file_name.value
        )

    def stop_calculation(e):
        run_ahk_script(
            "libs\StopButton.ahk",
            folder_path.value,
            file_name.value
        )

    def kill_process(e):
        run_ahk_script(
            "libs\KillButton.ahk",
            folder_path.value,
            file_name.value
        )

    # Layout
    general_tab = ft.Column([
        folder_path,
        file_name,
        ft.Row([
            ft.ElevatedButton(text="Browse .fds", on_click=browse_file),
            ft.ElevatedButton(text="Browse fds.exe", on_click=lambda e: browse_exe(e, fds_path_input)),
            ft.ElevatedButton(text="Browse mpi.exe", on_click=lambda e: browse_exe(e, mpi_path_input)),
        ]),
        ft.Row([
            ft.ElevatedButton(text="Start", on_click=start_calculation),
            ft.ElevatedButton(text="Pause", on_click=pause_calculation),
            ft.ElevatedButton(text="Stop", on_click=stop_calculation),
            ft.ElevatedButton(text="Kill", on_click=kill_process),
            ft.ElevatedButton(text="Check FDS", on_click=check_fds),
        ]),
        fds_path_input,
        mpi_path_input
    ])

    settings_tab = ft.Column([
        allow_dt_restart,
        ft.Row([ft.Text("Timer"), ft.TextField()]),
        ft.Row([ft.Text("Check FDS path"), ft.ElevatedButton(text="Check FDS", on_click=check_fds)]),
        ft.ElevatedButton(text="Run Insert_DEVC", on_click=lambda e: run_ahk_script("modules\Insert_DEVC.exe")),
        ft.ElevatedButton(text="Run PCTT", on_click=lambda e: run_ahk_script("modules\PCTT.exe")),
        ft.ElevatedButton(text="Run PFED", on_click=lambda e: run_ahk_script("modules\PFED.exe")),
        ft.ElevatedButton(text="Run SURF_FIX", on_click=lambda e: run_ahk_script("modules\SURF_FIX.exe")),
    ])

    # Tabs for the UI
    tabs = ft.Tabs(
        tabs=[
            ft.Tab(text="General", content=general_tab),
            ft.Tab(text="Settings", content=settings_tab)
        ]
    )

    page.add(tabs)

ft.app(target=main)