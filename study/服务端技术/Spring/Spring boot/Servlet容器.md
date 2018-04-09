# 配置嵌入式Servlet容器

SpringBoot(1.5版本)默认使用Tomcat作为嵌入式的Servlet容器

## 如何定制和修改Servlet容器的相关配置

1. 修改和server有关的配置信息（ServerProperties）

  ```properties
  server.port=8081
  server.context-path=/crud

  server.tomcat.uri-encoding=UTF-8

  //通用的Servlet容器设置
  server.xxx
  //Tomcat的设置
  server.tomcat.xxx
  ```

2. 编写一个**EmbeddedServletContainerCustomizer**（嵌入式的Servlet容器的定制器）。来修改Servlet容器的配置

  ```java
  @Bean  //一定要将这个定制器加入到容器中
  public EmbeddedServletContainerCustomizer embeddedServletContainerCustomizer(){
      return new EmbeddedServletContainerCustomizer() {
          //定制嵌入式的Servlet容器相关的规则
          @Override
          public void customize(ConfigurableEmbeddedServletContainer container) {
              container.setPort(8083);
          }
      };
  }
  ```
## 注册Servlet三大组件（Servlet、Filter、Listener）

由于SpringBoot默认是以jar包的方式启动嵌入式的Servlet容器来启动SpringBoot的web应用，没有web.xml文件。

注册三大组件需要用以下方式：

- ServletRegistrationBean

  ```java
  @Bean
  public ServletRegistrationBean myServlet(){
    ServletRegistrationBean registrationBean = new ServletRegistrationBean(new MyServlet(),"/myServlet");
    return registrationBean;
  }
  ```

- FilterRegistrationBean

  ```java
  @Bean
  public FilterRegistrationBean myFilter(){
    FilterRegistrationBean registrationBean = new FilterRegistrationBean();
    registrationBean.setFilter(new MyFilter());
    registrationBean.setUrlPatterns(Arrays.asList("/hello","/myServlet"));
    return registrationBean;
  }
  ```

- ServletListenerRegistrationBean

  ```java
  @Bean
  public ServletListenerRegistrationBean myListener(){
    ServletListenerRegistrationBean<MyListener> registrationBean = new ServletListenerRegistrationBean<>(new MyListener());
    return registrationBean;
  }
  ```

SpringBoot自动配置SpringMVC的时候，会自动注册SpringMVC的前端控制器DIspatcherServlet（代码在DispatcherServletAutoConfiguration中）

```java
@Bean(name = DEFAULT_DISPATCHER_SERVLET_REGISTRATION_BEAN_NAME)
@ConditionalOnBean(value = DispatcherServlet.class, name = DEFAULT_DISPATCHER_SERVLET_BEAN_NAME)
public ServletRegistrationBean dispatcherServletRegistration(
    DispatcherServlet dispatcherServlet) {
 ServletRegistrationBean registration = new ServletRegistrationBean(
       dispatcherServlet, this.serverProperties.getServletMapping());
  //默认拦截： /  表示所有请求，包静态资源，但是不拦截jsp请求。如果是 /* 则会拦截jsp
  //可以通过server.servletPath来修改SpringMVC前端控制器默认拦截的请求路径
  registration.setName(DEFAULT_DISPATCHER_SERVLET_BEAN_NAME);
  registration.setLoadOnStartup(this.webMvcProperties.getServlet().getLoadOnStartup());
  if (this.multipartConfig != null) {
    registration.setMultipartConfig(this.multipartConfig);
  }
  return registration;
}
```
