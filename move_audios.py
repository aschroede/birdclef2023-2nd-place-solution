import os
import shutil

def flatten_audio_directory(base_audio_dir="train_audios",
                            source_sub_path="birdclef-2023/train_audio",
                            audio_extensions=('.ogg', '.wav', '.mp3')):
    """
    Moves all audio files from nested subdirectories within source_sub_path
    up to the base_audio_dir.

    Args:
        base_audio_dir (str): The target directory where all audio files should end up.
                              (e.g., 'inputs/train_audios' or 'train_audios')
        source_sub_path (str): The path *relative to base_audio_dir* where the deeply
                               nested audio files currently reside.
                               (e.g., 'birdclef-2023/train_audio')
        audio_extensions (tuple): A tuple of audio file extensions to look for.
    """
    full_source_dir = os.path.join(base_audio_dir, source_sub_path)
    full_target_dir = base_audio_dir # Files will be moved directly into base_audio_dir

    if not os.path.exists(full_source_dir):
        print(f"Error: Source directory '{full_source_dir}' not found.")
        print("Please ensure you are running this script from the correct parent directory,")
        print(f"and that '{source_sub_path}' exists inside '{base_audio_dir}'.")
        return

    print(f"Starting to flatten audio files from: {full_source_dir}")
    print(f"Moving files to: {full_target_dir}")
    print("-" * 50)

    moved_count = 0
    skipped_count = 0
    empty_dirs = []

    # Walk through the source directory
    for root, dirs, files in os.walk(full_source_dir, topdown=False):
        for filename in files:
            if filename.lower().endswith(audio_extensions):
                source_path = os.path.join(root, filename)
                target_path = os.path.join(full_target_dir, filename)

                if os.path.exists(target_path):
                    print(f"Warning: File '{filename}' already exists in target. Skipping: {source_path}")
                    skipped_count += 1
                    continue

                try:
                    shutil.move(source_path, target_path)
                    print(f"Moved: {source_path} -> {target_path}")
                    moved_count += 1
                except Exception as e:
                    print(f"Error moving {source_path}: {e}")
                    skipped_count += 1
        # After processing files, if the directory is empty, add it to the list for removal
        if not os.listdir(root) and root != full_source_dir:
            empty_dirs.append(root)

    print("-" * 50)
    print(f"Finished moving audio files.")
    print(f"Total files moved: {moved_count}")
    print(f"Total files skipped (due to existence or error): {skipped_count}")

    # Clean up empty directories
    print("\nCleaning up empty directories...")
    # Sort in reverse order to delete deepest directories first
    empty_dirs.sort(key=len, reverse=True)
    cleaned_dirs_count = 0
    for dir_path in empty_dirs:
        try:
            os.rmdir(dir_path)
            print(f"Removed empty directory: {dir_path}")
            cleaned_dirs_count += 1
        except OSError as e:
            # This can happen if another process created files or if it's not truly empty
            print(f"Could not remove directory {dir_path}: {e}")
    print(f"Total empty directories removed: {cleaned_dirs_count}")

    # Optionally remove the top-level now-empty 'birdclef-2023' directory
    if os.path.exists(full_source_dir) and not os.listdir(full_source_dir):
        try:
            os.rmdir(full_source_dir)
            print(f"Removed now-empty top source directory: {full_source_dir}")
        except OSError as e:
            print(f"Could not remove top source directory {full_source_dir}: {e}")


if __name__ == "__main__":
    # Adjust these paths based on your current setup.
    # From your last screenshot, it seems you have a 'train_audios' at the project root
    # with 'birdclef-2023/train_audio' inside it.
    # The goal is to move files to the parent 'train_audios'.

    # Assuming you run this script from the 'birdclef2023-2nd-place-solution' directory:
    # base_audio_dir: The folder where you want all OGGs to end up (e.g., 'inputs/train_audios')
    # source_sub_path: The nested path relative to base_audio_dir where OGGs currently are (e.g., 'birdclef-2023/train_audio')

    # Given your last screenshot, you have a top-level `train_audios` and then `inputs/train_audios`.
    # It seems your *actual* audio files are under the top-level `train_audios/birdclef-2023/train_audio`.
    # And the script expects them in `inputs/train_audios`.

    # Let's assume you want to move the files from
    # `/home/andrew/.../birdclef2023-2nd-place-solution/train_audios/birdclef-2023/train_audio/`
    # to
    # `/home/andrew/.../birdclef2023-2nd-place-solution/inputs/train_audios/`

    # This script will move files from the `train_audios` (top-level) into your `inputs/train_audios`.

    # This is the path to your current 'inputs/train_audios' where files should *end up*.
    target_base_dir = "inputs/train_audios"

    # This is the path to the current *source* of the audio files, which is at the project root.
    source_root_dir = "train_audios"
    source_nested_structure = "birdclef-2023/train_audio" # This is the specific sub-path *within* source_root_dir

    # First, make sure the target directory for the *flattened* files exists
    os.makedirs(target_base_dir, exist_ok=True)

    # Now, let's modify the function to handle this specific scenario.
    # We will walk through the source_root_dir + source_nested_structure
    # and move files to target_base_dir.

    full_source_path_to_walk = os.path.join(source_root_dir, source_nested_structure)
    print(f"Starting to move files from deep within: {full_source_path_to_walk}")
    print(f"Moving all .ogg files directly into: {target_base_dir}")
    print("-" * 50)

    moved_count = 0
    skipped_count = 0
    empty_dirs_to_remove = []

    for root, dirs, files in os.walk(full_source_path_to_walk, topdown=False):
        for filename in files:
            if filename.lower().endswith('.ogg'): # Assuming .ogg as specified
                source_file_path = os.path.join(root, filename)
                destination_file_path = os.path.join(target_base_dir, filename)

                if os.path.exists(destination_file_path):
                    print(f"Warning: File '{filename}' already exists in target '{target_base_dir}'. Skipping: {source_file_path}")
                    skipped_count += 1
                    continue

                try:
                    shutil.move(source_file_path, destination_file_path)
                    print(f"Moved: {source_file_path} -> {destination_file_path}")
                    moved_count += 1
                except Exception as e:
                    print(f"Error moving {source_file_path}: {e}")
                    skipped_count += 1
        
        # After processing files in a directory, if it's empty, add it for removal
        if not os.listdir(root): # Check if directory is empty
            empty_dirs_to_remove.append(root)

    print("-" * 50)
    print(f"Finished moving audio files.")
    print(f"Total files moved: {moved_count}")
    print(f"Total files skipped (due to existence or error): {skipped_count}")

    # Now, clean up the empty directories, starting from the deepest
    empty_dirs_to_remove.sort(key=len, reverse=True)
    cleaned_dirs_count = 0
    print("\nCleaning up now-empty source directories...")
    for dir_path in empty_dirs_to_remove:
        try:
            os.rmdir(dir_path)
            print(f"Removed empty directory: {dir_path}")
            cleaned_dirs_count += 1
        except OSError as e:
            print(f"Could not remove directory {dir_path}: {e}") # Likely if it's not truly empty
    print(f"Total empty source directories removed: {cleaned_dirs_count}")

    # Finally, try to remove the top-level source path if it became empty
    if os.path.exists(source_root_dir) and not os.listdir(source_root_dir):
        try:
            os.rmdir(source_root_dir)
            print(f"Removed top-level source directory: {source_root_dir}")
        except OSError as e:
            print(f"Could not remove top-level source directory {source_root_dir}: {e}")
    elif os.path.exists(source_root_dir):
        print(f"Note: Top-level source directory '{source_root_dir}' is not empty and was not removed.")
