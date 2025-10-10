# Media Microservices

## Running the media microservices application using Container

### Apply patch

```bash
cd /home/yu/DeathStarBench2025
git apply ~/media/deathStarBench.diff
```

### After running **Kubernetes**, you must run the following two commands again to rebuild and redeploy:

```bash
cd /home/yu/DeathStarBench2025/mediaMicroservices
docker build -t yg397/media-microservices:latest .
```

After running `docker build -t ...`, you **must** need to run `make base-all` to rebuild the base environment.

```bash
cd /home/yu/DeathStarBench2025_Firecracker/media
make clean-base
make base-all
```

## Running the media microservices application using Firecracker

### Before you start

#### You only need to do this once, unless you reinstall the system

```bash
cd /home/yu/DeathStarBench2025_Firecracker/media
make download-kernel
```

### Start Firecracker

#### Run these commands only **once**, unless you run `make clean-base`

```bash
cd /home/yu/DeathStarBench2025_Firecracker/media
make base-all
```
If you want to revert this operation, run:
```bash
make clean-base
```

#### Run these commands again after **rebooting** the computer

```bash
cd /home/yu/DeathStarBench2025_Firecracker/media
sudo make network
```
It will show something like (Using host interface: eno1)

#### Start media benchmark and set cpuset

```bash
make build
sudo make run
sudo make cpuset
```

#### Register users and movie information

```bash
cd /home/yu/DeathStarBench2025/mediaMicroservices
python3 scripts/write_movie_info.py -c datasets/tmdb/casts.json -m datasets/tmdb/movies.json --server_address http://10.10.12.65:8080 && scripts/register_users.sh 10.10.12.65 && scripts/register_movies.sh 10.10.12.65
```

##### Running HTTP workload generator and Compose reviews

```bash
taskset -c 0,1 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/media-microservices/compose-review.lua http://10.10.12.65:8080/wrk2-api/review/compose -R 800
```

#### Stop media benchmark

```bash
cd /home/yu/DeathStarBench2025_Firecracker/media
sudo make stop
make clean
```

## Ready-to-use script to run Firecracker

### Run Firecracker with optimized **cpuset** configurations for maximum throughput

```bash
cd /home/yu/DeathStarBench2025_Firecracker/media/test-oddEvenCore
./run-yu.sh 800
```

### Run Firecracker benchmarks with **random** CPU allocation

```bash
cd /home/yu/DeathStarBench2025_Firecracker/media/test-randomCore
./run-yu.sh 800
```
