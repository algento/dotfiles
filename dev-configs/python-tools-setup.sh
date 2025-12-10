#!/bin/bash

# miniforge3
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh

# uv
curl -LsSf https://astral.sh/uv/install.sh | sh

# Conda init —reverse $SHELL
