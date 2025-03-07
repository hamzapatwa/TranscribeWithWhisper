#!/bin/zsh

# Ensure Automator can find Homebrew-installed packages
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:$PATH"

# Path to mlx_whisper
WHISPER_PATH="/Library/Frameworks/Python.framework/Versions/3.12/bin/mlx_whisper"

# Global debug log (optional)
DEBUG_LOG="$HOME/whisper_debug.log"
echo "Running Whisper Script" > "$DEBUG_LOG"

# Timing log file (You can remove this if you don't care to see how long it takes.)
TIMING_LOG="$HOME/transcription_timing.log"

# Check if mlx_whisper exists
if [[ ! -x "$WHISPER_PATH" ]]; then
    echo "Error: mlx_whisper not found at $WHISPER_PATH" | tee -a "$DEBUG_LOG"
    exit 1
fi

#For-loop that handles batch-selections
for audio_file in "$@"; do
    echo "Processing: $audio_file" >> "$DEBUG_LOG"

    # Determine the transcript path (same directory as the audio)
    base_file="$(basename "$audio_file")"
    output_dir="$(dirname "$audio_file")"
    transcript_file="${output_dir}/${base_file}.txt"
    
    echo "Transcript will be saved to: $transcript_file" >> "$DEBUG_LOG"
    
    # Run whisper. You can change this based on what fork of Whisper you're using.
    TIMEFORMAT='Total time: %E'
    { time "$WHISPER_PATH" \
        --model mlx-community/whisper-large-v3-mlx \
        --language English \
        --output-format txt \
        --word-timestamps False \
        --condition-on-previous-text False \
        --output-name "${base_file}" \
        --output-dir "${output_dir}" \
        "$audio_file"; } 2> "$TIMING_LOG"

    #Debugging
    if [[ $? -ne 0 ]]; then
        echo "Error processing file: $audio_file" | tee -a "$DEBUG_LOG"
        exit 1
    fi

done