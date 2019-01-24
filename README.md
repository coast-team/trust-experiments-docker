# Trust Experiments


## Docker Installation


First, you need to download z-Tree (https://www.uzh.ch/ztree/) and put the ``ztree.exe`` and ``zleaf.exe`` to the ``ztree/`` directory.


Then, you need to download the ``.ztt`` files related to your experiments and put them also in the ``ztree/``directory.

```bash
curl -L https://github.com/Purpleskill/trust_influence_analysis/raw/master/ztree_programs/real_users_trust_reputation_scores_deviation.ztt --output ztree/real_users_trust_reputation_scores_deviation.ztt
```

You may need also to download the python script to generate games order (``random_games_order.py``) and to put it in the ``ztree/`` directory.

```bash
curl -L https://github.com/Purpleskill/trust_influence_analysis/raw/master/datafiles_ztree/Random_games_order.py --output ztree/random_games_order.py
```

Finally, you need to udpate noVNC git submodule using the following command:
```bash
git submodule update noVNC
```

#### To build the container image

```bash
docker build -t coast-team/ztree-x11-novnc-docker .
```

The docker container contains:
- Xvfb: X virtual framebuffer is a display server
- x11vnc: VNC server for X displays
- supervisor: Process control system
- fluxbox: Lightweight WindowManager for X
- noVNC (https://github.com/novnc/noVNC): HTML VNC client JavaScript library
- Wine: to run Windows application
- z-Tree: Zurich Toolbox for Readymade Economic Experiments


#### To launch ztree server

```bash
docker run -p 9009:8081 -dt --name ztree coast-team/ztree-x11-novnc-docker
```

#### To launch ztree client(s)

```bash
for i in {1..6}; do docker run -p 808$i:8081 -dt --name zleaf$i coast-team/ztree-x11-novnc-docker; done
```

Note: Here is the command of a single container 
```bash
docker run -p 8081:8081 -dt --name zleaf1 coast-team/ztree-x11-novnc-docker
```


#### To start ztree server

```bash
docker exec ztree /bin/bash -c 'cd /home/ztree && wine ztree.exe'
```

#### To kill ztree server

```bash
docker exec ztree /bin/bash -c 'killall ztree.exe'
```

#### To start client(s)

```bash
for i in {1..6}; do docker exec -d zleaf$i /bin/bash -c 'cd /home/ztree && wine zleaf.exe /server 172.17.0.2'; done
```

Note: Here is the command of a single container 
```bash
docker exec zleaf1 /bin/bash -c 'cd /home/ztree && wine zleaf.exe /server 172.17.0.2'
```

#### To kill all client(s)

```bash
for i in {1..6}; do docker exec zleaf$i /bin/bash -c 'killall zleaf.exe'; done
```

#### To stop containers

```bash
docker stop ztree
for i in {1..6}; do docker stop zleaf$i'; done
```

and then you can remove them (if you do not need any data)

```bash
docker rm ztree
for i in {1..6}; do docker rm zleaf$i'; done
```



