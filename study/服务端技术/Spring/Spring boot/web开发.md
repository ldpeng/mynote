# Web开发

## SpringBoot对静态资源的映射规则

```java
@ConfigurationProperties(prefix = "spring.resources", ignoreUnknownFields = false)
public class ResourceProperties implements ResourceLoaderAware {
  //可以设置和静态资源有关的参数，缓存时间等
```

WebMvcAuotConfiguration相关代码

```java
@Override
public void addResourceHandlers(ResourceHandlerRegistry registry) {
	if (!this.resourceProperties.isAddMappings()) {
		logger.debug("Default resource handling disabled");
		return;
	}
	Integer cachePeriod = this.resourceProperties.getCachePeriod();
	if (!registry.hasMappingForPattern("/webjars/**")) {
		customizeResourceHandlerRegistration(
				registry.addResourceHandler("/webjars/**")
						.addResourceLocations(
								"classpath:/META-INF/resources/webjars/")
				.setCachePeriod(cachePeriod));
	}
	String staticPathPattern = this.mvcProperties.getStaticPathPattern();
  //静态资源文件夹映射
	if (!registry.hasMappingForPattern(staticPathPattern)) {
		customizeResourceHandlerRegistration(
				registry.addResourceHandler(staticPathPattern)
						.addResourceLocations(
								this.resourceProperties.getStaticLocations())
				.setCachePeriod(cachePeriod));
	}
}

//配置欢迎页映射
@Bean
public WelcomePageHandlerMapping welcomePageHandlerMapping(
		ResourceProperties resourceProperties) {
	return new WelcomePageHandlerMapping(resourceProperties.getWelcomePage(),
			this.mvcProperties.getStaticPathPattern());
}

//配置喜欢的图标
@Configuration
@ConditionalOnProperty(value = "spring.mvc.favicon.enabled", matchIfMissing = true)
public static class FaviconConfiguration {

	private final ResourceProperties resourceProperties;

	public FaviconConfiguration(ResourceProperties resourceProperties) {
		this.resourceProperties = resourceProperties;
	}

	@Bean
	public SimpleUrlHandlerMapping faviconHandlerMapping() {
		SimpleUrlHandlerMapping mapping = new SimpleUrlHandlerMapping();
		mapping.setOrder(Ordered.HIGHEST_PRECEDENCE + 1);
    //所有  **/favicon.ico
		mapping.setUrlMap(Collections.singletonMap("**/favicon.ico",
				faviconRequestHandler()));
		return mapping;
	}

	@Bean
	public ResourceHttpRequestHandler faviconRequestHandler() {
		ResourceHttpRequestHandler requestHandler = new ResourceHttpRequestHandler();
		requestHandler
				.setLocations(this.resourceProperties.getFaviconLocations());
		return requestHandler;
	}
}
```

- 所有 /webjars/** ，都去 classpath:/META-INF/resources/webjars/ 找资源
  + webjars：以jar包的方式引入静态资源。http://www.webjars.org/
  + ![webjar包结构](images/webjar包结构.png)
  + localhost:8080/webjars/jquery/3.3.1/jquery.js
  + ```xml
    <!--引入jquery-webjar-->在访问的时候只需要写webjars下面资源的名称即可
    		<dependency>
    			<groupId>org.webjars</groupId>
    			<artifactId>jquery</artifactId>
    			<version>3.3.1</version>
    		</dependency>
    ```
- "/**" 访问当前项目的任何资源，都去（静态资源的文件夹）找映射
  + 默认静态资源文件夹
    ```
    "classpath:/META-INF/resources/",
    "classpath:/resources/",
    "classpath:/static/",
    "classpath:/public/"
    "/"：当前项目的根路径
    ```
- 欢迎页。所有静态资源文件夹下的index.html页面。被"/**"映射
	 + localhost:8080/   找index页面
- 网站图标。所有静态资源文件夹下的favicon.ico（**/favicon.ico）

## 模板引擎

SpringBoot推荐的Thymeleaf。语法更简单，功能更强大。

### 引入thymeleaf

springboot1.5中，thymeleaf默认版本是2，这个版本有点低，如果要使用3，则需要修改pom文件

