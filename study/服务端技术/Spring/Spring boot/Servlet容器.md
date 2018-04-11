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

## 替换为其他嵌入式Servlet容器

### Tomcat（springboot1版本默认使用）

```xml
<dependency>
   <groupId>org.springframework.boot</groupId>
   <!--引入web模块默认就依赖了tomcat-->
   <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

### 替换成Jetty

```xml
<!-- 引入web模块 -->
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-web</artifactId>
   <exclusions>
      <exclusion>
         <artifactId>spring-boot-starter-tomcat</artifactId>
         <groupId>org.springframework.boot</groupId>
      </exclusion>
   </exclusions>
</dependency>

<!--引入其他的Servlet容器-->
<dependency>
   <artifactId>spring-boot-starter-jetty</artifactId>
   <groupId>org.springframework.boot</groupId>
</dependency>
```

### 替换成Undertow

```xml
<!-- 引入web模块 -->
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-web</artifactId>
   <exclusions>
      <exclusion>
         <artifactId>spring-boot-starter-tomcat</artifactId>
         <groupId>org.springframework.boot</groupId>
      </exclusion>
   </exclusions>
</dependency>

<!--引入其他的Servlet容器-->
<dependency>
   <artifactId>spring-boot-starter-undertow</artifactId>
   <groupId>org.springframework.boot</groupId>
