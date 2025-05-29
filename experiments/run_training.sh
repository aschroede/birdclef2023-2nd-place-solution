#!/usr/bin/env bash
#SBATCH --partition=csedu-prio
##SBATCH --account=csmpistud
#SBATCH --qos=csedu-small
#SBATCH --mem=15G
#SBATCH --cpus-per-task=6
#SBATCH --gres=gpu:1
#SBATCH --time=1:00:00
#SBATCH --output=./logs/experiment3_%j_%a.out
#SBATCH --error=./logs/experiment3_%j_%a.err
#SBATCH --mail-type=BEGIN,END,FAIL

python3 ../train.py --stage pretrain_ce --model_name sed_seresnext26t