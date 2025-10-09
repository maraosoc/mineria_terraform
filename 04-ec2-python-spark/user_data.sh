        set -euxo pipefail
        dnf -y update
        # 1) Sistema base + Java 17 (Corretto)
        dnf -y install python3.11 python3.11-pip java-17-amazon-corretto
        # 2) pip y pyspark de forma "global" (para TODOS los usuarios)
        python3.11 -m pip install --index-url https://pypi.org/simple "pyspark>=3.5.1,<3.6"
        export PIP_ROOT_USER_ACTION=ignore
        python3.11 -m pip install pyspark

        # Exporta JAVA_HOME para pyspark
        echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' > /etc/profile.d/java_home.sh

        # Comprobación
        python3.11 - << 'PY'
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()
print("Spark version:", spark.version)
spark.stop()
PY