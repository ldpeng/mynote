# 根据泛型注入

spring4特性新特性，可以根据泛型类型注入对象

```java
public abstract class BaseService<T extends BasePojo> {
  @Autowired
  private Mapper<T> mapper;
}
```

# Spring的父子容器

- Spring是父容器
- SpringMVC是子容器

注意：

- 子容器能获取父容器的资源（bean）
- 父容器不能访问子容器的资源

# 解决RESTful中put和delete方法不能携带请求体的问题

默认情况下，http请求中，PUT和DELETE方式是不能传表单数据的（这里指的是服务器不能接收），导致使用PUT请求修改时，接收不到数据

解决办法：web.xml文件中添加过滤器

```xml
<!-- 配置过滤器解决PUT请求无法提交表单的问题 -->
<filter>
  <filter-name>HttpMethodFilter</filter-name>
  <filter-class>org.springframework.web.filter.HttpPutFormContentFilter</filter-class>
</filter>
<filter-mapping>
  <filter-name>HttpMethodFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
```

## 将POST请求转换成PUT/DELETE

web.xml文件中添加过滤器

```xml
<!--
  将POST请求转化为DELETE或者是PUT
  要用_method指定真正的请求参数
 -->
<filter>
  <filter-name>HiddenHttpMethodFilter</filter-name>
  <filter-class>org.springframework.web.filter.HiddenHttpMethodFilter</filter-class>
</filter>
<filter-mapping>
  <filter-name>HiddenHttpMethodFilter</filter-name>
  <url-pattern>/*</url-pattern>
</filter-mapping>
```

然后前台仍然通过POST方法进行请求，再通过 `_method` 参数指定真正的请求方法
