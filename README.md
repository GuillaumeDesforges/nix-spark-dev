# nix-spark-dev

Start playing with PySpark _fast_.

## Requirements

- Nix: https://nixos.org/download.html

## How to use

1. Open a shell to spawn master process

   ```bash
   $ nix develop
   $ start-master.sh
   ```

2. Open a new shell to start worker process

   ```bash
   $ nix develop
   $ start-worker.sh 0.0.0.0:7077
   ```

3. Open a new shell to start Jupyter Lab

   ```bash
   $ nix develop
   $ jupyter lab
   ```

You can check out `notebooks/Demo.ipynb` to see how you can start using PySpark.
