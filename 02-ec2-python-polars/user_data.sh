#!/bin/bash
set -euxo pipefail
dnf -y update
dnf -y install python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install polars

# Comprobación
python3 -c "import platform, polars as pl; print('Python', platform.python_version(), 'Polars', pl.__version__)"
