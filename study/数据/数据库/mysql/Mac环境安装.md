1、安装

```
brew install mysql
```

2、启动mysql

```
 brew services start mysql
```

对应停止服务命令为

```
 brew services stop mysql
```

3、设置 root 用密码，及其他配置

```
mysql_secure_installation
```

输入以上命令后，根据英文提示配置

4、使用密码登录mysql

```
mysql -uroot -p
```

