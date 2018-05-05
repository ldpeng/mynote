# 安装

## Mac中安装

```
brew install redis
```

## Linux中安装

1. 安装redis编译的c环境，yum install gcc-c++
2. 将redis-2.6.16.tar.gz上传到Linux系统中
3. 解压到/usr/local下 `tar -xvf redis-2.6.16.tar.gz -C /usr/local`
4. 进入redis-2.6.16目录 使用 `make` 命令编译redis
5. 在redis-2.6.16目录中使用 `make PREFIX=/usr/local/redis install` 命令安装redis到/usr/local/redis中

# 启动、连接、停止Redis服务

## 启动

执行Redis安装目录的bin目录下redis-server

```
./redis-server
```

注意：这样启动属于前台启动，终端窗口不能关，关了Redis就停了

### 后台启动

1. 拷贝redis-2.6.16中的redis.conf到安装目录redis中
2. 将redis.conf文件中的daemonize从false修改成true表示后台启动
3. 启动redis在bin下执行命令redis-server redis.conf

如需远程连接redis，需配置redis端口6379在防火墙中开放

```
/sbin/iptables -I INPUT -p tcp --dport 6379 -j ACCEPT
/etc/rc.d/init.d/iptables save
```

使用命令查看6379端口是否启动`ps -ef | grep redis`

## 连接

执行Redis安装目录的bin目录下redis-cli

```
./redis-cli
```

连接远程服务需要完成命令
```
./redis-cli -h ip地址 -p 端口
```

## 停止

有两种方式可以停止Redis服务

- 通过redis-cli命令连接到Redis服务后，使用shutdown命令，可以关闭Redis服务
- 通过杀进程的方式
