import os
import glob
import shutil
import logging
import traceback

def rename_files_remove_tout(folder_path, logger):
    """
    Renames files in a folder by removing '_tout' from their names.

    Args:
        folder_path (str): The path to the folder containing files to rename.
        logger (logging.Logger): Logger instance for logging messages.
    """
    logger.info(f"Starting rename process in folder: {folder_path}")

    folder_path = os.path.normpath(folder_path)
    if not os.path.isdir(folder_path):
        logger.error(f"Directory not found for renaming: {folder_path}")
        return

    rename_pattern = os.path.join(folder_path, '*_tout*')
    renamed_count = 0
    skipped_count = 0
    error_count = 0
    files_processed_count = 0

    try:
        files_to_process = glob.glob(rename_pattern)
        total_files_to_rename = len(files_to_process)
        logger.info(f"Found {total_files_to_rename} potential files to rename matching pattern: {rename_pattern}")

        if total_files_to_rename == 0:
            logger.info("No files found matching '_tout' pattern. Exiting rename process.")
            return

        for index, full_path in enumerate(files_to_process):
            files_processed_count += 1
            original_name = os.path.basename(full_path)

            try:
                # Basic check if it's a file and exists before proceeding
                if not os.path.isfile(full_path):
                    logger.warning(f"Skipping non-file or missing path: {full_path}")
                    skipped_count += 1
                    continue

                if "_tout" in original_name:
                    new_name = original_name.replace("_tout", "")
                    if new_name == original_name:
                        logger.debug(f"Skipping, name unchanged: {original_name}")
                        skipped_count += 1
                        continue

                    new_file_path = os.path.join(folder_path, new_name)

                    if os.path.exists(new_file_path):
                        logger.warning(f"Target file already exists, skipping rename: {new_file_path}")
                        skipped_count += 1
                        continue

                    try:
                        # Using os.rename for efficiency on the same filesystem
                        os.rename(full_path, new_file_path)
                        # logger.info(f"Renamed: '{original_name}' -> '{new_name}'") # Log less verbosely
                        renamed_count += 1
                    except OSError as rename_error:
                        logger.error(f"Error renaming '{original_name}' to '{new_name}': {rename_error}")
                        logger.debug(traceback.format_exc())
                        error_count += 1
                    except Exception as e:
                         logger.error(f"Unexpected error renaming '{original_name}' to '{new_name}': {e}")
                         logger.debug(traceback.format_exc())
                         error_count += 1

                else:
                    # Should ideally not happen with glob pattern, but handle defensively
                    logger.warning(f"Skipping, '_tout' not found in name (unexpected): {original_name}")
                    skipped_count += 1

            except Exception as process_path_error:
                logger.error(f"Critical error processing path '{full_path}': {process_path_error}")
                logger.debug(traceback.format_exc())
                error_count += 1
                # Continue to the next file

    except Exception as main_loop_error:
        logger.critical(f"Critical error during rename file search/iteration: {main_loop_error}")
        logger.debug(traceback.format_exc())
        # Estimate remaining as errors if the loop breaks prematurely
        error_count = total_files_to_rename - renamed_count - skipped_count

    finally:
        log_summary = (
            f"Rename process finished for {folder_path}. "
            f"Processed: {files_processed_count}/{total_files_to_rename}, "
            f"Renamed: {renamed_count}, Skipped: {skipped_count}, Errors: {error_count}."
        )
        logger.info(log_summary) 