# 环境

- centos7
  - 192.168.1.215 master
  - 192.168.1.216 node1

## 安装前工作

- 同步各服务器时间

  - 可使用ntpdate命令：`ntpdate ntp1.aliyun.com`

- K8S官方安装文档建议每个节点在安装前都需要禁用SELINUX

  ```shell
  # 临时禁用selinux 重启后失效
  setenforce 0
  # 永久关闭 修改/etc/sysconfig/selinux文件设置 需重启
  # 注意 SELINUX 的值可能是 enforcing 或 permissive
  sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
  ```

- 关闭firewalld和iptables.service（如果各个主机启用了防火墙，需要开放Kubernetes各个组件所需要的端口，方便起见关闭掉）

  ```shell
  systemctl stop firewalld.service   #停止firewall
  systemctl disable firewalld.service #禁止firewall开机启动
  firewall-cmd --state             #查看防火墙状态
  ```

- 检查内核版本 `uname -r`，必须是3.10及以上

  - 如果版本过低则需要升级 `yum update`

# 安装docker

1. 卸载旧版本(如果安装过旧版本的话)

   ```shell
   yum remove docker \
   	docker-client \
   	docker-client-latest \
   	docker-common \
   	docker-latest \
   	docker-latest-logrotate \
   	docker-logrotate \
   	docker-selinux \
   	docker-engine-selinux \
   	docker-engine

   mv /var/lib/docker /var/lib/docker.old
   ```

2. 安装需要的软件包, yum-util提供yum-config-manager功能,另外两个是devicemapper驱动依赖的 `yum install -y yum-utils device-mapper-persistent-data lvm2`

3. 添加docker的yum源，这里用阿里云的源： `yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo`

4. 可以查看所有仓库中所有docker版本，并选择特定版本安装 `yum list docker-ce --showduplicates | sort -r`

5. 安装docker

   - 安装最新版：`yum install -y docker-ce`

   - 安装其他版本（当前 kubenetes版本为1.11.2，官方推荐使用17.03版本的docker）：

     ```shell
     yum install -y --setopt=obsoletes=0 \
       docker-ce-17.03.2.ce-1.el7.centos \
       docker-ce-selinux-17.03.2.ce-1.el7.centos
     ```

6. 启动docker `systemctl start docker`
   - 可以设置为开机启动docker `systemctl enable docker`
   - 停止docker `systemctl stop docker`

7. 配置国内镜像加速

   ```shell
   mkdir -p /etc/docker
   tee /etc/docker/daemon.json <<-'EOF'
   {
     "registry-mirrors": ["https://registry.docker-cn.com"]
   }
   EOF
   systemctl daemon-reload
   systemctl restart docker
   ```

# 安装k8s

1. 配置转发参数

   ```shell
   cat <<EOF >  /etc/sysctl.d/k8s.conf
   net.bridge.bridge-nf-call-ip6tables = 1
   net.bridge.bridge-nf-call-iptables = 1
   EOF
   sysctl --system
   ```

2. 安装kubeadm，kubelet，kubectl

   ```shell
   # 配置yum源 这里使用阿里的源，注意版本路径
   cat <<EOF > /etc/yum.repos.d/kubernetes.repo
   [kubernetes]
   name=Kubernetes
   baseurl=https://mirrors.aliyun.com/kubernetes/yum/repos/kubernetes-el7-x86_64/
   enabled=1
   gpgcheck=1
   repo_gpgcheck=1
   gpgkey=https://mirrors.aliyun.com/kubernetes/yum/doc/yum-key.gpg https://mirrors.aliyun.com/kubernetes/yum/doc/rpm-package-key.gpg
   EOF

   # 显示仓库列表 输入 y 导入key
   yum repolist

   # 安装
   # 注意：node节点服务器可以不安装 kubectl
   yum install -y kubelet kubeadm kubectl
   # 将 kubelet 设置开机启动
   systemctl enable kubelet
   ```

