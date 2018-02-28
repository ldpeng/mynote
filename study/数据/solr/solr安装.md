# 单机版安装

注意：以下步骤基于solr-7.2.1

## 准备工作

- 下载tomcat
- 下载solr-7.2.1.tar

## 安装步骤

1. 解压下载好的tomcat及solr包

```shell
tar -xvf solr-7.2.1.tar
```

当前将solr解压到/Users/ldp/develop/solr/solr-7.2.1目录，后续基于这个目录进行讲解

2. 拷贝目录 /Users/ldp/develop/solr/solr-7.2.1/server/solr-webapp/webapp 到tomcat的webapp目录中，并重命名为solr（可根据自己喜好命名）

3. 配置solr的home目录。（这里定义为：/Users/ldp/develop/solr/solrhome）
    
    拷贝/Users/ldp/develop/solr/solr-7.2.1/server/solr中的solr.xml和zoo.cfg到 solrhome 目录中
    
4. 找到第2步tomcat中的solr项目的web.xml文件，并修改
    1. 解开env-entry的注释，并修改
    2. 注释掉security-constraint节点

```xml
<env-entry>
    <env-entry-name>solr/home</env-entry-name>
    <env-entry-value>/Users/ldp/develop/solr/solrhome</env-entry-value>
    <env-entry-type>java.lang.String</env-entry-type>
</env-entry>
```

```xml
<!-- Get rid of error message -->
<!--
<security-constraint>
    <web-resource-collection>
        <web-resource-name>Disable TRACE</web-resource-name>
        <url-pattern>/</url-pattern>
        <http-method>TRACE</http-method>
    </web-resource-collection>
    <auth-constraint/>
</security-constraint>
<security-constraint>
    <web-resource-collection>
        <web-resource-name>Enable everything but TRACE</web-resource-name>
        <url-pattern>/</url-pattern>
        <http-method-omission>TRACE</http-method-omission>
    </web-resource-collection>
</security-constraint>
-->
```

5. 拷贝文件 /Users/ldp/develop/solr/solr-7.2.1/server/resources/log4j.properties 到 tomcat中的solr项目的 WEB-INF/classes目录(如果没有，则自行创建)中，并制定日志输出路径

```
solr.log=/Users/ldp/develop/solr/solrhome/logs
```

6. 启动tomcat，访问`http://localhost:8080/solr/index.html`访问solr后台

## 创建core

core可以理解为数据库的概念。一个mysql服务，可以支持多个数据库。

### 手工创建一个core

1. 在solrhome目录中，新加一个目录core1
2. 将目录 /Users/ldp/develop/solr/solr-7.2.1/server/solr/configsets/_default/conf 拷贝到 core1 中
3. 在 core1 目录中创建目录 data
4. 在 core1 目录中创建文件 core.properties，并输入如下配置

```
name=core1
config=conf/solrconfig.xml
dataDir=data
```

5. 重启tomcat，就会发现多了一个core

注意：以后需要再新建core可以直接将core1目录拷贝一份，修改core.properties文件即可

## 配置中文分析器

1. 将ik-analyzers-5.1.0.jar拷贝到tomcat中solr项目的/WBE-INF/lib目录中
2. 将ik分析器的配置文件（IKAnalyzer.cfg.xm、ext.dic、stopword.dic）配置到solr项目的/WBE-INF/classes目录中
3. 在对应的code目录中，找到 /conf/managed-schema 文件，添加一个自定义的fieldType，及对应的域

```xml
<!-- IKAnalyzer-->
<fieldType name="text_ik" class="solr.TextField">
    <analyzer class="org.wltea.analyzer.lucene.IKAnalyzer"/>
</fieldType>

<!--IKAnalyzer Field-->
<field name="title_ik" type="text_ik" indexed="true" stored="true" />
<field name="content_ik" type="text_ik" indexed="true" stored="false" multiValued="true"/>
<dynamicField name="*_sik" type="text_ik" indexed="true" stored="true"/>
```