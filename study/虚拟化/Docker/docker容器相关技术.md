# Namespaces命名空间

操作系统中，命名空间主要作用是系统资源隔离。包括进程、网络、文件系统等

docker中使用了5种命名空间：

- PID（Process ID） 进程隔离
- NET（Network） 管理网络接口
- IPC（InterProcess Communication） 管理跨进程通信访问
- MNT(Mount) 管理挂载点
- UTS（Unix Timesharing System） 隔离内核和版本标识

# cgroups（Control Groups）控制组

- 对进程组进行资源限制
- 优先级设定
- 资源计量
- 资源控制

# docker容器的能力

- 文件系统隔离：每个容器都有自己的root文件系统
- 进程隔离：每个容器都运行在自己的进程环境中
- 网络隔离：容器间的虚拟网络接口和IP地址都是分开的
- 资源隔离和分组：使用cgroups将CPU和内存之类的资源独立分配给每个docker容器
