@echo off
@REM  # 安装yarn替代npm
@REM  npm install -g yarn --registry=https://registry.npmmirror.com
@REM  # 设置软件源
@REM  yarn config set registry https://registry.npmmirror.com
@REM 
@REM 使用yarn加快安装依赖速度
yarn install && hexo clean && hexo g && hexo s
