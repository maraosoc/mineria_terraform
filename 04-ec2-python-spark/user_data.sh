        set -euxo pipefail
        dnf -y update
        # 1) Sistema base + Java 17 (Corretto)
        dnf -y install python3 python3-pip java-17-amazon-corretto
        # 2) pip y pyspark de forma "global" (para TODOS los usuarios)
        python3 -m pip install --upgrade pip
        export PIP_ROOT_USER_ACTION=ignore
        python3 -m pip install pyspark

        # Exporta JAVA_HOME para pyspark
        echo 'export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto' > /etc/profile.d/java_home.sh

        # Comprobación
        python3 - << 'PY'
from pyspark.sql import SparkSession
spark = SparkSession.builder.getOrCreate()
print("Spark version:", spark.version)
spark.stop()
PY