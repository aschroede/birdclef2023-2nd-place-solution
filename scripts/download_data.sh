#! /usr/bin/env bash
set -e

# set variable to path where this script is
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR" || exit 1

# set environment variables
source ../.env 2> /dev/null || source .env

# default directory to save files in
DIR="$SCRIPT_DIR"/../data/cifar10
mkdir -p "$DIR"



PROJECT_ROOT="$( dirname "$SCRIPT_DIR" )"
INPUT_DIR="$PROJECT_ROOT/inputs"
AUDIO_DIR="$INPUT_DIR/train_audios"
NOISE_DIR="$INPUT_DIR/background_noise"


# --- Download train.csv metadata ---
echo "📥 Downloading metadata: train.csv"
cd "$INPUT_DIR"
kaggle datasets download honglihang/birdclef2023-extended-train
unzip -o birdclef2023-extended-train.zip
rm birdclef2023-extended-train.zip

# --- Download BirdCLEF2023 audio files ---
echo "🎧 Downloading BirdCLEF2023 train audios"
cd "$AUDIO_DIR"
kaggle competitions download -c birdclef-2023
unzip -o birdclef-2023.zip
rm birdclef-2023.zip

# --- Download background noise ---
echo "🔊 Downloading background noise files"
cd "$NOISE_DIR"
kaggle datasets download honglihang/background-noise
unzip -o background-noise.zip
rm background-noise.zip

echo "✅ All data downloaded and extracted successfully!"