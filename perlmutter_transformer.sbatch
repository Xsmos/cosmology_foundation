#!/bin/bash
#SBATCH -A m4717 
#SBATCH -C gpu #&hbm80g
#SBATCH -q shared #regular 
#SBATCH --gpus-per-node=1
#SBATCH -N1
#SBATCH -t 16:00:00
#SBATCH --ntasks-per-node=1
#SBATCH -oReport-%j 
#SBATCH --mail-type=BEGIN,END,FAIL
#SBATCH --gpu-bind=none

date
#module load anaconda3/2022.05 # Load module dependencies
module load pytorch #/2.0.1
#conda activate diffusers 
which python
conda env list
module list

MASTER_ADDR=$(scontrol show hostnames $SLURM_JOB_NODELIST | head -n 1)
MASTER_PORT=$((10000 + RANDOM % 10000)) #12355
#export OMP_NUM_THREADS=1
export MASTER_ADDR=$MASTER_ADDR
export MASTER_PORT=$MASTER_PORT
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
cat $0
git diff training.py

srun python training.py \
    #--num_image 3200 \
    #--num_new_img_per_gpu 64 \
    #--max_num_img_per_gpu 32 \
    #--model_channels 96 \
    #--channel_mult 1 1 2 2 \
    #--num_res_blocks 3 \
    #--num_redshift 32 \
    #--stride 2 2 2 \
    #--batch_size 16 \
    #--n_epoch 120 \
    #--gradient_accumulation_steps 1 \
    #--lrate 1e-5 \
    #--resume ./outputs/model-N3200-device_count4-node2-epoch119-34127204 \
    #--train "$SCRATCH/LEN128-DIM64-CUB16-Tvir[4, 6]-zeta[10, 250]-0809-123640.h5" \
    #--autocast 1 \
    #--use_checkpoint 1 \
    #--dropout 0 \

date

# SHORT NOTES:
#