3. 准备k8s的docker镜像

   - 使用`kubeadm config images list`命令可以查看所需要的镜像

     ```shell
     k8s.gcr.io/kube-apiserver:v1.12.1
     k8s.gcr.io/kube-controller-manager:v1.12.1
     k8s.gcr.io/kube-scheduler:v1.12.1
     k8s.gcr.io/kube-proxy:v1.12.1
     k8s.gcr.io/pause:3.1
     k8s.gcr.io/etcd:3.2.24
     k8s.gcr.io/coredns:1.2.2
     ```

   - Kubernetes安装过程中一个很大的问题，相关组件的镜像都是托管在Google Container Registry上的。国内的镜像加速一般针对的是Dockerhub上的镜像。所以国内的服务器是没法直接安装GCR上的镜像的。

   - 这里使用[安家](https://github.com/anjia0532/gcr.io_mirror)的镜像（国内别人做好的镜像）

     - 创建脚本文件 `vim pull.sh`

     ```shell
     #!/bin/bash
     KUBE_VERSION=v1.12.1
     KUBE_PAUSE_VERSION=3.1
     ETCD_VERSION=3.2.24
     DNS_VERSION=1.2.2
     username=anjia0532
     images=(kube-apiserver:${KUBE_VERSION}
     kube-controller-manager:${KUBE_VERSION}
     kube-scheduler:${KUBE_VERSION}
     kube-proxy:${KUBE_VERSION}
     pause:${KUBE_PAUSE_VERSION}
     etcd:${ETCD_VERSION}
     coredns:${DNS_VERSION}
     )
     for image in ${images[@]}
     do
         docker image pull ${username}/google-containers.${image}
         docker image tag ${username}/google-containers.${image} k8s.gcr.io/${image}
         docker image rm ${username}/google-containers.${image}
     done
     unset KUBE_VERSION KUBE_PAUSE_VERSION ETCD_VERSION DNS_VERSION images username
     ```

     - 执行脚本`sh pull.sh`
     - 正常执行后，通过`docker image ls`可查看已准备好的镜像文件

4. 关闭swap

   - k8s不支持swap分区，需要通过启动参数去掉这个限制

     ```shell
     vim /etc/sysconfig/kubelet

     KUBELET_EXTRA_ARGS="--fail-swap-on=false"
     ```

## 初始化master节点

1. 使用kubeadm初始化k8s

    ```shell
    kubeadm init --kubernetes-version=v1.12.1 --pod-network-cidr=10.244.0.0/16 --service-cidr=10.96.0.0/12 --ignore-preflight-errors=Swap
    ```

    完成后控制台会输出以下信息：

    ```shell
    Your Kubernetes master has initialized successfully!

    To start using your cluster, you need to run the following as a regular user:

      mkdir -p $HOME/.kube
      sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
      sudo chown $(id -u):$(id -g) $HOME/.kube/config

    You should now deploy a pod network to the cluster.
    Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
      https://kubernetes.io/docs/concepts/cluster-administration/addons/

    You can now join any number of machines by running the following on each node
    as root:

      kubeadm join 192.168.1.215:6443 --token hj0bfv.xdolfe80y6e1l49x --discovery-token-ca-cert-hash sha256:c72bae82cdc0fc50119a05ece32a5dd7308b5ad3aabae1753637c876b6b0faa9
    ```

2. 拷贝配置信息文件

   ```shell
   mkdir -p $HOME/.kube
   cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
   ```

3. 此时，可以通过 kubectl 命令检查k8s环境

   ```shell
   [root@m-service-server ~]# kubectl get cs
   NAME                 STATUS    MESSAGE              ERROR
   controller-manager   Healthy   ok
   scheduler            Healthy   ok
   etcd-0               Healthy   {"health": "true"}
   [root@m-service-server ~]# kubectl get nodes
   NAME               STATUS     ROLES    AGE   VERSION
   m-service-server   NotReady   master   19m   v1.12.1
   ```

## 配置网络

1. 这里使用flannel网络

   ```shell
   kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
   ```

2. 通过命令`kubectl get pods -n kube-system -o wide`查看flannel是否运行起来

## 初始化node节点

1. 安装以上步骤准备系统环境，包括安装docker，kubeadm，kubelet，kubectl（可选）；准备k8s的镜像；关闭swap。

2. 节点添加到集群中：

   ```shell
   kubeadm join 192.168.1.215:6443 --token hj0bfv.xdolfe80y6e1l49x --discovery-token-ca-cert-hash sha256:c72bae82cdc0fc50119a05ece32a5dd7308b5ad3aabae1753637c876b6b0faa9 --ignore-preflight-errors=Swap
   ```

   - 注意：token是有有效期的，一般是24小时，如何过去以后还想添加节点，需要到集群中使用`kubeadm token create`命令创建一个新的token，并将上面命令中的token替换掉即可。

3. 成功后，可在master节点通过命令`kubectl get nodes`查看节点信息。

# 安装helm

1. 在[这里](https://github.com/helm/helm/releases)下载最新的release版本`wget https://storage.googleapis.com/kubernetes-helm/helm-v2.11.0-linux-amd64.tar.gz`

2. 解压，并将可执行文件复制到`/usr/local/bin`目录下，就可以直接使用helm命令

   ```shell
   tar zxvf helm-v2.11.0-linux-amd64.tar.gz
   mv linux-amd64/helm /usr/local/bin/helm
   ```

3. 由于开启了rbac，无用先给tiller创建ServiceAccount

   1. 创建文件`vim tiller-rbac.yaml `

      ```yaml
      apiVersion: v1
      kind: ServiceAccount
      metadata:
        name: tiller
        namespace: kube-system
      ---
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRoleBinding
      metadata:
        name: tiller
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: cluster-admin
      subjects:
        - kind: ServiceAccount
          name: tiller
          namespace: kube-system
      ```

   2. 应用`kubectl apply -f tiller-rbac.yaml`

4. 初始化并验证 Helm，指定所使用的ServiceAccount，这样就会自动安装服务器端Tiller。注意：由于国内网络的问题，在安装 Tiller 的时候，需要下载镜像 gcr.io/kubernetes-helm/tiller:v2.11.0，很有可能会安装失败。所以我们这里使用阿里镜像来安装Tiller。

   ```shell
   helm init --service-account tiller --upgrade -i registry.cn-hangzhou.aliyuncs.com/google_containers/tiller:v2.11.0 --stable-repo-url https://kubernetes.oss-cn-hangzhou.aliyuncs.com/charts
   ```

5. 使用`helm version`验证是否安装成功