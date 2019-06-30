Supported Platforms
--------------------

1. MacOS
2. Linux
3. Windows

Prerequisites
--------------
1. Virtualbox >= 5.2.26
2. Vagrant >= 2.1.5
3. Install plugins
    - vagrant-docker-compose 
    ``` vagrant plugin install vagrant-docker-compose ```

How to Run
------------

``` vagrant up ```

Caveats
--------

 - You will be prompted to choose from bridged network interfaces when running ``` vagrant up ```. 
   Please choose the one that has connection to internet. 