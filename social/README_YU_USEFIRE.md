# Social Network Microservices

A social network with unidirectional follow relationships, implemented with loosely-coupled microservices, communicating with each other via Thrift RPCs.

## Running the social network application using Container

### Apply patch

```bash
cd ~/DeathStarBench2025
git apply /home/yu/social-0817/deathStarBench.diff
```

### After running **Kubernetes**, you must run the following two commands again to rebuild and redeploy:

```bash
cd /home/yu/DeathStarBench2025/socialNetwork
docker build -t deathstarbench/social-network-microservices:latest .
```

After running `docker build -t ...`, you **must** need to run `make base-all` to rebuild the base environment.

```bash
cd /home/yu/DeathStarBench2025_Firecracker/social
make clean-base
make base-all
```

## Running the social network application using Firecracker

### Before you start

#### You only need to do this once, unless you reinstall the system

```bash
cd /home/yu/DeathStarBench2025_Firecracker/social
make download-kernel
```

### Start Firecracker

#### Run these commands only **once**, unless you run `make clean-base`

```bash
cd /home/yu/DeathStarBench2025_Firecracker/social
make base-all
```
If you want to revert this operation, run:
```bash
make clean-base
```

#### Run these commands again after **rebooting** the computer

```bash
cd /home/yu/DeathStarBench2025_Firecracker/social
sudo make network
```
It will show something like (Using host interface: eno1)

#### Start social benchmark and set cpuset

```bash
make build
sudo make run
sudo make cpuset
```

#### Register users and construct social graphs

```bash
cd /home/yu/DeathStarBench2025/socialNetwork
python3 scripts/init_social_graph.py --ip=10.10.11.51 --graph=socfb-Reed98
```
##### Running HTTP workload generator

##### Compose posts

```bash
taskset -c 61,63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/compose-post.lua http://10.10.11.51:8080/wrk2-api/post/compose -R 1000
```

##### Read home timelines

```bash
taskset -c 61,63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/read-home-timeline.lua http://10.10.11.51:8080/wrk2-api/home-timeline/read -R 1000
```

##### Read user timelines

```bash
taskset -c 61,63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/social-network/read-user-timeline.lua http://10.10.11.51:8080/wrk2-api/user-timeline/read -R 1000
```

#### Stop social benchmark

```bash
cd /home/yu/DeathStarBench2025_Firecracker/social
sudo make stop
make clean
```

## Ready-to-use script to run Firecracker

### Run Firecracker with optimized **cpuset** configurations for maximum throughput

```bash
cd /home/yu/DeathStarBench2025_Firecracker/social/test-oddEvenCore

# Case 1: cpuset optimized for Compose Posts
./run-yu.sh 1000 1

# Case 2: cpuset optimized for Read Home Timelines
./run-yu.sh 1000 2

# Case 3: cpuset optimized for Read User Timelines
./run-yu-3.sh 1000
```

### Run Firecracker benchmarks with **random** CPU allocation

```bash
cd /home/yu/DeathStarBench2025_Firecracker/social/test-randomCore

# Case 1: random (cpus) for Compose Posts
./run-yu.sh 1000 1

# Case 2: random (cpus) for Read Home Timelines
./run-yu.sh 1000 2

# Case 3: random (cpus) for Read User Timelines
./run-yu-3.sh 1000
```
