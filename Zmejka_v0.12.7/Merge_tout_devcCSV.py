import os
import glob
import pandas as pd

directory_path = "path/to/your/csv/files"

file_pattern = os.path.join(directory_path, "*_tout_?+_devc.csv")

csv_files = glob.glob(file_pattern)

merged_df = pd.DataFrame()

# Loop over the files
for i, file in enumerate(csv_files):
    df = pd.read_csv(file, skipinitialspace=True)
    
    if i == 0:
        merged_df = df
    else:
        merged_df = pd.concat([merged_df, df[2:]], ignore_index=True)

merged_df.to_csv(os.path.join(directory_path, "merged_output.csv"), index=False)

print("Merging complete. The merged file is saved as 'merged_output.csv'.")
