- k8s物理架构为：master/node
  + 为了保证可用性，一般设置3个master
  + master: API Server, Scheduler, Controller-Manager
  + node: kubelet, docker, kube-proxy
- 逻辑架构：Pod, Label, Label Selector

# 资源清单

- 资源：对象
  - workload： Pod, ReplicaSet,  Deployment, StatefulSet, DaemonSet, Job, Cronjob,...
  - 服务发现及均衡：Service, Ingress,...
  - 配置与存储：Volume, CSI
    - ConfigMap, Secret
    - DownwardAPI
  - 集群级资源
    - Namespace, Node, Role, ClusterRole, RoleBinding, ClusterRoleBinding
  - 元数据型资源
    - HPA, PodTemplate, LimitRange
- 清单文件元素
  - apiVersion： group/version
    - 可以通过`kubectl api-versions`查看有哪些apiVersion
  - kind：资源类别
  - metadata： 元数据
    - name
    - namespace
    - labels
    - annotations
    - 每个资源的引用PATH
      - /api/GROUP/VERSION/namespaces/NAMESPACE/TYPE/NAME
  - spec: 期望的状态， disired state
  - status: 当前状态，current state，本字段有kubernetes集群维护

- 清单文件demo，pod-demo.yaml

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
  	name: pod-demo
  	namespace: default
  	labels:
  		app: myapp
  		tier: frontend
  spec:
  	containers:
  		- name: myapp
  		  image: ikubernates/myapp:v1
  		- name: busybox
  		  image: busybox:latest
  		  command:
  		  	- "/bin/sh"
  		  	- "-c"
  		  	- "sleep 5"
  ```


# 创建资源的方式

- apiserver仅接收JSON格式的资源定义
- 使用yaml格式文件定义资源后，apiserver可自动将其转为JSON格式，然后提交并执行

# Pod资源

## 配置清单（自主式Pod资源）

- 一级字段：apiVersion(group/version), kind, metadata(name, namespace, labels, annotations, ...), spec, status(只读)

- sepc.containers <[]object>

  - name 定义容器名

  - image 镜像名

  - imagePullPolicy 镜像拉取方式

    - 取值：Always, Never, IfNotPresent

  - commod与args

    - commod是启动容器要执行的命令，与dockerfile的Entrypoint相同。如果定义了commod，则dockerfile中的Entrypoint和cmd都不生效。
    - args是commod命令的参数。如果定义了args，则dockerfile中的cmd不生效。

  - labels(key=value, ....)

    - key: 字母、数字、_、-、.
    - value: 可以为空，只能字母或数字开头及结尾。

  - livenessProbe/readinessProbe 存活/就绪探针

    ```yaml
    livenessProbe:
    	exec:
    		command: ["test", "-e", "/tmp/healthy"]
        initialDelaySeconds: 1 #容器启动后延迟1秒执行
        periodSeconds: 3 #每次检查间隔时间
    ```

- nodeSelector <map[string]string>：通过标签选择器定义所需要使用的节点

- nodeName <string>：定义所需要使用的node节点

- annotations:

  - 与label不同，它不能用于挑选资源对象，仅用于为对象提供“元数据”。

- restartPolicy: 定义重启策略

  - Always, OnFailure, Never

## Pod生命周期

- 状态：
  - Pending
  - Running
  - Failed
  - Succeeded
  - UnKnown
- 生命周期行为
  - 初始化容器
  - 容器启动后钩子、停止前钩子
  - 容器探测
    - liveness： 监测是否存活
    - readiness：监测是否就绪，存活不代表就绪，就绪才能正常提供服务
    - 支持三种探针：ExecAction, TCPSocketAction, HTTPGetAction

# ReplicaSet

- 用来控制集群中满足相同标签表达式的Pot的副本个数，多了会自动删除，少了会自动加。
- 其清单文件包含了Pot的配置。

# Deployment

- 用于管理不同版本的ReplicaSet，已达到版本之间滚动切换的效果。

- 其清单文件包含了ReplicaSet的配置。
- demo:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata: 
	name: myapp-deploy
	namespace: default
spec:
	replicas: 3
	selector:
		matchLabels:
			app: myapp
			release: canary
	template:
		metadata:
			labels:
				app: myapp
				release: canary
		spec:
			containers:
				- name: myapp
				  image: ikubernetes/myapp:v2
				  ports:
				  	- name: http
				  	  containerPort: 80
```

