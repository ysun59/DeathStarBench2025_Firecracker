# Hotel Reservation Data

Each container is restricted to run on only one CPU socket, either cores 0–31 or cores 32–63

Total 24 containers, let 18 firecrackers, each set to different cores, from core 0,2,4,6,8……34

set frontend to 4 cores (basically core 13,15,17-more-19)

set wrk to core 63

stop all MAAS-related services using `sudo snap stop maas maas-test-db`

## VMs - Corresponding cores
* hotelreservation-consul-1 \ --—------------------ core 0
* hotelreservation-geo-1 \ —----------------------- core 2
* hotelreservation-recommendation-1 \ -——---------- core 4
* hotelreservation-user-1 \ —--------—------------- core 6
* hotelreservation-jaeger-1 \ --------------------- core 8
* hotelreservation-memcached-rate-1 \ ------------- core 10
* hotelreservation-memcached-profile-1 \ ---------- core 12
* hotelreservation-mongodb-geo-1 \ ---------------- core 14
* hotelreservation-mongodb-profile-1 \ ------------ core 16
* hotelreservation-mongodb-rate-1 \ -----------—--- core 18
* hotelreservation-mongodb-recommendation-1 ------- core 20
* hotelreservation-mongodb-user-1  ---------------- core 22
* hotelreservation-mongodb-reservation-1 \ -------- core 24

* hotel_reserv_review \ --------------------------- core 26
* hotel_reserv_attractions \ ---------------------- core 28
* hotel_reserv_review_mmc \ ----------------------- core 30
* hotelreservation-mongodb-review-1 \ ------------- core 32
* hotelreservation-mongodb-attractions-1 \ -------- core 34


* hotelreservation-profile-1 \ ---—---------------- core 1, 3
* hotelreservation-search-1 \ --—------------------ core 5, 7
* hotelreservation-memcached-reserve-1 \ —---—----- core 9, 11

* hotelreservation-frontend-1 \ ------------------- core 13, 15, 17, 19
* hotelreservation-rate-1 \ —---------------------- core 21, 23, 25, 27, 29, 31(6)
* hotelreservation-reservation-1 \ —--------------- core 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52 (18)





## Generation Scrpts：
* test-randomCore
* test-oddEvenCore
