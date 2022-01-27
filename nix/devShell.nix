{ mkShell
, jdk8
, hadoop
, spark
, jupyterWith
}:

let
  iPython = jupyterWith.kernels.iPythonWith {
    name = "python-env";
    # ignoreCollisions = true;
    packages = p: with p; [ pyspark_3-1-2 ];
  };
  jupyterEnvironment = jupyterWith.jupyterlabWith {
    kernels = [ iPython ];
  };
in
mkShell {
  buildInputs = [
    spark
    jupyterEnvironment
  ];

  shellHook = ''
    export JAVA_HOME="${jdk8}"
    echo "JAVA_HOME=$JAVA_HOME"

    export HADOOP_CONF_DIR=$(pwd)/.hadoop/conf
    mkdir -p $HADOOP_CONF_DIR
    echo HADOOP_CONF_DIR=$HADOOP_CONF_DIR

    export SPARK_DIST_CLASSPATH=$(${hadoop}/bin/hadoop classpath)
    echo SPARK_DIST_CLASSPATH=$SPARK_DIST_CLASSPATH

    export SPARK_HOME=${spark}/lib/spark-3.1.2
    echo SPARK_HOME=$SPARK_HOME

    export SPARK_CONF_DIR=$(pwd)/.spark/conf
    mkdir -p $SPARK_CONF_DIR
    echo SPARK_CONF_DIR=$SPARK_CONF_DIR

    export SPARK_LOG_DIR=$(pwd)/.spark/log
    mkdir -p $SPARK_LOG_DIR
    echo SPARK_LOG_DIR=$SPARK_LOG_DIR
    
    export SPARK_PID_DIR=$(pwd)/.spark/pid
    mkdir -p $SPARK_PID_DIR
    echo SPARK_PID_DIR=$SPARK_PID_DIR

    # https://spark.apache.org/docs/latest/spark-standalone.html#cluster-launch-scripts
    export SPARK_LOCAL_DIRS=$(pwd)/.spark/local
    export SPARK_WORKER_DIR=$(pwd)/.spark/worker

    export SPARK_NO_DAEMONIZE=1

    # create spark-env.sh to match env
    export -p > .spark/conf/spark-env.sh
    export PATH="$SPARK_HOME/sbin:$PATH"
  '';
}
