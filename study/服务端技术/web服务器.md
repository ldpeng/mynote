# web服务器(静态资源服务器)与web应用服务器（Javaweb服务器）区别

- web服务器不能解析动态语言，如：jsp。而web应用服务器可以
- web服务器的并发性能远高于应用服务器
- 通过web服务器访问静态资源要比使用应用服务器访问静态资源的性能高

# 为什么Java web Server不是常用的web Server

- 内存占用
  + 类型：java中的变量类型占用会比较多（如：c语言中，int类型是16位，java中统一32位）
  + 分配：java中，一旦分配了内存，知道回收前都会被占用
- 垃圾回收
  + java中的垃圾回收是被动的，不能手工触发
  + 回收会造成服务停顿
- 并发处理
  + 线程池：线程池中的线程数量是有限的，而对于静态资源请求是不需要解析的，但仍然会占用线程资源
  + 线程开销比较大，没有协程
