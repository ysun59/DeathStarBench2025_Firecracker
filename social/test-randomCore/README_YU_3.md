# Social Network
## Set core
Each container is restricted to run on only one CPU socket, either cores 0–31 or cores 32–63

Total 27 containers, let containers, each set to different cores

set wrk to core 63,61

stop all MAAS-related services using `sudo snap stop maas maas-test-db`

No core is empty

## VMs - Corresponding cores

* socialnetwork-user-timeline-redis-1 \ —----------- core 0
* socialnetwork-social-graph-service-1 \ ----------- core 1
* socialnetwork-user-memcached-1 \ ----------—------ core 2
* socialnetwork-social-graph-redis-1 \ —------------ core 3
* socialnetwork-media-service-1 \ ------------------ core 4
* socialnetwork-post-storage-memcached-1 \ --—------ core 56,57
* socialnetwork-url-shorten-memcached-1 \ -—-------- core 5
* socialnetwork-media-memcached-1 \ -—-------------- core 6
* socialnetwork-social-graph-mongodb-1 \ -—--------- core 7
* socialnetwork-user-mongodb-1 \ -—----------------- core 8
* socialnetwork-media-mongodb-1 \ -—---------------- core 9
* socialnetwork-media-frontend-1 \ --—-------------- core 10
* socialnetwork-user-service-1 \ ------------------- core 11
* socialnetwork-unique-id-service-1 \ -------------- core 12
* socialnetwork-url-shorten-service-1 \ ------------ core 13/(給2个con cpuset-R6400)<给了con random就到4000了, 不能给多>

* socialnetwork-user-timeline-service-1 \ ------—--- core 58,59,60(11不用这么多跑60秒后)
* socialnetwork-user-mention-service-1 \ ------—---- core 14,
* socialnetwork-home-timeline-service-1 \ ------—--- core 15

* socialnetwork-jaeger-agent-1 \ -—-—--------------- core 16,
* socialnetwork-url-shorten-mongodb-1 \ ------------ core 17,
* socialnetwork-post-storage-mongodb-1 \ ----------- core 18,


* socialnetwork-home-timeline-redis-1 \ -——-—------- core 19
* socialnetwork-text-service-1 \ ------------—------ core 20


* socialnetwork-post-storage-service-1 \ ----------- core 22,23,24,25,26,27,28,29,30,31 (10)
* socialnetwork-nginx-thrift-1 \ ------------—------ core 32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,(24)(read home timeline)



* socialnetwork-user-timeline-mongodb-1 \ ------—--- core 21
* socialnetwork-compose-post-service-1 \ ---—------- core 62







## Generation Scrpts：
* test-randomCore
* test-oddEvenCore
