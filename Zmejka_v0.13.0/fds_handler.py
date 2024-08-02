import os
import configparser
import subprocess
from tkinter import messagebox

def check_and_run_fds():
    # Get the directory of the main script
    script_directory = os.path.dirname(os.path.abspath(__file__))
    inis_folder = os.path.join(script_directory, 'inis')
    
    fds_path_ini = os.path.join(inis_folder, 'FDSPath.ini')
    dotfdsinfo_ini = os.path.join(inis_folder, 'dotfdsinfo.ini')
    
    config = configparser.ConfigParser()
    
    # Default path to fds.exe
    default_fds_path = os.path.join(os.getenv('programfiles'), 'firemodels', 'FDS6', 'bin', 'fds.exe')
    
    # Check if FDSPath.ini exists and read its contents
    if not os.path.exists(fds_path_ini):
        os.makedirs(inis_folder, exist_ok=True)
        config['FDSPath'] = {'path': default_fds_path}
        with open(fds_path_ini, 'w') as configfile:
            config.write(configfile)
        fds_path = default_fds_path
    else:
        config.read(fds_path_ini)
        fds_path = config['FDSPath'].get('path', '')
        if not fds_path:
            fds_path = default_fds_path
            config['FDSPath']['path'] = default_fds_path
            with open(fds_path_ini, 'w') as configfile:
                config.write(configfile)
    
    # Check if dotfdsinfo.ini exists and read its contents
    if not os.path.exists(dotfdsinfo_ini):
        messagebox.showinfo("Info", "1 Define path to scenario.fds")
        return
    
    config.read(dotfdsinfo_ini)
    if 'FILE_INFO' not in config:
        messagebox.showinfo("Info", "2 Define path to scenario.fds")
        return
    
    dotfdsfp = config['FILE_INFO'].get('dotfdsfp', '')
    dotfdsfn = config['FILE_INFO'].get('dotfdsfn', '')
    dotfdsrp = config['FILE_INFO'].get('dotfdsrp', '')
    
    if not dotfdsrp or not dotfdsfn:
        messagebox.showinfo("Info", "3 Define path to scenario.fds")
        return
    
    scenario_file = os.path.join(dotfdsrp, dotfdsfn)
    
    if not os.path.exists(scenario_file):
        messagebox.showinfo("Info", "Scenario file does not exist: " + scenario_file)
        return
    
    # Run the fds.exe with the scenario file
    subprocess.run([fds_path, scenario_file])


# from fds_handler import check_and_run_fds
# check_and_run_fds()