# DaemonSet

会往没个节点创建一个pod

# Service

- 工作模式：
  - userspace：1.1-
  - iptables：1.10-
  - ipvs：1.11+
- 类型：
  - ExternalName：将外部网络映射到集群中，即通过该service可以访问外部主机
  - ClusterIP
  -  NodePort
    - Client -> NodeIP:NodePort -> ClusterIP:ServicePort -> PodIP:containerPort
  -  LoadBalancer: 用于云平台
- service资源名称：SVC_NAME.NS_NAME.DEMAIN.LTD.
  - 默认的域名：svc.cluster.local.
- No ClusterIP:Headless Serivce
  - 无头Service，即没有集群IP的Service，会直接指向pod：ServiecName -> PodIP

```yml
apiVersion: v1
kind: Service
metadata:
	name: myapp
	namespace: default
spec:
	selector:
		app: myapp
		release: canary
	clusterIP: 10.99.99.99
	type: NodePort
	ports:
		- port: 80 # service端口
		  targetPort: 80 # 容器端口
		  nodePort: 30080 # node节点端口
```

# IngressController

![image-20181029164429547](/Users/ldp/study/mynote/study/虚拟化/Kubernetes/images/ingress对外暴露网络.png)

- 使用Nginx作为IngressController，可以通过其github项目中的`/deploy/mandatory.yaml`文件来构建。

- 需要定义一个NodePort类型的service，对外暴露端口

  ```yaml
  apiVersion: v1
  kind: Service
  metadata:
  	name: ingress-nginx
  	namespace: ingress-nginx
  spec:
  	type: NodePort
  	ports:
  		- name: http
  		  port: 80 # service暴露的端口
  		  targetPort: 80 # 指向pod暴露的端口
  		  protocol: TCP
  		  nodePort: 30080
  		- name: https
  		  port: 443
  		  targetPort: 443
  		  portocol: TCP
  		  nodePort: 30443
  	selector:
  		app: ingress-nginx
  ```

- 通过定义Ingress来制定转发规则，这里指的是nginx的代理规则

  ```yaml
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
  	name: ingress-myapp
  	namespace: default
  	annotations:
  		# 指定使用的是什么作为 ingress controller
  		kubernetes.io/ingress.class: "nginx"
  spec:
  	rules:
  		# 相当于nginx的虚拟主机(server)
  		- host: myapp.magedu.com
  		  http:
  		  	paths:
  		  		- path: # 默认是 /
  		  		  # 指定后端映射到哪个service和端口
  		  		  backend:
  		  		  	serviceName: myapp
  		  		  	servicePort: 80
  ```

## 构建内部https

- 创建密钥

  - `openssl genrsa -out tls.key 2048`： 会在当前目录生成tls.key文件
  - `openssl req -new -x509 -key tls.key -out tls.crt -subj /C=CN/ST=Beijing/O=DevOps/CN=tomcat.magedu.com`：最后的域名需要与实际访问进来的域名一致

- 网k8s集群创建secret

  - `kubectl create secret tls tomcat-ingress-secret --cert=tls.crt --key=tls.key`

  - 创建带证书认证的ingress：

    ```yaml
    apiVersion: extensions/v1beta1
    kind: Ingress
    metadata:
    	name: ingress-tomcat-tls
    	namespace: default
    	annotations:
    		kubernetes.io/ingress.class: "nginx"
    spec:
    	tls:
    		- hosts:
    			- tomcat.magedu.com
    		secretName: tomcat-ingress-secret
    	rules:
    		- host: tomcat.magedu.com
    		  http:
    		  	paths:
    		  		- path: 
    		  		  backend:
    		  		  	serviceName: tomcat
    		  		  	servicePort: 8080
    ```

# 存储卷

- 本地类型：emptyDir, hostPath

- 网络存储：
  - SAN:iSCSI,...
  - NAS:nfs, cifs
- 分布式存储：glusterfs, ceph, cephfs
- 云存储： EBS, Azure Disk

## emptyDir

- emptyDir是挂载pod的存储卷，当pod删除时，数据也会一并删除
- 同一pod内的多个容器可以共享此存储卷

