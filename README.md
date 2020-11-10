# Spring Cloud Seata 使用Demo

官方的Seata-Demo好久没有更新了,在demo跑起来的时候遇到一些坑,遂对项目进行简单修改配置,记录下来

本文采用的 store-type => db 详情可见naocs的 `store.mode=db` [nacos部署指南](http://seata.io/zh-cn/docs/ops/deploy-guide-beginner.html)

[Seata 官方文档](http://seata.io/zh-cn/docs/overview/what-is-seata.html)

原文地址 [springcloud-nacos-seata](https://github.com/seata/seata-samples/tree/master/springcloud-nacos-seata)


## springcloud-nacos-seata

**分布式事务组件seata的使用demo，AT模式，集成nacos、springboot、springcloud、mybatis-plus，数据库采用mysql**

demo中使用的相关版本号，具体请看代码。如果搭建个人demo不成功，验证是否是由版本导致，由于目前这几个项目更新比较频繁，版本稍有变化便会出现许多奇怪问题

```
* seata 1.1.0
* spring-cloud-alibaba-seata 2.1.0.RELEASE
* spring-cloud-starter-alibaba-nacos-discovery  0.2.1.RELEASE
* springboot 2.0.6.RELEASE
* springcloud Finchley.RELEASE
```

## Overview

1. 配置Nacos和Seata-Server并启动
2. 应用侧配置并启动
3. 测试


## 1. 服务端配置

### 1.1 Nacos-server

版本为Nacos Server 1.1.3 ，demo采用本地单机部署方式，请参考 [Nacos 快速开始](https://nacos.io/zh-cn/docs/quick-start.html)

[download link](https://github.com/alibaba/nacos/releases/tag/1.1.3)

`启动Nacos-Server` => windows下 1.1.3 使用内嵌数据库 双击 bin/startup.cmd 就可以启动了

### 1.2 Seata-server

seata-server为release版本1.1.0，demo采用本地单机部署，从此处下载 [download link](https://github.com/seata/seata/releases/tag/v1.1.0) 并解压



#### 1.2.1 注册中心配置

z-config的文件来源自源码中 [nacos-script](https://github.com/seata/seata/tree/1.1.0/script) ,坑不坑

修改 z-config/script/config-center/config.txt配置 其中的数据库 
```
如果是其他应用需要配置 `service.vgroupMapping.order-service-group=default`
service.vgroup_mapping.${your-service-gruop}=default，中间的${your-service-gruop}为自己定义的服务组名称，服务中的application.properties文件里配置服务组名称。
```

cd z-config/script/config-center/nacos

sh nacos-config.sh -h localhost -p 8848 -g SEATA_GROUP


#### 1.2.2 修改Seata中的conf/registry.conf 配置

这里是修改Seata-Server的配置文件

这里是修改Seata-Server的配置文件

这里是修改Seata-Server的配置文件

设置type、设置serverAddr为你的nacos节点地址。

**注意这里有一个坑，serverAddr不能带‘http://’前缀**

```conf
registry {
  type = "nacos"

  nacos {
    serverAddr = "127.0.0.1:8848"
    namespace = ""
    cluster = "default"
  }
}

config {
  type = "nacos"

  nacos {
    serverAddr = "127.0.0.1:8848"
    namespace = ""
    group = "SEATA_GROUP"
  }
}
```


### 1.3 启动seata-server

~~~shell
# 启动seata-server
cd bin
sh seata-server.sh -p 8091 -m file
~~~

----------


## 2. 应用配置

### 2.1 数据库初始化

在mysql中执行查询 z-config/business.sql

以上已经包含了建库语句

### 2.2 应用配置

见代码

几个重要的配置

1. 每个应用的resource里需要配置一个registry.conf ，demo中与seata-server里的配置相同

2. application.propeties 的各个配置项，注意spring.cloud.alibaba.seata.tx-service-group 是服务组名称，与nacos-config.txt 配置的service.vgroup_mapping.${your-service-gruop}具有对应关系

----------

### 3. 功能测试

1. 分布式事务成功，模拟正常下单、扣库存

   localhost:9091/order/placeOrder/commit   

2. 分布式事务失败，模拟下单成功、扣库存失败，最终同时回滚

   localhost:9091/order/placeOrder/rollback 