```xml
<properties>
  <!--切换thymeleaf版本-->
	<thymeleaf.version>3.0.9.RELEASE</thymeleaf.version>
	<!-- 布局功能的支持程序  thymeleaf3主程序  layout2以上版本 -->
	<!-- thymeleaf2 layout1-->
	<thymeleaf-layout-dialect.version>2.2.2</thymeleaf-layout-dialect.version>
  </properties>
```

### Thymeleaf使用

```java
@ConfigurationProperties(prefix = "spring.thymeleaf")
public class ThymeleafProperties {

	private static final Charset DEFAULT_ENCODING = Charset.forName("UTF-8");

	private static final MimeType DEFAULT_CONTENT_TYPE = MimeType.valueOf("text/html");

	public static final String DEFAULT_PREFIX = "classpath:/templates/";

	public static final String DEFAULT_SUFFIX = ".html";
}
```

以上是thymeleaf的默认配置，只要把HTML页面放在classpath:/templates/，thymeleaf就能自动渲染

使用：

- 导入thymeleaf的名称空间

  ```xml
  <html lang="en" xmlns:th="http://www.thymeleaf.org">
  ```

- 使用thymeleaf语法；

  ```html
  <!DOCTYPE html>
  <html lang="en" xmlns:th="http://www.thymeleaf.org">
  <head>
      <meta charset="UTF-8">
      <title>Title</title>
  </head>
  <body>
      <h1>成功！</h1>
      <!--th:text 将div里面的文本内容设置为属性中的值 -->
      <div th:text="${hello}">这是显示欢迎信息</div>
  </body>
  </html>
  ```

- 开发的时候需要禁用缓存

  ```
  # 禁用缓存
  spring.thymeleaf.cache=false
  ```

### 语法规则

#### th：可以替换任意html属性值

![th属性](images/th属性.png)

#### 表达式

