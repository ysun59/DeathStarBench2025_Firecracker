# Media Microservices
# Set core
Each container is restricted to run on only one CPU socket, either cores 0–31 or cores 32–63

Total 33 containers, 32 firecrackers

set wrk to core 0,1

stop all MAAS-related services using `sudo snap stop maas maas-test-db`

If it is container, the container mediamicroservices-dns-media-1 set to core 25

Core 63 is empty

## VMs - Corresponding cores (33 containers)
* mediamicroservices-review-storage-mongodb \ -—-—----------------—-- core 2
* mediamicroservices-unique-id-service \ -—-—------------------------ core 3
* mediamicroservices-text-service \ -—-—----------------—------------ core 4
* mediamicroservices-user-service \ -—-—----------------—------------ core 5
* mediamicroservices-review-storage-service \ -—-—------------------- core 6
* mediamicroservices-rating-redis \ -—-—----------------—------------ core 7
* mediamicroservices-movie-review-redis \ -—-—----------------—------ core 8
* mediamicroservices-user-review-redis \ -—-—------------------------ core 9
* mediamicroservices-movie-id-memcached \ -—-—----------------—------ core 10 (后加的)
* mediamicroservices-user-memcached \ -—-—-----------------—--------- core 11 (后加的)
* mediamicroservices-review-storage-memcached  -—-—------------------ core 12
* mediamicroservices-cast-info-memcached  -—-—----------------—------ core 13
* mediamicroservices-plot-memcached  -—-—---------—------------------ core 14
* mediamicroservices-movie-info-memcached  -—-—----------------—----- core 15
* mediamicroservices-movie-id-mongodb  -—-—-------------------------- core 16
* mediamicroservices-user-mongodb  -—-—-----------—------------------ core 17
* mediamicroservices-cast-info-mongodb  -—-—------------------------- core 18
* mediamicroservices-plot-mongodb  -—-—----------------—------------- core 19
* mediamicroservices-movie-info-mongodb  -—-—------------------------ core 20
* mediamicroservices-cast-info-service  -—-—------------------------- core 21
* mediamicroservices-plot-service  -—-—----------------—------------- core 22
* mediamicroservices-movie-info-service  -—-—------------------------ core 23
* mediamicroservices-jaeger \ -—-—----------------—------------------ core 24
* mediamicroservices-dns-media-1 -—-—-------------------------------- core 25


* mediamicroservices-rating-service \ -—-—----------------—---------- core 26,27,28
* mediamicroservices-user-review-service \ -—-—---------------------- core 29,30,31
* mediamicroservices-movie-review-service \ -—-—--------------------- core 32,33,34
* mediamicroservices-compose-review-memcached \ -—-—---------—------- core 35,36,37

* mediamicroservices-user-review-mongodb \ -—-—----------------—----- core 38,39,40,41
* mediamicroservices-movie-review-mongodb \ -—-—----------------—---- core 42,43,44,45
* mediamicroservices-nginx-web-server \ -—-—------—------------------ core 46,47,48,49(没法给多，会崩溃,/core给24， 26能跑28秒左右)
* mediamicroservices-movie-id-service \ -—-—------------------------- core 50,51,52,53

* mediamicroservices-compose-review-service \ -—-—------------------- core 54,55,56,57,58,59,60,61,62 (9)




## Generation Scrpts：
* test-randomCore
* test-oddEvenCore