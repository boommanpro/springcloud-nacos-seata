#!/bin/bash

wget https://handson.oss-cn-shanghai.aliyuncs.com/seata-server-1.4.1.zip -O .seata-server-1.4.1.zip

unzip .seata-server-1.4.1.zip

nohup sh ~/seata/bin/seata-server.sh -p 8091 -m file &