```yaml
apiVersion: v1
kind: Pod
metadata: 
	name: pod-demo
	namespace: default
	labels:
		app: myapp
		tier: frontend
	annotations:
		mageedu.com/created-by: "cluster admin"
spec:
	containers:
		- name: myapp
		  image: ikubernetes/myapp:v1
		  ports:
		  	- name: http
		  	  containerPort: 80
		  volumeMounts:
		  	- name: html
		  	  mountPath: /data/web/html/
		- name: busybox
		  image: busybox:latest
		  imagePullPolicy: IfNotPresent
		  volumeMounts
		  	- name: html
		  	  mountPath: /data/
		  command: ["/bin/sh", "-c", "sleep 3600"]
	volumes:
		- name: html
		  emptyDir: {}
```

## hostPath

- 使用主机目录作为存储卷，只要在同一主机中重建pod，数据可以恢复

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
  	name: pod-vol-hostpath
  	namespace: default
  spec:
  	containers:
  		- name: myapp
  		  image: ikubernetes/myapp:v1
  		  volumeMounts:
  		  	- name: html
  		  	  mountPath: /usr/share/nginx/html/
  	volumes:
  		- name: html
  		  hostPath:
  		  	path: /data/pod/volume1
  		  	type: DirectoryOrCreate
  ```


# nfs

## 搭建nfs

1. 安装nfs-utils：`yum -y install nfs-utils`

2. 创建要对外发布的目录：`mkdir -pv /data/volumes`

3. 配置暴露目录：

   ```shell
   vim /etc/exports
   
   /data/volumes	127.10.0.0/16(rw, no_root_squash)
   ```

4. 启动nfs：`systemctl start nfs`

## 使用nfs作为存储卷

1. 先确保各node节点中有 nfs-utils ，并且能正常挂载。可用命令验证：`mount -t nfs stor01:/data/volumes /mnt`，验证完后可以使用unmount命令解绑

2. 配置存储卷

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata: 
   	name: pod-vol-nfs
   	namespace: default
   spec:
   	containers:
   		- name: myapp
   		  image: ikubernetes/myapp:v1
   		  volumeMounts:
   		  	- name: html
   		  	  mountPath: /usr/share/nginx/html/
   	volumes:
   		- name: html
   		  nfs: 
   		  	path: /data/volumes
   		  	server: stor01.mageedu.com
   ```

# PV和PVC

- PV是用于定义存储资源的
- PVC是pod构建的时候定义存储要求，自动根据要求选择合适的PV进行挂载

![image-20181030102417990](/Users/ldp/study/mynote/study/虚拟化/Kubernetes/images/PV和PVC.png)



![image-20181030102518592](/Users/ldp/study/mynote/study/虚拟化/Kubernetes/images/PV和PVC1.png)

1. nfs服务器中暴露多个目录

   ```shell
   /data/volumes/v1	127.10.0.0/16(rw, no_root_squash)
   /data/volumes/v2	127.10.0.0/16(rw, no_root_squash)
   /data/volumes/v3	127.10.0.0/16(rw, no_root_squash)
   /data/volumes/v4	127.10.0.0/16(rw, no_root_squash)
   /data/volumes/v5	127.10.0.0/16(rw, no_root_squash)
   ```

2. 在集群中创建PV

   ```yaml
   apiVersion: v1
   kind: PersistentVolume
   metadata: 
   	name: pv001
   	labels:
   		name: pv001
   spec:
   	nfs:
   		path: /data/volumes/v1
   		server: stor01.mageedu.com
       accessModes: ["ReadWriteMany", "ReadWriteOnce"]
       capacity:
       	storage: 2Gi
   ---
   apiVersion: v1
   kind: PersistentVolume
   metadata: 
   	name: pv002
   	labels:
   		name: pv002
   spec:
   	nfs:
   		path: /data/volumes/v2
   		server: stor01.mageedu.com
   ---
   ......
   ```

