# **Automating OpenAI Whisper on macOS with Automator**

## **Overview**
This project provides a simple way to run OpenAI Whisper on your Mac using Automator. With this setup, you can transcribe audio files directly from Finder with a right-click. This guide will walk you through installing dependencies, setting up the transcription script, and integrating it with Automator.

---

## **Prerequisites**
### **System Requirements**
- macOS with Apple Silicon (M1/M2/M3)
- At least **16GB RAM** for large models (smaller models work with less)
- Homebrew installed
- Python 3.11+ installed

### **Software Dependencies**
- Homebrew
- Python 3.x
- `mlx_whisper` (Whisper fork optimized for macOS)
- Automator (pre-installed on macOS)

---

## **Installation & Setup**
### **Step 1: Setting Up Your Environment**
1. **Install Homebrew** (if not already installed):
   ```sh
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Create a HuggingFace Account & Generate a Token**
   - Sign up at [HuggingFace](https://huggingface.co/)
   - Go to *Settings > Access Tokens* and create a new token (you'll need this later)

3. **Install `mlx_whisper`**
   ```sh
   pip install mlx_whisper
   ```
   - If you have Python 3.11 and encounter issues, try:
   ```sh
   pip install mlx_whisper --ignore-requires-python
   ```

4. **Update Your Zsh Configuration**
   ```sh
   nano ~/.zshrc
   ```
   Add this line at the end:
   ```sh
   export PATH="/opt/homebrew/bin:$PATH"
   ```
   Save and exit (`CTRL + X`, then `Y` and `Enter`).
   
   Apply the changes:
   ```sh
   source ~/.zshrc
   ```

---

### **Step 2: Creating the Transcription Script**
1. **Create the Script File**
   ```sh
   touch transcribe.sh
   ```

2. **Open and Edit the Script**
   Copy and paste the following into `transcribe.sh`: (Or download the file above)
   
   ```zsh
   #!/bin/zsh
   
   # Ensure Automator can find Homebrew-installed packages
   export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"
   
   # Path to mlx_whisper
   WHISPER_PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin/mlx_whisper"
   
   # Debugging logs
   DEBUG_LOG="$HOME/whisper_debug.log"
   echo "Running Whisper Script" > "$DEBUG_LOG"
   
   # Check if mlx_whisper exists
   if [[ ! -x "$WHISPER_PATH" ]]; then
       echo "Error: mlx_whisper not found at $WHISPER_PATH" | tee -a "$DEBUG_LOG"
       exit 1
   fi
   
   # Loop through input files
   for audio_file in "$@"; do
       echo "Processing: $audio_file" >> "$DEBUG_LOG"
       
       # Define output file
       base_file="$(basename "$audio_file")"
       output_dir="$(dirname "$audio_file")"
       transcript_file="${output_dir}/${base_file}.txt"
       
       echo "Transcript will be saved to: $transcript_file" >> "$DEBUG_LOG"
       
       # Run Whisper
       "$WHISPER_PATH" \
           --model mlx-community/whisper-large-v3-mlx \
           --language English \
           --output-format txt \
           --word-timestamps False \
           --condition-on-previous-text False \
           --output-name "${base_file}" \
           --output-dir "${output_dir}" \
           "$audio_file"
   done
   ```

3. **Make the Script Executable**
   ```sh
   chmod +x transcribe.sh
   ```

---

### **Step 3: Creating an Automator Quick Action**
1. **Open Automator**
   - Press `Cmd + Space`, type `Automator`, and open it.

2. **Create a New Quick Action**
   - Select `New Document` > `Quick Action`.
   - Set `Workflow receives current` to `audio files`.

3. **Add the Run Shell Script Action**
   - In the search bar, type `Run Shell Script` and drag it into the workflow.
   - Set Shell to `/bin/zsh` and choose `Pass input as arguments`.

4. **Insert Script Call**
   - Replace the default text with:
   ```sh
   /path/to/transcribe.sh "$@"
   ```
   *(Replace `/path/to/` with the actual path to your script)*

5. **Save the Quick Action**
   - Press `Cmd + S`, name it `Transcribe with Whisper`, and save.

---

### **Step 4: Using Your Quick Action**
1. **Find an Audio File in Finder**
2. **Right-click > Quick Actions > Transcribe with Whisper**
3. **Wait for Transcription**
   - The transcript will appear in the same folder as the audio file with a `.txt` extension.
   - Debug logs are saved at `~/whisper_debug.log`.

---

## **Troubleshooting**
- **mlx_whisper command not found?**
  - Ensure it's installed: `which mlx_whisper`
  - If missing, reinstall: `pip install mlx_whisper --ignore-requires-python`

- **Quick Action not appearing in Finder?**
  - Restart Finder (`Cmd + Option + Escape > Finder > Relaunch`).
  - Ensure Automator settings match the guide.

---

## **You're Done!**
Now you have a fully automated transcription tool on your Mac! If you found this helpful, feel free to star this repo and share your experience.

## Acknowledgments

This script and integration process were inspired and informed by the following resources:
- **OpenAI's Whisper**: The foundational speech recognition model. [OpenAI Whisper](https://en.wikipedia.org/wiki/Whisper_%28speech_recognition_system%29)
- **mlx_whisper on Hugging Face**: The macOS-optimized fork of Whisper. [mlx_whisper on Hugging Face](https://huggingface.co/ml6team/whisper-large-v2)
- **Sean Keever's Guide**: An insightful article on setting up Whisper transcription on macOS. [Whisper macOS Transcription](https://seankeever.substack.com/p/whisper-macos-transcription?triedRedirect=true)
- **YouTube Tutorials**:
  - [OpenAI Whisper - Installation and Setup](https://www.youtube.com/watch?v=zeu4yGBdGkw)
  - [Automating Transcriptions with Whisper and Automator](https://www.youtube.com/watch?v=OIl4H2WgJxM&t=82s)
  - [Integrating Whisper with macOS Services](https://www.youtube.com/watch?v=BaZy7cFXklc&t=7s)

These resources provided valuable guidance in the development and optimization of this script.
