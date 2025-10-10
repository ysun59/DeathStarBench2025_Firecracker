# Hotel Reservation

The application implements a hotel reservation service, build with Go and gRPC, and starting from the open-source project https://github.com/harlow/go-micro-services. The initial project is extended in several ways, including adding back-end in-memory and persistent databases, adding a recommender system for obtaining hotel recommendations, and adding the functionality to place a hotel reservation. 

## Running the hotel reservation application using Firecracker

### Before you start

#### You only need to do this once, unless you reinstall the system

```bash
cd /home/yu/DeathStarBench2025_Firecracker/hotel
make download-kernel
```

### Start Firecracker

#### Run these commands only **once**, unless you run `make clean-base`

```bash
cd /home/yu/DeathStarBench2025_Firecracker/hotel
make base-all
```
If you want to revert this operation, run:
```bash
make clean-base
```

#### Run these commands again after **rebooting** the computer

```bash
cd /home/yu/DeathStarBench2025_Firecracker/hotel
sudo make network
```
It will show something like (Using host interface: eno1)

#### Start hotel benchmark and set cpuset

```bash
make build
sudo make run
sudo make cpuset
```

##### Running HTTP workload generator

```bash
cd /home/yu/DeathStarBench2025/hotelReservation
taskset -c 63 ../wrk2/wrk -D exp -t 20 -c 60 -d 60 --timeout 5 -L -s ./wrk2/scripts/hotel-reservation/mixed-workload_type_1.lua http://10.10.10.5:5000 -R 1000
```

#### Stop hotel benchmark

```bash
cd /home/yu/DeathStarBench2025_Firecracker/hotel
sudo make stop
make clean
```

## Ready-to-use script to run Firecracker

### Run Firecracker with optimized **cpuset** configurations for maximum throughput

```bash
cd /home/yu/DeathStarBench2025_Firecracker/hotel/test-oddEvenCore
./run-yu.sh 800
```

### Run Firecracker benchmarks with **random** CPU allocation

```bash
cd /home/yu/DeathStarBench2025_Firecracker/hotel/test-randomCore
./run-yu.sh 800
```
