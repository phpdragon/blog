# blog
这是我每天分享编程的GitHub博客

# 一. 安装 Git 和 NodeJS

Hexo 基于 NodeJS 运行，因此在开始前，需要安装 NodeJS 和 npm 工具。安装教程可参考： []()。

# 二、安装 Hexo

> 此处只列出本次所需的关键步骤，更多说明详见官方文档：https://hexo.io/zh-cn/

## 三. 全局安装 hexo-cli 工具
```shell script
npm install -g hexo-cli --registry=https://registry.npm.taobao.org

hexo -v # 查看版本，目前最新版本为 4.3.1
```

## 四. 启动 HEXO

执行如下命令重新生成页面，并启动 Hexo 服务。
```shell script
hexo clean && hexo g && hexo s
```

再次通过浏览器访问 http://localhost:4000 , 便可以看到已使用新的主题。

# 五、创建文章

创建文件名为 blogBuildRemark 文章。

```shell script
hexo new post blogBuildRemark
```

设置文章的标题及其他元数据信息

```markdown
---
title: 基于 GitHub Pages + Hexo 搭建个人博客
date: 2022-10-16 19:42:53
tags: ['hexo','fluid']
---
```

# 流、参考资料
- Hexo Docs：https://hexo.io/zh-cn/docs/
- Hexo Fluid 用户手册：https://fluid-dev.github.io/hexo-fluid-docs/