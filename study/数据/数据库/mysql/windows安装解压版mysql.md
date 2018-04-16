1. 下载安装包，解压到 `D:\develop\mysql\mysql-5.7.12-winx64`
2. 在 `D:\develop\mysql\mysql-5.7.12-winx64` 目录添加my.ini文件

  ```
  [mysql]
  #设置mysql客户端默认字符集
  default-character-set=utf8
  [mysqld]
  #设置3306端口
  port = 3306
  #设置mysql的安装目录
  basedir=D:\develop\mysql\mysql-5.7.12-winx64
  #设置mysql数据库的数据的存放目录
  datadir=D:\develop\mysql\mysql-5.7.12-winx64\data
  #允许最大连接数
  max_connections=200
  #服务端使用的字符集默认为8比特编码的latin1字符集
  character-set-server=utf8
  #创建新表时将使用的默认存储引擎
  default-storage-engine=INNODB
  ```

3. 配置环境变量path，添加 `D:\develop\mysql\mysql-5.7.12-winx64\bin`
4. 添加mysql服务
  - 以管理员身份打开cmd窗口，输入 `mysqld install`（移除服务用 `mysqld remove`）回车运行就可以了，**注意是mysqld不是mysql**
  - 如果不希望mysql服务自动启动，需要打开服务列表（运行-->services.msc）设置服务属性。
5. 输入 `mysqld  --initialize` 先初始化data目录
6. 输入 `net start mysql` 启动服务
  - 此时使用 `mysql -uroot -p` 登陆会报错：ERROR 1045 (28000): Access denied for user'root'@'localhost'(using password: NO)。由于尚未设置root用户密码
7. 先停止mysql服务（`net stop mysql`），然后进入安全模式：`mysqld --defaults-file="E:\mysql5.7\my.ini" --console --skip-grant-tables`
8. 另开一个命令窗口（管理员身份运行）
  - 输入 `mysql -uroot -p`，此时需要输入密码，直接回车进入数据库
  - 尝试修改密码

    ```shell
    mysql> use mysql;
    mysql>update user set authentication_string=password("新密码") where user="root";
    mysql>flush privileges; \\刷新权限
    ```

9. 关闭这两个命令窗口，重新启动mysql服务，再打开一个命令行窗口，使用刚才设置的密码登陆mysql
  - 此时登陆后，mysql会要求重新设置密码才能操作

    ```shell
    mysql> show databases;
    ERROR 1820 (HY000): You must reset your password using ALTER USER statement before executing this statement.
    ```

10. 重新设置密码，即可正常使用
  ```shell
  mysql> set password for root@localhost = password('123');
  ```