3. 使用PVC

   ```yaml
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
   	name: mypvc
   	namespace: default
   spec:
   	accessModes: ["ReadWriteMany"]
   	resources:
   		requests:
   			storage: 6Gi
   ---
   apiVersion: v1
   kind: Pod
   metadata:
   	name: pod-vol-pvc
   	namespace: default
   spec:
   	containers:
   		- name: myapp
   		  image: ikubernetes/myapp:v1
   		  volumeMounts:
   		  	- name: html
   		  	  mountPath: /usr/share/nginx/html/
   	volumes:
   		- name: html
   		  persistentVolumeClaim:
   		  	claimName: mypvc
   ```

# configmap和secret

- 是挂载卷的一种，用于存储配置信息，其中sercret是加密存储（Base64）

## configmap

### 命令行写值

1. `kubectl create configmap nginx-config --from-literal=nginx_port=80 --from-literal=server_name=myapp.magedu.com`

2. 在pod中引用

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
   	name: pod-cm-1
   	namespace: default
   	labels:
   		app: myapp
   		tier: frontend
   	annotations:
   		magedu.com/create-by: "cluster admin"
   spec:
   	containers:
   		- name: myapp
   		  image: ikubernetes/myapp:v1
   		  ports:
   		  	- name: http
   		  	  containerPort: 80
   		  env:
   		  	# 变量名不要使用-，docker会自动变成_
   		  	- name: NGINX_SERVER_PORT
   		  	  valueFrom:
   		  	  	configMapKeyRef:
   		  	  		name: nginx-config
   		  	  		key: nginx_port
   		  	- name: NGINX_SERVER_NAME
   		  	  valueFrom:
   		  	  	configMapKeyRef:
   		  	  		name: nginx-config
   		  	  		key: server_name
   ```


### 文件写入

1. 创建文件`www.conf`

   ```json
   server {
       server_name myapp.magedu.com;
       listen 80;
       root /data/web/html/;
   }
   ```

2. `kubectl create configmap nginx-www --from-file=./www.conf`

3. 在pod中引用

   ```yaml
   apiVersion: v1
   kind: Pod
   metadata:
   	name: pod-cm-1
   	namespace: default
   	labels:
   		app: myapp
   		tier: frontend
   	annotations:
   		magedu.com/create-by: "cluster admin"
   spec:
   	containers:
   		- name: myapp
   		  image: ikubernetes/myapp:v1
   		  ports:
   		  	- name: http
   		  	  containerPort: 80
   		  volumeMounts:
   		  	- name: nginxconf
   		  	  mountPath: /etc/nginx/conf.d/
   		  	  readOnly: true # 指定容器不能修改此文件
   	volumes:
   		- name: nginxconf
   		  configMap:
   		  	name: nginx-www
   ```


## secret

- 分类：

  - docker-registry：存储docker仓库密码
  - tls：存储证书
  - generic： 除以上两种外都用这种

- `kubectl create secret generic mysql-root-password --from-literal=password=MyP@ss123`

  - 使用命令`kubectl get secret mysql-root-password -o yalm`可查看到password的值为`TXlQQHNzMTIz`
  - 使用命令`echo TXlQQHNzMTIz | base64 -d` 可输出源密码 

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
  	name: pod-secret-1
  	namespace: default
  	labels:
  		app: myapp
  		tier: frontend
  	annotations:
  		magedu.com/create-by: "cluster admin"
  spec:
  	containers:
  		- name: myapp
  		  image: ikubernetes/myapp:v1
  		  ports:
  		  	- name: http
  		  	  containerPort: 80
  		  env:
  		  	- name: MYSQL_ROOT_PASSWORD
  		  	  valueFrom:
  		  	  	secretKeyRef:
  		  	  		name: mysql-root-passwrod
  		  	  		key: password
  ```

# StatefulSet

- 有状态的资源控制器
- 一般与数据存储有关的都是有状态的资源，如mysql、redis等
- 特点：
  1. 稳定且唯一的网络标识符
  2. 稳定且持久的存储
  3. 有序、平滑地部署和扩展
  4. 有序、平滑地删除和终止
  5. 有序的滚动更新
- 定义时需要三个组件：headless service、StatefulSet、volumeClaimTemplate
- pod对应的集群地址：pod_name.service_name.ns_name.svc.cluster.local

