# Social Network
## Set core
Each container is restricted to run on only one CPU socket, either cores 0–31 or cores 32–63

Total 27 containers, let containers, each set to different cores

set wrk to core 63

stop all MAAS-related services using `sudo snap stop maas maas-test-db`

No core is empty

## VMs - Corresponding cores

* socialnetwork-user-timeline-redis-1 \ —----------- core 0
* socialnetwork-social-graph-service-1 \ ----------- core 1
* socialnetwork-user-memcached-1 \ ----------—------ core 2
* socialnetwork-social-graph-redis-1 \ —------------ core 3
* socialnetwork-media-service-1 \ ------------------ core 4
* socialnetwork-post-storage-memcached-1 \ --—------ core 5
* socialnetwork-url-shorten-memcached-1 \ -—-------- core 6
* socialnetwork-media-memcached-1 \ -—-------------- core 7
* socialnetwork-social-graph-mongodb-1 \ -—--------- core 8
* socialnetwork-user-mongodb-1 \ -—----------------- core 9
* socialnetwork-media-mongodb-1 \ -—---------------- core 10
* socialnetwork-media-frontend-1 \ --—-------------- core 11
* socialnetwork-user-service-1 \ ------------------- core 12
* socialnetwork-unique-id-service-1 \ -------------- core 13
* socialnetwork-url-shorten-service-1 \ ------------ core 14/(給2个con cpuset-R6400)<给了con random就到4000了, 不能给多>

* socialnetwork-user-timeline-service-1 \ ------—--- core 15,
* socialnetwork-user-mention-service-1 \ ------—---- core 16,
* socialnetwork-home-timeline-service-1 \ ------—--- core 24,25

* socialnetwork-jaeger-agent-1 \ -—-—--------------- core 17,
* socialnetwork-url-shorten-mongodb-1 \ ------------ core 18,
* socialnetwork-post-storage-mongodb-1 \ ----------- core 19,


* socialnetwork-home-timeline-redis-1 \ -——-—------- core 20,(给多了没用，总是只有某一个core非常高)
* socialnetwork-text-service-1 \ ------------—------ core 21


* socialnetwork-post-storage-service-1 \ ----------- core 26,27,28,29,30,31,(read home timeline)(Read user timelines还需要更多要3个)(一个时候Compose Posts -R最大)
* socialnetwork-nginx-thrift-1 \ ------------—------ core 32-62(31)(read home timeline)



* socialnetwork-user-timeline-mongodb-1 \ ------—--- core 22,
* socialnetwork-compose-post-service-1 \ ---—------- core 23,





## Generation Scrpts：
* test-randomCore
* test-oddEvenCore
