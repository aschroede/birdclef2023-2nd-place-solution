#!/usr/bin/env bash
#SBATCH --partition=csedu
#SBATCH --account=cseduimc030
#SBATCH --qos=csedu-normal
##SBATCH --array=0-3%4 # Not sure what this is for...
#SBATCH --mem=10G
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --time=1:00:00
#SBATCH --output=./logs/experiment3_%j_%a.out
#SBATCH --error=./logs/experiment3_%j_%a.err
#SBATCH --mail-type=BEGIN,END,FAIL




python3 ../train.py --stage pretrain_ce --model_name sed_seresnext26t