```yaml
apiVersion: v1
kind: Service
metadata:
	name: myapp-svc
	labels:
		app: myapp-svc
spec:
	ports:
		- port: 80
		  name: web
	clusterIp: None # headless service
	selector:
		app: myapp-pod
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
	name: myapp
spec:
	serviceName: myapp-svc
	replicas: 2
	selector:
		matchLabels:
			app: myapp-pod
	template:
		metadata:
			labels:
				app: myapp-pod
		spec:
			containers:
				- name: myapp
				  image: ikubernetes/myapp:v5
				  ports:
				  	- containerPort: 80
				  	  name: web
				  volumeMounts:
				  	- name: myappdata
				  	  mountPath: /usr/share/nginx/html
	volumeClaimTemplates:
		- metadata:
			name: myappdata
		  spec:
		  	accessModes: ["ReadWriteOnce"]
		  	resources:
		  		requests:
		  			storage: 2Gi
```

# 认证授权

apiServer支持远程访问，也支持通过http来访问。通过http需要使用证书认证，这时可以将按照k8s是生成的配置文件拷贝到本地，然后在本地创建proxy（`kubectl proxy --port=8080`），本地访问proxy所监听的端口，proxy反向代理到apiserver中。

api路径：

​	http://localhost:8080/api/v1/namespaces：返回namespace列表信息

​	http://localhost:8080/apis/apps/v1/namespaces/kube-system/deployments：返回kube-system这个命名空间下的deploy列表

## serviceaccount

- 用户账号资源，这里的账号紧用于登录，并没有任何权限，还需要经过其他途径来赋权。

