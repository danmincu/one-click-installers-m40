#!/bin/bash

# I ran this one step at the time - didn't try the one click approach.

# install conda
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sha256sum Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
source ~/.bashrc

# create conda env for Python 3.9 and activate it
conda create -n vicunam40 python=3.9
conda activate vicunam40

# create a home for the software
mkdir ~/gptm40
cd ~/gptm40

# clone the text-generation-webui the M40 specific
git clone https://github.com/danmincu/text-generation-webui-m40.git
cd text-generation-webui-m40
pip install -r requirements.txt

# inside the previous repo create the GPTQ-for-LLaMa M40 specific version
# the Tesla M40 WILL NOT works with another branch.
mkdir repositories
cd repositories
git clone https://github.com/danmincu/GPTQ-for-LLaMa-M40.git -b cuda-M40
cd GPTQ-for-LLaMa-m40
# this will compile - currently there are some rather serious warnings but it works
python setup_cuda.py install

# download the anon8231489123/vicuna-13b-GPTQ-4bit-128g model that works pretty well although is filtered 
cd ../..
python download-model.py anon8231489123/vicuna-13b-GPTQ-4bit-128g

# runs the server in api mode probably you want to add the --chat mode 
python server.py --model anon8231489123_vicuna-13b-GPTQ-4bit-128g --model_type LLaMA --wbits 4 --groupsize 128 --listen --extensions api
