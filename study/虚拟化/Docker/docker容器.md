# 容器常用操作

软件镜像----运行镜像----产生一个容器（同一个镜像可生成多个容器）

步骤：

1. 搜索镜像 `docker search tomcat`
2. 拉取镜像 `docker pull tomcat`
3. 根据镜像启动容器 `docker run --name 自定义容器名 -d tomcat:latest`
4. 查看运行中的容器 `docker ps`
5. 停止运行中的容器 `docker stop 容器的id` 或 `docker kill 容器ID`
  - stop是给容器发送结束信号
  - kill是直接停止
6. 查看所有的容器 `docker ps -al`
  - -a 列出所有容器
  - -l 列出最新的容器
  - 不传参数则列出正在运行的容器
7. 启动容器 `docker start 容器id`
8. 删除一个容器 `docker rm 容器id`
  - 删除所有容器 `docker rm -f $(docker ps -a -p)`
9. 启动一个做了端口映射的tomcat `docker run -d -p 8888:8080 tomcat`
  - -d: 后台运行
  - -p: 将主机的端口映射到容器的一个端口(主机端口:容器内部的端口)
  - 通过 -e 可以传递环境变量
10. 查看容器的日志 `docker logs [-f][-t] [--tail] container-name/container-id`
  - -f 一直跟踪并返回结果：--follows=true|false 默认为false
  - -t 在返回结果中加上时间戳：--timestamps=true|false 默认为false
  - --tail=“all” 返回结尾处多少数量的日志，如果不知道，则返回所有
  ```shell
  docker logs -tf --tail 10 container-name/container-id
  ```

# 启动交互式容器

```shell
docker run -it IMAGE /bin/bash
```

- -i 相当于--interactive=true|false 默认是false 是否永久活跃
- -t 相当于--tty=true|false 默认是false 启动一个伪tty终端
- IMAGE 是镜像名

如：

```shell
docker run -it ubuntu /bin/bash
```

此命令会先创建一个容器，再进入其交互式模式中

输入`exit`即可退出交互模式，同时容器也会停止

# 其他命令

- 容器详细信息
  ```shell
  docker inspect 容器ID或容器名称
  ```
- 进入一个守护式运行的容器的交互式模式
  ```shell
  docker attach 容器ID或容器名
  ```
- 查看容器内进程
  ```shell
  docker top 容器ID或容器名
  ```
- 在运行中的容器中启动新的进程
  ```shell
  docker exec [-d] [-i] [-t] 容器ID或容器名 [COMMAND][ARG...]
  ```
  `exec`也可以进入交互式模式

# 端口映射

通过run命令启动时，可以指定主机与容器的端口映射

- -P 表示映射全部端口。--publish-all=true|false 默认为false
- -p 指定哪些容器端口。 --publish=[]
