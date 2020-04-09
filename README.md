# Docker qBittorrent 未完善
博客：https://sleele.com  
Docker Hub：https://hub.docker.com/r/superng6/qbittorrent  
GitHub：https://github.com/SuperNG6/Docker-qBittorrent  


# 本镜像的一些优点
- 全平台架构`x86-64`、`arm64`、`arm32`
- 默认简体中文
- 做了usermapping，使用你自己的账户权限来运行，这点对于群辉来说尤其重要
- 纯qBittorrent，没有包含多于的服务
- 基于`linuxserver/qbittorrent`,每周构建一次，同步更新最新版本qbittorrent
- 开放了BT下载DTH监听端口、BT下载监听端口（TCP/UDP 6881），加快下载速度
- 默认开启DHT，加速下载
- 内置400多条最新trackers（来自[XIU2 / TrackersListCollection](https://github.com/XIU2/TrackersListCollection)，感谢）
- 默认上海时区 Asia/Shanghai

# Architecture

| Architecture | Tag            |
| ------------ | -------------- |
| x86-64       | latest   |
| arm64        | latest |
| arm32        | latest |



# Changelogs
## 2020/04/09

      1、放弃之前自编译方案
      2、基于`linuxserver/qbittorrent`构建，仅添加添加了配置文件，默认中文，上海时区
      3、自带优化后的config，减少设置，开箱即用
      4、稳定，由`linuxserver/qbittorrent`维护
      5、每周一自动拉去镜像`qbittorrent`构建
      
## 2020/02/03

      1、第一次提交
      2、优化镜像体积、最大化减小镜像尺寸
      3、多平台构建`x86-64`、`arm64·
      4、优化conf配置
      5、默认简体中文
      
# review
![svOCHj](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/svOCHj.png)

# Document

## 挂载路径
``/config`` ``/downloads``

## 关于群晖

群晖用户请使用你当前的用户SSH进系统，输入 ``id 你的用户id`` 获取到你的UID和GID并输入进去

![nwmkxT](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/nwmkxT.jpg)
![1d5oD8](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/1d5oD8.jpg)
![JiGtJA](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/JiGtJA.jpg)

### 权限管理设置
对你的``docker配置文件夹的根目录``进行如图操作，``你的下载文件夹的根目录``进行相似操作，去掉``管理``这个权限，只给``写入``,``读取``权限
![r4dsfV](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/r4dsfV.jpg)


## Linux

输入 ``id 你的用户id`` 获取到你的UID和GID，替换命令中的PUID、PGID

__执行命令__
````
docker create  \
    --name=qbittorrent  \
    -e WEBUIPORT=8080  \
    -e PUID=1026
    -e PGID=100
    -e TZ=Asia/Shanghai
    -p 6881:6881  \
    -p 6881:6881/udp  \
    -p 8080:8080  \
    -v /配置文件位置:/config  \
    -v /下载位置:/downloads  \
    --restart unless-stopped  \
    superng6/qbittorrent:latest
````
docker-compose  
````
version: "2"
services:
  aria2:
    image: superng6/qbittorrent
    container_name: qbittorrent
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Asia/Shanghai
    volumes:
      - /path/to/appdata/config:/config
      - /path/to/downloads:/downloads
    ports:
      - 6881:6881
      - 6881:6881/udp
      - 8080:8080
    restart: unless-stopped
````
