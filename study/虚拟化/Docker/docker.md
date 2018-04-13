# 简介

Docker是一个开源的应用容器引擎，是一个轻量级容器技术

Docker支持将软件编译成一个镜像，然后在镜像中各种软件做好配置，将镜像发布出去，其他使用者可以直接使用这个镜像

运行中的这个镜像称为容器，容器的启动是非常快速的

# 核心概念

- docker主机(Host)：安装了Docker程序的机器（Docker是直接安装在操作系统上的）
- docker客户端(Client)：连接docker主机进行操作的程序
- docker仓库(Registry)：用来保存各种打包好的软件镜像
- docker镜像(Images)：软件打包好的镜像，放在docker仓库中
- docker容器(Container)：镜像启动后的实例称为一个容器，容器是独立运行的一个或一组应用

![docker使用步骤](images/docker使用步骤.png)

使用Docker的步骤：

1. 安装Docker
2. 去Docker仓库找到这个软件对应的镜像
3. 使用Docker运行这个镜像，这个镜像就会生成一个Docker容器
4. 对容器的启动停止就是对软件的启动停止

# 安装、启动、停止

## 在Linux中安装（已centos7为例）

步骤：

1. 检查内核版本 `uname -r`，必须是3.10及以上
  - 如果版本过低则需要升级 `yum update`
2. 安装docker `yum install docker`，并输入y确认安装
3. 启动docker `systemctl start docker`
  - 可以设置为开机启动docker `systemctl enable docker`
4. 停止docker `systemctl stop docker`

## Mac中安装

使用brew cask（安装桌面程序，省去手工下载的步骤）命令安装

```shell
brew cask install docker
```

可以使用`docker -v`命令，查看docker的版本

## Docker常用命令和操作

### 镜像操作

| 操作 | 命令                                            | 说明                                                                               |
| ---- | ----------------------------------------------- | ---------------------------------------------------------------------------------- |
| 检索 | docker  search 关键字  eg：docker  search redis | 我们经常去[docker  hub](https://hub.docker.com)上检索镜像的详细信息，如镜像的TAG。 |
| 拉取 | docker pull 镜像名:tag                          | :tag是可选的，tag表示标签，多为软件的版本，默认是latest                            |
| 列表 | docker images                                   | 查看所有本地镜像                                                                   |
| 删除 | docker rmi image-id                             | 删除指定的本地镜像                                                                 |

## 容器操作

软件镜像----运行镜像----产生一个容器（同一个镜像可生成多个容器）

步骤：

1. 搜索镜像 `docker search tomcat`
2. 拉取镜像 `docker pull tomcat`
3. 根据镜像启动容器 `docker run --name mytomcat -d tomcat:latest`
4. 查看运行中的容器 `docker ps`
5. 停止运行中的容器 `docker stop 容器的id`
6. 查看所有的容器 `docker ps -a`
7. 启动容器 `docker start 容器id`
8. 删除一个容器 `docker rm 容器id`
9. 启动一个做了端口映射的tomcat `docker run -d -p 8888:8080 tomcat`
  - -d: 后台运行
  - -p: 将主机的端口映射到容器的一个端口(主机端口:容器内部的端口)
10. 查看容器的日志 `docker logs container-name/container-id`

[更多命令](https://docs.docker.com/engine/reference/commandline/docker/)

每个镜像该如何配置，可以参考每一个镜像的文档
