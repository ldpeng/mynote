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

Docker从1.13版本之后采用时间线的方式作为版本号，分为社区版CE和企业版EE。

社区版是免费提供给个人开发者和小型团体使用的，企业版会提供额外的收费服务，比如经过官方测试认证过的基础设施、容器、插件等。

社区版按照stable和edge两种方式发布，每个季度更新stable版本，如17.06，17.09；每个月份更新edge版本，如17.09，17.10。

步骤：

1. 检查内核版本 `uname -r`，必须是3.10及以上
    - 如果版本过低则需要升级 `yum update`
2. 卸载旧版本(如果安装过旧版本的话) `yum remove docker  docker-common docker-selinux docker-engine`
3. 安装需要的软件包, yum-util提供yum-config-manager功能,另外两个是devicemapper驱动依赖的 `yum install -y yum-utils device-mapper-persistent-data lvm2`
4. 设置yum源 `yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo`
5. 可以查看所有仓库中所有docker版本，并选择特定版本安装 `yum list docker-ce --showduplicates | sort -r`
6. 安装docker `yum install docker-ce`，并输入y确认安装
7. 启动docker `systemctl start docker`
  - 可以设置为开机启动docker `systemctl enable docker`
8. 停止docker `systemctl stop docker`

## Mac中安装

使用brew cask（安装桌面程序，省去手工下载的步骤）命令安装

```shell
brew cask install docker
```

可以使用`docker -v`命令，查看docker的版本

[更多命令](https://docs.docker.com/engine/reference/commandline/docker/)

每个镜像该如何配置，可以参考每一个镜像的文档