- 创建pod资源时，k8s会给pod指定默认的账号信息，此账号只能访问pod自身的信息。如果需要更多的权限，需要给pod指定其他账号，再给该账号赋权。

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
  	name: pod-sa-demo
  	namespace: default
  	labels: 
  		app: myapp
  		tier: frontend
  	annotations:
  		magedu.com/created-by: "cluster admin"
  spec:
  	containers:
  		- name: myapp
  		  image: ikubernetes/myapp:v1
  		  ports:
  		  	- name: http
  		  	  containerPort: 80
  	serviceAccountName: admin
  ```

## 给kubectl添加用户

- 通过kubectl访问apiserver是需要认证的，我们需要通过openssl创建证书
  - 进入`/etc/kubernetes/kpi`目录，里面存放着k8s所用到的认证信息
  - `(umask 077; openssl genrsa -out magedu.key 2048)`：生成magedu.key文件
  - `openssl req -new -key magedu.key -out magedu.csr -subj "/CN=magedu"`：根据magedu.key创建magedu.csr文件
  - `openssl x509 -req -in magedu.csr -CA ./ca.crt -CAKey ./ca.key -CAcreateserial -out magedu.crt -days 365`：创建一个一年有效期的证书
  - `openssl x509 -in magedu.crt -text -noout`：可输出证书信息
- 创建账号并指定证书
  - `kubectl config view`：可以查看kubectl的配置信息，包括可链接的集群、可用的账号及账号和集群关联信息
  - `kubectl config set-credentials magedu --client-certificate=./magedu.crt --client-key=./magedu.key --embed-certs=true`：创建magedu账号
  - `kubectl config set-context magedu@kubernetes --cluster=kubernetes --user=magedu`：将集群与用户关联起来
  - `kubectl config use-context magedu@kubernetes`：将当前用户切换为magedu
  - `kubectl config set-cluster mycluster --kubeconfig=/tmp/test.conf --server="https://127.20.0.70:6443" --certificate-authority=/etc/kubernetes/pki/ca.crt --embed-certs=true`：可以添加集群

## RBAC

- role：当前命名空间角色
  - 创建：`kubectl create role pods-reader --verb=get,list,watch --resource=pods`
- rolebinding：将用于与角色绑定，可以绑定clusterrole，绑定clusterrole后，只拥有当前命名空间下与clusterrole相同的权限
  - 创建：`kubectl create rolebinding magedu-read-pods --role=pods-reader --user=magedu`
  - `kubectl create rolebinding default-ns-admin --clusterrole=admin --user=magedu`
- clusterrole：集群基本的角色，作用于所有命名空间
  - 创建：`kubectl create clusterrole cluster-reader --verb=get,list,watch --resource=pods`
- clusterrolebinding：绑定clusterrole与用户
  - 创建：`kubectl create clusterrolebinding magedu-read-all-pods --clusterrole=cluster-reader --user=magedu`
- `kubectl get clusterrole admin -o yaml`： 查看admin用的权限定义

# Dashboard

1. 部署：`kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml`
2. 将Service改成NodePort
   - `kubectl patch svc kubernetes-dashboard -p '{"spec":{"type":"NodePort"}}' -n kube-system`
3. 认证：
   - 认证时的账号必须是ServiceAccount，因为被dashboard pod拿来有kubernetes进行认证
   - token：
     1. 创建ServiceAccount，根据其管理目标，使用rolebinding或clusterrolebinding绑定只合理的role或clusterrole
        - `kubectl create serviceaccount dashboard-admin -n kube-system`
        - `kubectl create clusterrolebinding dashboard-cluster-admin --clusterrole=cluster-admin --serviceaccount=kube-system:dashboard-admin`
        - `kubectl create serviceaccount def-ns-admin -n default`
        - `kubectl create rolebinding def-ns-admin --clusterrole=admin --serviceaccount=default:def-ns-admin`
     2. 查询自动生成的ServiceAccount的secret信息，里面就有token
        - `kubectl describe secret dashboard-admin-token-xkck5 -n kube-system`
   - kubeconfig：
     1. 创建ServiceAccount，根据其管理目标，使用rolebinding或clusterrolebinding绑定只合理的role或clusterrole
     2. 查询自动生成的ServiceAccount的secret信息，使用命令保存token变量：`KUBE_TOKEN=$(kubectl get secret SERVICEACCOUNT_SECRET_NAME -o jsonpath={.data.token} | base64 -d)`，其中SERVICEACCOUNT_SECRET_NAME替换为secret的名字
     3. 构建kubeconfig文件，并将文件拷贝到要登录dashboard的机器中使用
        1. 添加集群：`kubectl config set-cluster kubernetes --certificate=./ca.crt --server="https://127.20.0.70:6443" --embed-crets=true --kubeconfig=/root/def-ns-admin.conf`
        2. 添加账号：`kubectl config set-credentials def-ns-admin --token=$KUBE_TOKEN --kubeconfig=/root/def-ns-admin.conf`
        3. 账号与集群关联：`kubectl config set-context def-ns-admin@kubernetes --cluster=kubernetes --user=def-ns-admin --kubeconfig=/root/def-ns-admin.conf`
        4. 设置当前使用账号：`kubectl config use-context def-ns-admin@kubernetes --kubeconfig=/root/def-ns-admin.conf`

# 集群管理方式

- 命令式：create, run, expose, delete, edit, ...
- 命令式配置文件： create -f /PATH/TO/RESOURCE_CONFIGURATION_FILE, delete -f, replace -f
- 声明式配置文件：apply -f

# 网络

- k8s网络通信：
  - 容器间通信： 同一个Pod内的多个容器间的通信，lo
  - Pod通信： Pod IP <--> Pod IP
  - Pod与Service通信： Pod IP <--> Cluster IP
  - Service与集群外部客户端通信
- CNI框架：
  - flannel: 方便，但不能指定网络策略
  - calico： 功能强大，但是要麻烦
  - canel：结合以上两种的优势
  - 解决方案：
    - 虚拟网桥
    - 多路复用： MacVLAN
    - 硬件交换： SR-IOV
  - 配置文件一般在 `/etc/cni/net.d` 目录中，如 `cat /etc/cni/net.d/10-flannel.conflist`

## flannel

- 支持多种后端：

  - VxLAN
    - vxlan
    - Directrouting
  - host-gw：Host Gateway 只适用于同一个网段，性能高
  - UDP：性能低，不推荐

- flannel的配置参数：

  - Network：flannel使用的CIDR格式的网络地址，用于为Pod配置网络功能

    10.244.0.0/16 ->

    ​	master: 10.244.0.0/24

    ​	node01: 10.244.1.0/24

    ​	...

    ​	node255: 10.244.255.0/24

  - SubnetLen: 把Network切分子网供各节点使用时，使用多长的掩码进行切分，默认为24位

  - SubnetMin: 10.244.10.0/24

  - SubnetMax: 10.244.100.0/24

  - Backend: vxlan, host-gw, udp

    - 将配置文件下载到本地，编辑配置文件，修改net-conf.json部分：

      ```yaml
      net-conf.json: |
      	{
              "Network": "10.244.0.0/16,
              "Backend": {
                  "Type": "vxlan",
                  "Directrouting": true #默认是false
              }
      	}
      ```

      注意：需要将原来的flannel删除，再重新安装

## calico

### 安装

1. `kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/rbac.yaml`
2. `kubectl apply -f https://docs.projectcalico.org/v3.3/getting-started/kubernetes/installation/hosted/calico.yaml`

