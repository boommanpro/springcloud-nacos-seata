# Seata-Sample AT

本代码copy from [Seata练习](https://start.aliyun.com/handson-lab/#%21category=arthas)


## 使用教程

1. 启动seata服务 将 `init-seata.sh` copy到服务器上

假设服务器地址 192.168.88.129

```
cd ~
sh ./init-seata.sh
```

2. mvn clean package

3. 修改三个服务的application.yml中的8091端口的地址 

4.分别启动三个服务


5. 访问应用
你可以通过如下几个链接来实现业务逻辑和异常场景的触发：

库存检查链接 http://localhost:60000/seata/check
正常链接 http://localhost:60000/seata/feign?count=5
异常链接 http://localhost:60000/seata/feign?count=5&mockException=true
在链接 2、3 中的参数：

count 属性代表扣减库存的数量，当库存不足将触发事务回滚；
mockException 属性代表是否触发业务异常，设置为true 会触发业务异常，并通过分布式事务实现回滚;
这里我们提供了几个场景：

检查=>正常=>检查
代表正常访问场景，初始100的库存，正常扣减5件后，库存95
检查=>异常=>检查
典型的异常场景，初始95的库存（上一步完成了扣减），希望再次扣减5件，但是发生了异常，导致食物全部回滚，库存依然是95件