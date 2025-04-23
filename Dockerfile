# Use Debian Buster (que ainda tem openjdk-11 nos repositórios)
FROM python:3.8-buster

# Instala Java 11 e curl
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk-headless \
    curl \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Ajusta JAVA_HOME
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH

# Baixa e instala Spark
ENV SPARK_VERSION=3.1.2
ENV HADOOP_VERSION=3.2
RUN curl -sL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    | tar -xz -C /opt \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark

ENV SPARK_HOME=/opt/spark
ENV PATH=$SPARK_HOME/bin:$PATH

# Instala PySpark e JupyterLab
RUN pip install --no-cache pyspark==3.1.2 jupyterlab

# Diretório de trabalho
WORKDIR /workspace

# Exponha as portas
EXPOSE 4040 8888

# Inicia o JupyterLab com token
CMD ["bash","-lc","jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root"]
