#!/bin/bash
set -euxo pipefail
dnf -y update
dnf -y install python3 python3-pip
python3 -m pip install --upgrade pip
python3 -m pip install duckdb
python3 -c "import platform, duckdb; print('Python', platform.python_version(), 'DuckDB', duckdb.__version__)"