### 网络策略定义

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
	name: deny-all-ingress
spec:
	podSelector: {}
	policyTypes: 
		# 此处定义了Ingress，如果没有明确给出Ingress规则，则都会拒绝
		- Ingress
---
apiVersion: metworking.k8s.io/v1
kind: NetworkPolicy
metadata:
	name: allow-myapp-ingress
spec:
	podSelector:
		matchLabels:
			app: myapp
	ingress:
		- from:
			- ipBlock:
				# 放行这个网段
				cidr: 10.244.0.0/16
				# 排除
				except:
					- 10.244.1.2/32
			  ports:
			  	- protocol: TCP
			  	  port: 80
```

网络策略：

​	命名空间：

​		拒绝所有出站，入站；

​		放行所有出站目标为本命名空间内的所有Pod

# 调度器

Predicate（预选） --> Proiroty（优选） --> Select

## 预选策略

- CheckNodeCondition
- GeneralPredicates
  - HostName：检查Pod对象是否定义了pod.spec.hostname
  - PodFitsHostPorts：pods.spec.containers.ports.hostPort
  - MatchNodeSelector：pods.spec.nodeSelector
  - PodFitsResources：检查Pod的资源需求是否能被节点所满足
- NoDiskConflict：检查Pod依赖的存储卷是否能满足需求
- PodToleratesNodeTaints：检查Pod上的spec.tolerations可容忍的污点是否完全包含节点上的污点
- PodToleratesNodeNoExecuteTaints
- CheckNodeLabelPresence
- CheckServiceAffinity
- MaxEBSVolumeCount
- MaxGCEPDVolumeCount
- MaxAzureDiskVolumeCount
- CheckVolumeBinding
- NoVolumeZoneConflict
- CheckNodeMemoryPressure
- CheckNodePIDPressure
- CheckNodeDiskPressure
- MatchInterPodAffity

## 优选函数

- LeastRequested:
  - `(cpu((capacity-sum(requested))*10/capacity) + memory((capacity-sum(requested))*10/capa))/2`
- BalancedResourceAllocation：CPU和内存资源被占用率相近的胜出
- NodePreferAvoidPods：节点注解信息“scheduler.alpha.kubernetes.io/preferAvoidPods”
- TaintToleration： 将Pod对象的spec.tolerations列表项与节点的taints列表进行匹配度检查，匹配条目越多，得分越低
- SeletorSpreading
- InterPodAffinity
- MostRequested
- NodeLabel
- ImageLocality：根据满足当前Pod对象需求的已有镜像的体积大小之和



节点选择器：nodeSelector，nodeName

节点亲和调度：nodeAffinity

taint的effect定义对Pod排斥效果：

​	NoSchedule：仅影响调度过程，对现存的Pod对象不产生影响

​	NoExecute： 既影响调度过程，也影响现在的Pod对象，不容忍的Pod对象将被驱逐

​	PreferNoSchedule

## 容器需求，资源限制

- requests：需求，最低保障
- limits：限制，最高能用多少

- CPU：颗逻辑CPU：1=1000 millicores，500m=0.5CPU

- 内存：E（Ei）、P（Pi）、T、G、M、K

- QOS类型：

  - Guranteed：每个容器同时设置CPU和内存的requests和limits，并且两个值相等
  - Burstable：至少有一个容器设置CPU会内存资源的requests属性
  - BestEffort：没有任何一个容器设置了requests或limits属性；最低优先级

  ```yaml
  apiVersion: v1
  kind: Pod
  metadata:
  	name: pod-demo
  	labels:
  		app: myapp
  		tier: frontend
  spec:
  	containers:
  		- name: myapp
  		  image: ikubernetes/myapp:v1
  		  resources:
  		  	requests:
  		  		cpu: "500m"
  		  		memory: "256Mi"
  		  	limits:
  		  		cpu: "1"
  		  		memory: "512Mi"
  ```

# Helm

![image-20181107175541490](/Users/ldp/study/mynote/study/虚拟化/Kubernetes/images/Helm工作流程.png)

- 核心术语：
  - Chart：一个helm程序包
  - Repository：Charts仓库，https/http服务器
  - Release：特定Chart部署于目标集群上的一个实例
  - Chart -> Config -> Release
- 程序架构：
  - helm：客户端，管理本地的Chart仓库，管理Chart，与Tiller服务器交互，发送Chart，实例安装、查询、卸载等操作
  - Tiller：服务器，接收helm发来的Charts和Config，合并生成release
- helm常用命令：
  - release管理：
    - install
    - delete
    - upgrade/rollback
    - list
    - history：release的历史信息
    - status：获取release状态信息
  - chart管理：
    - create
    - fetch
    - get
    - inspect
    - package
    - verify

# 命令

- kubectl api-versions：查看apiversions取值
- kubectl exec -it pod-demo -- /bin/bash：进入pod-demo这个pod的容器执行命令，如果pod有多个容器，用-C参数指定
- 查看资源清单格式：
  - kubectl explain pods：查看pod资源清单定义说明
    - kubectl explain pods.metadata
    - kubectl explain pods.metadata.annotations
- 查看资源描述信息：
  - kubectl describe pods pod-demo：查看pod-demo这个pod的描述信息
- 创建资源：
  - kubectl create -f pod-demo.yaml: 根据文件创建资源
  - kubectl apply -f deploy-demo.yaml：根据文件创建或更新资源
  - kubectl expose deployment redis --port=6379：暴露一个service，并指定资源和端口
  - kubectl create serviceaccount mysa -o yaml --dry-run： --dry-run表示只是运行命令不创建资源，-o yaml表示输出此类资源的创建模板
- 更新资源：
  - kubectl edit rs myapp：指定资源修改资源清单定义，这里修改的是保存在内存中的对象信息。注意：不一定马上生效。
  - kubectl patch deployment myapp-deploy -p '{"spec":{"replicas": 5}}'：用打补丁的方式修改资源，-p后面跟一个与清单文件相同格式的json
  - kubectl scale sts myapp --replicas=5：将副本定义为5个，与上面命令类似
  - kubel set image deployment myapp-deploy myapp=ikubernetes:v3：修改资源中容器的镜像版本
  - kubectl rollout resume deployment myapp-deploy：将暂停中的资源恢复运行
  - kubectl rollout status deployment myapp-deploy：查看滚动更新状态 
  - kubectl rollout history deployment myapp-deploy：查看更新历史
  - kubectl rollout undo deployment myapp-deploy --to-revision=1：回退到指定版本，不写则回退到上一版本
- 删除资源：
  - kubectl delete pods pod-demo：删除pod-demo这个pod
    - kubectl delete -f pod-demo.yaml：根据文件删除
- 获取资源信息：
  - kubectl get pods：查看default命名空间的pod状态
    - kubectl get pods -w：持续监控
- 标签：
  - kubectl get pods --show-labels：额外显示标签信息
  - kubectl get pods -l app：只显示有key为app的标签的记录
  - kubectl get pods -L app,run：列出资源同时增加两列，分别显示key为app和可以为run的标签值
  - kubectl label pods pod-demo release=canary：给pod-demo这个pod打上release这个标签值
    - kubectl label pods pod-demo release=stable --overwrite：覆盖原有的release标签值
  - 标签选择器：
    - 等值关系：=，==，!=
      - 多个条件用逗号隔开，表示and
      - kubectl get pods -l release=stable,app=myapp --show-labels
    - 集合关系：
      - KEY in (VALUE1,VALUE2,...)
      - KEY notin (VALUE1,VALUE2,...)
      - KEY
      - !KEY
      - kubectl get pods -l "release in (alpha, beta, canary)" --show-labels
      - 许多资源支持内嵌套接字段定义来使用标签选择器：
        - mathLabels：直接给定键值
        - mathExpressions：基于给定的表达式来定义使用的标签，{key:"KEY", operator:"OPERATOR", values:[VAL1,VAL2,...]}
          - 操作符：
            - In, NotIn：values字段必须为非空列表
            -  Exists, NotExists：values字段必须为空列表