[用法](https://www.thymeleaf.org/doc/tutorials/3.0/usingthymeleaf.html#messages)

## SpringMVC自动配置

### Spring MVC auto-configuration

以下是SpringBoot对SpringMVC的默认配置:**（WebMvcAutoConfiguration）**

- Inclusion of `ContentNegotiatingViewResolver` and `BeanNameViewResolver` beans.
  + 自动配置了ViewResolver（视图解析器：根据方法的返回值得到视图对象（View），视图对象决定如何渲染）
  + ContentNegotiatingViewResolver：组合所有的视图解析器
  + 如何定制：我们可以自己给容器中添加一个视图解析器，会自动将其组合进来
- Support for serving static resources, including support for WebJars (see below).静态资源文件夹路径,webjars
- Static `index.html` support. 静态首页访问
- Custom `Favicon` support.  favicon.ico
- 自动注册了 of `Converter`, `GenericConverter`, `Formatter` beans.
  + Converter：转换器。类型转换器
  + Formatter：格式化器。如日期格式化

    ```java
    @Bean
    @ConditionalOnProperty(prefix = "spring.mvc", name = "date-format")//在文件中配置日期格式化的规则
    public Formatter<Date> dateFormatter() {
    	return new DateFormatter(this.mvcProperties.getDateFormat());//日期格式化组件
    }
    ```

- Support for `HttpMessageConverters` .
  + HttpMessageConverter: SpringMVC用来转换Http请求和响应的。User--->Json
  + HttpMessageConverters: 是从容器中获取所有的HttpMessageConverter
- Automatic registration of `MessageCodesResolver`.定义错误代码生成规则
- Automatic use of a `ConfigurableWebBindingInitializer` bean
  + 我们可以配置一个ConfigurableWebBindingInitializer来替换默认的.（添加到容器）

If you want to keep Spring Boot MVC features, and you just want to add additional [MVC configuration](https://docs.spring.io/spring/docs/4.3.14.RELEASE/spring-framework-reference/htmlsingle#mvc) (interceptors, formatters, view controllers etc.) you can add your own `@Configuration` class of type `WebMvcConfigurerAdapter`, but **without** `@EnableWebMvc`. If you wish to provide custom instances of `RequestMappingHandlerMapping`, `RequestMappingHandlerAdapter` or `ExceptionHandlerExceptionResolver` you can declare a `WebMvcRegistrationsAdapter` instance providing such components.

If you want to take complete control of Spring MVC, you can add your own `@Configuration` annotated with `@EnableWebMvc`.

### 扩展SpringMVC

```java
//使用WebMvcConfigurerAdapter可以来扩展SpringMVC的功能
@Configuration
public class MyMvcConfig extends WebMvcConfigurerAdapter {
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
       // super.addViewControllers(registry);
        //浏览器发送 /hello 请求来到 success
        registry.addViewController("/hello").setViewName("success");
    }
}
```

#### 原理

1. WebMvcAutoConfiguration是SpringMVC的自动配置类
2. 在做自动配置时会导入，@Import(**EnableWebMvcConfiguration**.class)
3. EnableWebMvcConfiguration继承了DelegatingWebMvcConfiguration

  ```java
  private final WebMvcConfigurerComposite configurers = new WebMvcConfigurerComposite();
  //从容器中获取所有的WebMvcConfigurer
  @Autowired(required = false)
  public void setConfigurers(List<WebMvcConfigurer> configurers) {
      if (!CollectionUtils.isEmpty(configurers)) {
          this.configurers.addWebMvcConfigurers(configurers);
      }
  }
  ```

4. 容器中所有的WebMvcConfigurer都会一起起作用。效果：SpringMVC的自动配置和我们的扩展配置都会起作用

### 全面接管SpringMVC；

SpringBoot对SpringMVC的自动配置不再生效，全部手工配置

**需要在配置类中添加@EnableWebMvc**

```java
//使用WebMvcConfigurerAdapter可以来扩展SpringMVC的功能
@EnableWebMvc
@Configuration
public class MyMvcConfig extends WebMvcConfigurerAdapter {
}
```

#### 原理

为什么添加了@EnableWebMvc，自动配置就失效了

1. @EnableWebMvc将DelegatingWebMvcConfiguration组件导入进来
2. DelegatingWebMvcConfiguration继承与WebMvcConfigurationSupport
3. WebMvcAutoConfiguration的类声明中有@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)，因此WebMvcAutoConfiguration中的配置就不会被执行

```java
@Import(DelegatingWebMvcConfiguration.class)
public @interface EnableWebMvc {
}

@Configuration
public class DelegatingWebMvcConfiguration extends WebMvcConfigurationSupport {
}

@Configuration
@ConditionalOnWebApplication
@ConditionalOnClass({ Servlet.class, DispatcherServlet.class,
		WebMvcConfigurerAdapter.class })
//容器中没有这个组件的时候，这个自动配置类才生效
@ConditionalOnMissingBean(WebMvcConfigurationSupport.class)
@AutoConfigureOrder(Ordered.HIGHEST_PRECEDENCE + 10)
@AutoConfigureAfter({ DispatcherServletAutoConfiguration.class,
		ValidationAutoConfiguration.class })
public class WebMvcAutoConfiguration {
}
```

## 如何修改SpringBoot的默认配置

模式：

1. SpringBoot在自动配置组件的时候，先看容器中有没有用户自己配置的（@Bean、@Component）如果有就用用户配置的，如果没有，才自动配置；如果有些组件可以有多个（ViewResolver）将用户配置的和自己默认的组合起来
2. 在SpringBoot中会有非常多的xxxConfigurer帮助我们进行扩展配置
3. 在SpringBoot中会有很多的xxxCustomizer帮助我们进行定制配置

## 国际化

步骤：

1. 编写国际化配置文件，抽取页面需要显示的国际化消息

  ![国际化配置文件](images/国际化配置文件.png)

2. SpringBoot自动配置好了国际化资源文件的管理组件

  ```java
  @ConfigurationProperties(prefix = "spring.messages")
  public class MessageSourceAutoConfiguration {
    /**
     * Comma-separated list of basenames (essentially a fully-qualified classpath
     * location), each following the ResourceBundle convention with relaxed support for
     * slash based locations. If it doesn't contain a package qualifier (such as
     * "org.mypackage"), it will be resolved from the classpath root.
     */
     private String basename = "messages";
     //我们的配置文件可以直接放在类路径下叫messages.properties

    @Bean
    public MessageSource messageSource() {
	   ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
     if (StringUtils.hasText(this.basename)) {
       //设置国际化资源文件的基础名（去掉语言国家代码的）
       messageSource.setBasenames(StringUtils.commaDelimitedListToStringArray(StringUtils.trimAllWhitespace(this.basename)));
     }
     if (this.encoding != null) {
       messageSource.setDefaultEncoding(this.encoding.name());
     }
     messageSource.setFallbackToSystemLocale(this.fallbackToSystemLocale;
     messageSource.setCacheSeconds(this.cacheSeconds);
     messageSource.setAlwaysUseMessageFormat(this.alwaysUseMessageFormat;
     return messageSource;
   }
  ```

3. 去页面获取国际化的值
  1. 需要先将国际化资源文件编码自动转成ascii编码（配置idea）
  2. 在界面获取国际化文本值

    ```html
    <h1 class="h3 mb-3 font-weight-normal" th:text="#{login.tip}">Please sign in</h1>
    ```

    效果：根据浏览器语言设置的信息切换了国际化

### 原理

- Locale（区域信息对象）
- LocaleResolver（获取区域信息分析对象）

```java
@Bean
@ConditionalOnMissingBean
@ConditionalOnProperty(prefix = "spring.mvc", name = "locale")
public LocaleResolver localeResolver() {
	if (this.mvcProperties
			.getLocaleResolver() == WebMvcProperties.LocaleResolver.FIXED) {
		return new FixedLocaleResolver(this.mvcProperties.getLocale());
	}
  //默认的就是根据请求头带来的区域信息获取Locale进行国际化
	AcceptHeaderLocaleResolver localeResolver = new AcceptHeaderLocaleResolver();
	localeResolver.setDefaultLocale(this.mvcProperties.getLocale());
	return localeResolver;
}
```

### 点击链接切换国际化

```java
/**
 * 可以在连接上携带区域信息
 */
public class MyLocaleResolver implements LocaleResolver {
  @Override
  public Locale resolveLocale(HttpServletRequest request) {
    String l = request.getParameter("l");
    Locale locale = Locale.getDefault();
    if(!StringUtils.isEmpty(l)){
      String[] split = l.split("_");
      locale = new Locale(split[0],split[1]);
    }
    return locale;
  }
  @Override
  public void setLocale(HttpServletRequest request, HttpServletResponse response, Locale locale) {
  }
}

@Bean
public LocaleResolver localeResolver(){
  return new MyLocaleResolver();
}
```

### thymeleaf公共页面元素抽取

1. 抽取公共片段

  ```html
  <div th:fragment="copy">
    &copy; 2011 The Good Thymes Virtual Grocery
  </div>
  ```

2. 引入公共片段
  1. ~{templatename::selector}：模板名::选择器
  2. ~{templatename::fragmentname}:模板名::片段名
  ```html
  <div th:insert="~{footer :: copy}"></div>
  ```
  3. 如果使用th:insert等属性进行引入，可以不用写~{}
  4. 行内写法可以加上：[[~{}]];[(~{})]

#### 三种引入公共片段的th属性

- **th:insert**：将公共片段整个插入到声明引入的元素中
- **th:replace**：将声明引入的元素替换为公共片段
- **th:include**：将被引入的片段的内容包含进这个标签中

```html
<footer th:fragment="copy">
  &copy; 2011 The Good Thymes Virtual Grocery
</footer>

<!--引入方式-->
<div th:insert="footer :: copy"></div>
<div th:replace="footer :: copy"></div>
<div th:include="footer :: copy"></div>

<!--效果-->
<div>
  <footer>
    &copy; 2011 The Good Thymes Virtual Grocery
  </footer>
</div>

<footer>
  &copy; 2011 The Good Thymes Virtual Grocery
</footer>

<div>
  &copy; 2011 The Good Thymes Virtual Grocery
</div>
```

引入片段的时候传入参数

```html
<nav class="col-md-2 d-none d-md-block bg-light sidebar" id="sidebar">
  <div class="sidebar-sticky">
    <ul class="nav flex-column">
      <li class="nav-item">
        <a class="nav-link active" th:class="${activeUri=='main.html'?'nav-link active':'nav-link'}" href="#" th:href="@{/main.html}"</a>
      </li>
    </ul>
  </div>
</nav>

<!--引入侧边栏;传入参数-->
<div th:replace="commons/bar::#sidebar(activeUri='emps')"></div>
```

### 隐藏请求方法

```html
<!--需要区分是员工修改还是添加-->
<form th:action="@{/emp}" method="post">
    <!--发送put请求修改员工数据-->
    <!--
    1、SpringMVC中配置HiddenHttpMethodFilter;（SpringBoot自动配置好的）
    2、页面创建一个post表单
    3、创建一个input项，name="_method";值就是我们指定的请求方式
    -->
    <input type="hidden" name="_method" value="put" th:if="${emp!=null}"/>
</form>
```

## 注册拦截器

```java
/**
 * 登陆检查拦截器
 */
public class LoginHandlerInterceptor implements HandlerInterceptor {
  //目标方法执行之前
  @Override
  public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
    Object user = request.getSession().getAttribute("loginUser");
    if(user == null){
      //未登陆，返回登陆页面
      request.setAttribute("msg","没有权限请先登陆");
      request.getRequestDispatcher("/index.html").forward(request,response);
      return false;
    }else{
      //已登陆，放行请求
      return true;
    }
  }
}

//所有的WebMvcConfigurerAdapter组件都会一起起作用
@Bean //将组件注册在容器
public WebMvcConfigurerAdapter webMvcConfigurerAdapter(){
  WebMvcConfigurerAdapter adapter = new WebMvcConfigurerAdapter() {
    //注册拦截器
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
      //不需要排除静态资源（*.css , *.js）。SpringBoot已经做好了静态资源映射
      registry.addInterceptor(new LoginHandlerInterceptor()).addPathPatterns("/**")
              .excludePathPatterns("/index.html","/","/user/login");
    }
  };
  return adapter;
}
```

# 后台数据校验

使用hibernate-validator工具包进行校验（spring-boot-starter-web中已包含）

```xml
<dependency>
	<groupId>org.hibernate</groupId>
	<artifactId>hibernate-validator</artifactId>
</dependency>
```

通过注解定义验证规则
```java
@Data
public class StandardDto {

    private Integer standardId;

    @NotBlank(message = "{standard.name.notBlank}")
    private String standardName;

    private Integer orderId;

    private Date operateTime;
}
```

controller中标记为验证
```java
@PostMapping("/standard")
public ResponseEntity saveStandard(@Validated StandardDto standard) {
}
```

## 验证提示信息

默认情况下，可以在resources目录下创建国际化文件，来定义错误提示信息，文件名默认为：ValidationMessages.properties、ValidationMessages_zh_CN.properties 等

```properties
standard.name.notBlank=规格名称不能为空
```

也可以自定义路径：
```java
@Configuration
public class ValidatorConfiguration {

    public ResourceBundleMessageSource getMessageSource() {
        ResourceBundleMessageSource rbms = new ResourceBundleMessageSource();
        rbms.setDefaultEncoding("UTF-8");//文件编码方式
        //修改验证信息配置文件路径。默认是resources/ValidationMessages[_zh_CN].properties
        rbms.setBasenames("i18n/validator/message");
        return rbms;
    }

    @Bean
    public Validator getValidator() throws Exception {
        LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
        validator.setValidationMessageSource(getMessageSource());
        return validator;
    }
}
```

对于错误信息，可以进行统一处理，如：
```java
@ControllerAdvice
public class MyExceptionHandler {

    @ExceptionHandler(BindException.class)
    public ResponseEntity handleException(BindException e) {
        List<ObjectError> errors =  e.getAllErrors();
        Map<String, Object> map = new HashMap<>(1);
        List<String> msg = new ArrayList<>(errors.size());
        map.put("errorMsg", msg);

        errors.stream().forEach(x -> msg.add(x.getDefaultMessage()));

        return new ResponseEntity(map, HttpStatus.BAD_REQUEST);
    }
}
```
