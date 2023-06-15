#!/bin/bash

# Full path to the directory containing the audio files
audio_dir="./sounds"

# Array of audio file names
audio_files=("Audio 1.wav" "Audio 2.wav" "Audio 3.wav" "Audio 4.wav" "Audio 5.wav")

# Probability for playing Audio 1.wav (in percentage)
audio_1_probability=90

# Function to generate a random number within a range
generate_random_number() {
    local min=$1
    local max=$2
    echo $(( RANDOM % (max - min + 1) + min ))
}

# Function to generate a random volume adjustment factor
generate_random_volume() {
    local min=$1
    local max=$2
    local random_value=$(shuf -i "$min-$max" -n 1)
    echo "scale=2; $random_value / 100" | bc
}

# Retrieve the playback device from the environment variable, or use a default value
playback_device="${PLAYBACK_DEVICE:-default}"


echo "Starting to play packet sounds on device $playback_device"

# Audio parameters
sample_rate=8000
format=wav
channels=1

# Loop to randomly play the audio files
while true; do
    # Generate a random number between 1 and 100
    random_probability=$(generate_random_number 1 100)

    # Select an audio file based on the probability
    if [ "$random_probability" -le "$audio_1_probability" ]; then
        audio_file="Audio 1.wav"
    else
        # Select a random audio file other than Audio 1.wav
        random_index=$(( RANDOM % ((${#audio_files[@]} - 1)) + 1 ))
        audio_file=${audio_files[random_index]}
    fi

    # Full path to the selected audio file
    full_path="$audio_dir/$audio_file"

    # Generate a random volume adjustment between -6 and 0 dB
    volume_adjustment=$(generate_random_number -9 0)

    # Convert and adjust the volume of the audio file using sox and play it directly
    sox -q "$full_path" -r $sample_rate -c $channels -t $format - gain -l $volume_adjustment | aplay -D "$playback_device" -r $sample_rate -c $channels -t $format -q

    # Generate a random pause duration between 3 and 10 seconds
    pause_duration=$(generate_random_number 2 5)

    # Pause for the generated duration
    sleep $pause_duration
done

