# 简介

Docker是一个开源的应用容器引擎，是一个轻量级容器技术

Docker支持将软件编译成一个镜像，然后在镜像中各种软件做好配置，将镜像发布出去，其他使用者可以直接使用这个镜像

运行中的这个镜像称为容器，容器的启动是非常快速的

依赖于Linux内核特性：Namespace和Cgroups（Control Group）

# 核心概念

- docker主机(Host)：安装了Docker程序的机器（Docker是直接安装在操作系统上的）。主机上会运行docker的守护进程，客户端通过守护进程与docker交互，即客户端发送命令有守护进程接收并处理。
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

## 在Linux中安装（以centos7为例）

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

[更多命令](https://docs.docker.com/engine/reference/commandline/docker/)

每个镜像该如何配置，可以参考每一个镜像的文档