</dependency>
```

## 嵌入式Servlet容器自动配置原理

1. 嵌入式的Servlet容器自动配置类：EmbeddedServletContainerAutoConfiguration。其中引入了BeanPostProcessorsRegistrar类，这个类中有注册了后置处理器EmbeddedServletContainerCustomizerBeanPostProcessor
2. EmbeddedServletContainerAutoConfiguration根据导入的依赖情况，给容器中添加相应的EmbeddedServletContainerFactory

  ```java
  @AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE)
  @Configuration
  @ConditionalOnWebApplication
  //导入BeanPostProcessorsRegistrar，这个类里面又导入了EmbeddedServletContainerCustomizerBeanPostProcessor后置处理器（创建完对象，还没赋值赋值的时候进行初始化工作）
  @Import(BeanPostProcessorsRegistrar.class)
  public class EmbeddedServletContainerAutoConfiguration {
    @Configuration
    //判断当前是否引入了Tomcat依赖
    @ConditionalOnClass({ Servlet.class, Tomcat.class })
    //判断当前容器没有用户自己定义EmbeddedServletContainerFactory（嵌入式的Servlet容器工厂。作用：创建嵌入式的Servlet容器）
    @ConditionalOnMissingBean(value = EmbeddedServletContainerFactory.class, search = SearchStrategy.CURRENT)
    public static class EmbeddedTomcat {
      @Bean
      public TomcatEmbeddedServletContainerFactory tomcatEmbeddedServletContainerFactory() {
        return new TomcatEmbeddedServletContainerFactory();
      }
    }

    @Configuration
    @ConditionalOnClass({ Servlet.class, Server.class, Loader.class,WebAppContext.class })
    @ConditionalOnMissingBean(value = EmbeddedServletContainerFactory.class, search = SearchStrategy.CURRENT)
    public static class EmbeddedJetty {
      @Bean
      public JettyEmbeddedServletContainerFactory jettyEmbeddedServletContainerFactory() {
        return new JettyEmbeddedServletContainerFactory();
      }
    }

    @Configuration
    @ConditionalOnClass({ Servlet.class, Undertow.class, SslClientAuthMode.class })
    @ConditionalOnMissingBean(value = EmbeddedServletContainerFactory.class, search = SearchStrategy.CURRENT)
    public static class EmbeddedUndertow {
      @Bean
      public UndertowEmbeddedServletContainerFactory undertowEmbeddedServletContainerFactory() {
        return new UndertowEmbeddedServletContainerFactory();
      }
    }
  }
  ```

3. EmbeddedServletContainerFactory（嵌入式Servlet容器工厂），用来创建嵌入式的Servlet容器

  ```java
  public interface EmbeddedServletContainerFactory {
     //获取嵌入式的Servlet容器
     EmbeddedServletContainer getEmbeddedServletContainer(ServletContextInitializer... initializers);
  }
  ```

4. EmbeddedServletContainer：（嵌入式的Servlet容器）。以**TomcatEmbeddedServletContainerFactory**为例

  ```java
  @Override
  public EmbeddedServletContainer getEmbeddedServletContainer(ServletContextInitializer... initializers) {
    //创建一个Tomcat
    Tomcat tomcat = new Tomcat();

    //配置Tomcat的基本环节
    File baseDir = (this.baseDirectory != null ? this.baseDirectory : createTempDir("tomcat"));
    tomcat.setBaseDir(baseDir.getAbsolutePath());
    Connector connector = new Connector(this.protocol);
    tomcat.getService().addConnector(connector);
    customizeConnector(connector);
    tomcat.setConnector(connector);
    tomcat.getHost().setAutoDeploy(false);
    configureEngine(tomcat.getEngine());
    for (Connector additionalConnector : this.additionalTomcatConnectors) {
      tomcat.getService().addConnector(additionalConnector);
    }
    prepareContext(tomcat.getHost(), initializers);

    //将配置好的Tomcat传入进去，返回一个EmbeddedServletContainer；并且启动Tomcat服务器
    return getTomcatEmbeddedServletContainer(tomcat);
  }
  ```

5. 容器中导入了**EmbeddedServletContainerCustomizerBeanPostProcessor**，只要有EmbeddedServletContainerFactory初始化，后置处理器就会将所有**EmbeddedServletContainerCustomizer**（定制器）的定制方法都执行一次，从而修改了Servlet容器的配置。因此，修改容器配置有两种方式：
  1. 通过修改资源文件，修改ServerProperties中定义的值（ServerProperties也是一个EmbeddedServletContainerCustomizer）
  2. 在容器中注册一个自定义的EmbeddedServletContainerCustomizer

  ```java
  //初始化之前
  @Override
  public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
    if (bean instanceof ConfigurableEmbeddedServletContainer) {
      postProcessBeforeInitialization((ConfigurableEmbeddedServletContainer) bean);
    }
    return bean;
  }

  private void postProcessBeforeInitialization(ConfigurableEmbeddedServletContainer bean) {
    //获取所有的定制器，调用每一个定制器的customize方法来给Servlet容器进行属性赋值；
    for (EmbeddedServletContainerCustomizer customizer : getCustomizers()) {
      customizer.customize(bean);
    }
  }

  private Collection<EmbeddedServletContainerCustomizer> getCustomizers() {
    if (this.customizers == null) {
      this.customizers = new ArrayList<EmbeddedServletContainerCustomizer>(
      //从容器中获取所有EmbeddedServletContainerCustomizer组件
      //定制Servlet容器，只需要给容器中可以添加一个EmbeddedServletContainerCustomizer类型的组件
      //ServerProperties也是一个定制器
      this.beanFactory.getBeansOfType(EmbeddedServletContainerCustomizer.class,
      false, false).values());
      Collections.sort(this.customizers, AnnotationAwareOrderComparator.INSTANCE);
      this.customizers = Collections.unmodifiableList(this.customizers);
    }
    return this.customizers;
  }
  ```

## 嵌入式Servlet容器启动原理

1. SpringBoot应用启动运行run方法
2. 会执行refreshContext(context)，SpringBoot刷新IOC容器（创建IOC容器对象，并初始化容器，创建容器中的每一个组件）。如果是web应用创建**AnnotationConfigEmbeddedWebApplicationContext**，否则：**AnnotationConfigApplicationContext**
3. refresh(context);**刷新刚才创建好的ioc容器**（与Spring中的一致）
4. onRefresh(); web的ioc容器重写了onRefresh方法
5. webioc容器会创建嵌入式的Servlet容器，**createEmbeddedServletContainer**();
6. **获取嵌入式的Servlet容器工厂：**EmbeddedServletContainerFactory containerFactory = getEmbeddedServletContainerFactory();
7. **使用容器工厂获取嵌入式的Servlet容器**：this.embeddedServletContainer = containerFactory.getEmbeddedServletContainer(getSelfInitializer());
8. 嵌入式的Servlet容器创建对象并启动Servlet容器

# 使用外置的Servlet容器

使用嵌入式Servlet容器，应用打成可执行的jar即可

优点：简单、便携

缺点：默认不支持JSP，优化定制比较复杂（使用定制器【ServerProperties、自定义EmbeddedServletContainerCustomizer】，自己编写嵌入式Servlet容器的创建工厂【EmbeddedServletContainerFactory】）

## 步骤

1. 必须创建一个war项目（利用idea创建好目录结构，webapp目录）
2. 将嵌入式的Tomcat指定为provided

  ```xml
  <dependency>
     <groupId>org.springframework.boot</groupId>
     <artifactId>spring-boot-starter-tomcat</artifactId>
     <scope>provided</scope>
  </dependency>
  ```

3. 必须编写一个**SpringBootServletInitializer**的子类，并调用configure方法

  ```java
  public class ServletInitializer extends SpringBootServletInitializer {

     @Override
     protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
         //传入SpringBoot应用的主程序
        return application.sources(SpringBoot04WebJspApplication.class);
     }
  }
  ```

4. 启动服务器就可以使用（在idea中，使用平常的启动方式）


## 原理

- jar包：执行SpringBoot主类的main方法，启动ioc容器，创建嵌入式的Servlet容器
- war包：启动服务器，**服务器启动SpringBoot应用**【SpringBootServletInitializer】，启动ioc容器

servlet3.0（Spring注解版）中，8.2.4 Shared libraries / runtimes pluggability规则：

1. 服务器启动（web应用启动）会创建当前web应用里面，每一个jar包中ServletContainerInitializer实例
2. ServletContainerInitializer的所在jar包中，META-INF/services文件夹下，有一个名为javax.servlet.ServletContainerInitializer的文件，内容就是ServletContainerInitializer的实现类的全类名
3. 还可以使用@HandlesTypes，在应用启动的时候加载WebApplicationInitializer类

流程：

1. 启动Tomcat
2. spring-web-4.3.14.RELEASE.jar包中有\META-INF\services\javax.servlet.ServletContainerInitializer文件
3. SpringServletContainerInitializer将@HandlesTypes(WebApplicationInitializer.class)标注的所有这个类型的类都传入到onStartup方法的Set<Class<?>>；为这些WebApplicationInitializer类型的类创建实例
4. 每一个WebApplicationInitializer都调用自己的onStartup
5. SpringBootServletInitializer也是一个WebApplicationInitializer类，相当于我们的SpringBootServletInitializer的类会被创建对象，并执行onStartup方法
6. SpringBootServletInitializer实例执行onStartup的时候会创建容器

  ```java
  protected WebApplicationContext createRootApplicationContext(ServletContext servletContext) {
    //1、创建SpringApplicationBuilder
    SpringApplicationBuilder builder = createSpringApplicationBuilder();
    StandardServletEnvironment environment = new StandardServletEnvironment();
    environment.initPropertySources(servletContext, null);
    builder.environment(environment);
    builder.main(getClass());
    ApplicationContext parent = getExistingRootWebApplicationContext(servletContext);
    if (parent != null) {
      this.logger.info("Root context already created (using as parent).");
      servletContext.setAttribute(WebApplicationContext.ROOT_WEB_APPLICATION_CONTEXT_ATTRIBUTE, null);
      builder.initializers(new ParentContextApplicationContextInitializer(parent));
    }
    builder.initializers(new ServletContextApplicationContextInitializer(servletContext));
    builder.contextClass(AnnotationConfigEmbeddedWebApplicationContext.class);

    //调用configure方法，子类重写了这个方法，将SpringBoot的主程序类传入了进来
    builder = configure(builder);

    //使用builder创建一个Spring应用
    SpringApplication application = builder.build();
    if (application.getSources().isEmpty() && AnnotationUtils.findAnnotation(getClass(), Configuration.class) != null) {
      application.getSources().add(getClass());
    }
    Assert.state(!application.getSources().isEmpty(), "No SpringApplication sources have been defined. Either override the " + "configure method or add an @Configuration annotation");
    // Ensure error pages are registered
    if (this.registerErrorPageFilter) {
      application.getSources().add(ErrorPageFilterConfiguration.class);
    }
    //启动Spring应用
    return run(application);
  }
  ```

7. Spring的应用就启动并且创建IOC容器

  ```java
  public ConfigurableApplicationContext run(String... args) {
     StopWatch stopWatch = new StopWatch();
     stopWatch.start();
     ConfigurableApplicationContext context = null;
     FailureAnalyzers analyzers = null;
     configureHeadlessProperty();
     SpringApplicationRunListeners listeners = getRunListeners(args);
     listeners.starting();
     try {
        ApplicationArguments applicationArguments = new DefaultApplicationArguments(
              args);
        ConfigurableEnvironment environment = prepareEnvironment(listeners,
              applicationArguments);
        Banner printedBanner = printBanner(environment);
        context = createApplicationContext();
        analyzers = new FailureAnalyzers(context);
        prepareContext(context, environment, listeners, applicationArguments,
              printedBanner);

        //刷新IOC容器
        refreshContext(context);
        afterRefresh(context, applicationArguments);
        listeners.finished(context, null);
        stopWatch.stop();
        if (this.logStartupInfo) {
           new StartupInfoLogger(this.mainApplicationClass)
                 .logStarted(getApplicationLog(), stopWatch);
        }
        return context;
     }
     catch (Throwable ex) {
        handleRunFailure(context, listeners, analyzers, ex);
        throw new IllegalStateException(ex);
     }
  }
  ```

**==启动Servlet容器，再启动SpringBoot应用==**
