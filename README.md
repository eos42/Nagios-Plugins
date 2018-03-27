# nagios

Collection of Nagios plugins for EOS.


####  📌 check_bp.py


A python script to monitor your Block Producers using nagios or other.
Each function performs a particular action and EXITS with 0 if there are no issues and EXITS with 2 if there are issues. 



#####  (1) Check the participation rate of your block producer 

* Checks your host has a participation rate of more than 0.5.
* EXITS with 0 if participation rate > 5.
* EXITS with 2 if participation rate < 5.

`check_bp.py  x.x.x.x:8888 check_ratio`



