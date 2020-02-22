# Docker qBittorrent的最佳实践
博客：https://sleele.com  
Docker Hub：https://hub.docker.com/r/superng6/qbittorrent  
GitHub：https://github.com/SuperNG6/Docker-qBittorrent  


# 之所以构建这个镜像的原因
__当前的镜像或多或少都有以下几点不符合的我的需求__
   
- 没有配置UID和GID
  > 这关系到你下载的文件的权限问题，默认是root权限，很难管理
- 镜像体积大
   > 大量qBittorrent images都在使用完整版ubuntu做基础基础镜像
   > 本镜像使用lsiobase/alpine:3.10作为基础镜像
   > 很多镜像使用alpine作为编译镜像，性能下降，使用`glibc`拒绝`musl`，Debian10下静态编译qBittorrent
 - 端口不全
   > 下载速度息息相关的BT下载DTH监听端口、BT下载监听端口，需要expose出来

   
# 本镜像的一些优点
- 全平台架构`x86-64`、`arm64`
- 默认简体中文
- 做了usermapping，使用你自己的账户权限来运行，这点对于群辉来说尤其重要
- 纯qBittorrent，没有包含多于的服务
- 超小镜像体积 46.27 MB
- 开放了BT下载DTH监听端口、BT下载监听端口（TCP/UDP 6881），加快下载速度
- 默认开启DHT并且创建了DHT文件，加速下载
- 自动更新trackers
- 静态编译qBittorrent（来自[userdocs/qbittorrent-nox-static](https://github.com/userdocs/qbittorrent-nox-static)，感谢）
- 内置400多条最新trackers（来自[XIU2 / TrackersListCollection](https://github.com/XIU2/TrackersListCollection)，感谢）
- 默认上海时区 Asia/Shanghai

# Architecture

| Architecture | Tag            |
| ------------ | -------------- |
| x86-64       | amd64-latest   |
| arm64        | arm64v8-latest |



# Changelogs
## 2020/02/03

      1、第一次提交
      2、优化镜像体积、最大化减小镜像尺寸
      3、多平台构建`x86-64`、`arm64·
      4、优化conf配置
      5、默认简体中文
      


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
