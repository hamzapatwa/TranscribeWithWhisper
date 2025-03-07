# Whisper Automator Script for macOS

This script enables macOS users to transcribe audio files into text using the `mlx_whisper` tool, leveraging OpenAI's Whisper model. By integrating this script with Automator, users can right-click on audio files and select a "Transcribe with Whisper" option, generating a text transcript in the same directory as the original audio file.

## Prerequisites

Before using the script, ensure the following components are installed on your macOS system:

1. **Homebrew**: A package manager for macOS. Install it by running:
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Python 3.12**: Install via Homebrew:
   ```bash
   brew install python@3.12
   ```

3. **mlx_whisper**: A fork of OpenAI's Whisper optimized for macOS. Install it using `pip`:
   ```bash
   pip install mlx_whisper
   ```

4. **FFmpeg**: A multimedia framework required for processing audio files. Install it with:
   ```bash
   brew install ffmpeg
   ```

## Script Details

The provided script performs the following functions:

- **Sets the PATH**: Ensures Automator can locate Homebrew-installed packages by setting the appropriate PATH.

- **Defines the Path to `mlx_whisper`**: Specifies the location of the `mlx_whisper` executable.

- **Initializes Logs**: Creates debug and timing logs to monitor the script's execution and performance.

- **Checks for `mlx_whisper`**: Verifies that the `mlx_whisper` executable exists at the specified path.

- **Processes Each Audio File**: Iterates over selected audio files, determines the output directory and filename, and runs the transcription using `mlx_whisper`.

- **Handles Errors**: Logs any errors encountered during the transcription process.

## Integration with Automator

To integrate this script into macOS Automator for seamless right-click functionality:

1. **Open Automator**: Launch the Automator application from the Applications folder.

2. **Create a New Document**: Choose "Quick Action" as the type of document.

3. **Set Workflow Options**:
   - Workflow receives current: `audio files`
   - In: `Finder`

4. **Add "Run Shell Script" Action**:
   - Drag the "Run Shell Script" action into the workflow area.
   - Set the shell to `/bin/zsh`.
   - Set "Pass input" to `as arguments`.

5. **Insert the Script**:
   - Copy and paste the provided script into the "Run Shell Script" action.

6. **Save the Workflow**:
   - Name it "Transcribe with Whisper" or a similar descriptive title.

Now, when you right-click on an audio file in Finder, you'll have the option to "Transcribe with Whisper," which will execute the script and generate a transcript in the same directory as the audio file.

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