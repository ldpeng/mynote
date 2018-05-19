docker-compose用于统一配置docker容器，配置文件一般命名为`docker-compose.yml`

```yml
mysql:
   image: csphere/mysql:5.5
   ports:
     - "3306:3306"
   volumes:
     - /var/lib/docker/vfs/dir/dataxc:/var/lib/mysql
   hostname: mydb.server.com

tomcat:
   image: csphere/tomcat:7.0.55
   ports:
      - "8080:8080"
   links:
      - mysql:db
   environment:
      - TOMCAT_USER=admin
      - TOMCAT_PASS=admin
   hostname: tomcat.server.com
```

- 运行容器：`docker-compose up -d`
- 停止容器：`docker-compose stop`
- 查看所运行的容器：`docker-compose ps`
- 删除容器：`docker-compose rm`
