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
    - guest additions plugin
    ``` vagrant plugin install vagrant-vbguest ```

How to Run
------------

``` vagrant up ```

Requirements
-------------

Provide a Vagrantfile, based on Virtual box which:
  [x] Start a Linux server
  [x] Install Docker daemon
  [x] Prometheus with Alertmanager as docker flavor
  [x] Deploy node exporter
  [x] Grafana as a dashboard to Prometheus 
  [x] Add Alert for having less than 50% free disk space, 
  [x] and this should be displayed on Grafana

Versions Tested
----------------

| Prometheus  | Grafana  | Node Exporter | Alertmanager |
|-------------|----------|---------------|--------------|
|   2.10.0    |  6.2.5   |    0.18.1     |   0.17.0     |



Caveats
--------

- You will be prompted to choose from bridged network interfaces when running ``` vagrant up ```. 
   Please choose the one that has connection to internet.

- My laptop does not have any disk which has less than 50% free space. To test alert is working I changed the threshold to >= 95% of free disk space. Triggerd alerts example you can find in ``` img ``` dir 


Links Used
-----------
- [Prometheus Installation](https://prometheus.io/docs/prometheus/latest/installation/)
- [Grafana Installation](https://grafana.com/docs/installation/docker/)
- [Grafana Provisioning](https://grafana.com/docs/administration/provisioning/)
- [Docker compose documentation](https://docs.docker.com/compose/compose-file/)