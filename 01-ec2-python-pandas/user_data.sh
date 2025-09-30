#!/bin/bash
set -euxo pipefail
dnf -y update
dnf -y install python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install pandas

# Comprobación
python3 -c "import platform, pandas as pd; print('Python', platform.python_version(), 'Pandas', pd.__version__)"
