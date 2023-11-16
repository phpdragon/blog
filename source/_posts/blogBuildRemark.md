---
title: 如何搭建当前博客？
date: 2023-11-16 18:39:43
tags:
---

Hexo 是一个快速、简单且功能强大的博客框架。使用 Markdown 解析文档，Hexo 能在几秒内生成带有自定义主题并集成各项功能的网站页面。

本博客采用 Github Pages + Hexo 的方式，搭建个人博客。

# 一、准备工作

## 1. 使用个人 GitHub 创建仓库，并配置 GitHub Pages

仓库创建完成后，可以在仓库根路径下创建一个名为 index.html 的静态 HTML 文件来验证个人博客搭建是否成功。
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Someone's Blog</title>
</head>
<body>
    <h1>Hello, Blog World ~</h1>
</body>
</html>
```

## 2. 设置项目Pages

访问仓库对应的 GitHub Pages 设置页面， https://github.com/<GitHub用户名>/<你的项目名>/settings/pages 。
在 Build and deployment 栏目中 Branch一项中选择分支 main， / 根目录， 点击 Save 保存。 稍后刷新页面会出现一个Visit site按钮。
点击跳转打开的浏览器中能正常访问，即代表个人 GitHub Pages 搭建成功，该地址便是是 https://<GitHub 用户名>.github.io。

# 3. 安装 Git 和 NodeJS

Hexo 基于 NodeJS 运行，因此在开始前，需要安装 NodeJS 和 npm 工具。安装教程可参考： []()。

# 一、安装 Hexo

> 此处只列出本次所需的关键步骤，更多说明详见官方文档：https://hexo.io/zh-cn/

## 1. 全局安装 hexo-cli 工具
```shell script
npm install -g hexo-cli

hexo -v # 查看版本，目前最新版本为 4.3.1
```

## 2. 创建一个项目 blog 并初始化

```shell script
hexo init 你的项目名
cd bolg/
npm install --registry=https://registry.npm.taobao.org
```
或者手动创建

```shell script
git clone https://github.com/hexojs/hexo-starter.git
git clone https://github.com/phpdragon/你的项目名.git
rm -rf hexo-starter/.git
mv bolg/.git hexo-starter/

cd bolg/
npm install --registry=https://registry.npm.taobao.org
```

## 3. 生成网页文件 & 本地启动
```shell script
hexo generate # 生成页面，此命令可以简写为 `hexo g`
hexo server # 本地启动，可简写为 `hexo s`
```

通过 hexo g 生成的页面文件在项目 public 目录下；

使用 hexo clean 命令可以清理生成的页面文件。当配置未生效时，建议执行清理命令。

## 4. 本地访问

浏览器访问：http://localhost:4000/。

# 二、安装 & 配置主题

## 1. 安装 Fluid 主题

官方提供了两种安装方式，这里使用官方推荐的 npm 方式。

```shell script
npm install --save hexo-theme-fluid --registry=https://registry.npm.taobao.org
```

在博客根路径下创建 _config.fluid.yml 文件，并将主题的  文件内容复制过去。

```shell script
cp ./node_modules/hexo-theme-fluid/_config.yml ./_config.fluid.yml
```

## 2. 指定主题

> 其他主题：[Hexo themes](https://hexo.io/themes/)

将如下修改应用到 Hexo 博客目录中的 _config.yml:

```yaml
theme: fluid  # 指定主题

language: zh-CN  # 指定语言，会影响主题显示的语言，按需修改
```

# 3. 创建「关于页」

首次使用主题的「关于页」需要手动创建。

```shell script
hexo new page about
```

创建成功后修改 /source/about/index.md，添加 layout 属性。修改后的文件示例如下：

> 需要注意， layout: about 必须存在，并且不能修改成其他值，否则不会显示头像等样式。

```markdown
---
title: 标题
layout: about
---
这里开始写关于页的正文，支持 Markdown, HTML
```

## 4. 更新 Fluid 主题 

通过 npm 安装主题的话，可在项目目录下执行命令：
```shell script
npm update --save hexo-theme-fluid --registry=https://registry.npm.taobao.org
```

## 5. 启动 HEXO

执行如下命令重新生成页面，并启动 Hexo 服务。
```shell script
hexo clean && hexo g && hexo s
```

再次通过浏览器访问 http://localhost:4000 , 便可以看到已使用新的主题。

# 三、创建文章

修改 _config.yml 文件。这项配置是为了在生成文章的同时，生成一个同名的资源目录用于存放图片等资源文件。

```yaml
post_asset_folder: true
```

创建文件名为 my-blog-build-remark 文章。

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

如上命令执行成功后，在 source/_posts/ 目录下生成了一个 Markdown 文件和一个同名的资源目录。
在 source/_posts/blogBuildRemark 目录中放置一个图片文件 example.png，整体目录结构如下：

```text
$ source/_posts> tree
.
├── hello-world.md
├── blogBuildRemark
│   └── example.jpg
└── blogBuildRemark.md
```

然后在文章的 blogBuildRemark.md 文件里，通过以下方式即可引用对应的图片。
```markdown
{% asset_img example.jpg This is an example image %}
```

{% asset_img example.jpg This is an example image %}

图片的引用方式也不只这一种，更多详细介绍可参考官方文档 (https://hexo.io/zh-cn/docs/asset-folders.html)。

# 四、配置 Hexo

## 1. 页面 title 修改

修改 _config.yml 文件
```yaml
title: "请填写你自己的博客标题"
subtitle: ''
description: ''
keywords:
author: 请填写你自己的署名
language: zh-CN
timezone: ''
```

## 2. 博客标题

页面左上角的博客标题，默认使用站点配置_config.yml 中的 title。
此配置同时控制着网页在浏览器标签中的标题，如需单独区别设置，可在主题配置中进行设置。

```yaml
navbar:
  blog_title: "请填写你自己的博客标题"
```

## 3. 首页 - Slogan

首页大图中的标题文字，可在***主题配置***中设定是否开启。这里支持配置固定的 text 或者从远程 api 实时获取，优先级 api > text。

```yaml
index:
  slogan:
    enable: true

    text: "Please type your slogan here."
    api:
      enable: true
      url: "https://v1.hitokoto.cn/"
      method: "GET"
      headers: {}
      keys: ["hitokoto"]
```

# 五、发布 GitHub Pages

## 1. 基于GitHub Actions 部署

### 1.1 查看node版本

使用 node --version 指令检查你电脑上的 Node.js 版本，并记下该版本 (例如：v16.y.z)
```shell script
node --version
```

### 1.2 修改项目配置

在项目库中前往 Settings > Pages > Source，并将 Source 改为 GitHub Actions。

### 1.3 配置workflows

在储存库中建立 .github/workflows/pages.yml，并填入以下内容 (将 16 替换为上个步骤中记下的版本)：

```yaml
name: Pages

on:
  push:
    branches:
      - main # default branch

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
          # If your repository depends on submodule, please see: https://github.com/actions/checkout
          submodules: recursive
      - name: Use Node.js 16.x
        uses: actions/setup-node@v2
        with:
          node-version: '16'
      - name: Cache NPM dependencies
        uses: actions/cache@v2
        with:
          path: node_modules
          key: ${{ runner.OS }}-npm-cache
          restore-keys: |
            ${{ runner.OS }}-npm-cache
      - name: Install Dependencies
        run: npm install
      - name: Build
        run: npm run build
      - name: Upload Pages artifact
        uses: actions/upload-pages-artifact@v2
        with:
          path: ./public
  deploy:
    needs: build
    permissions:
      pages: write
      id-token: write
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v2
```

点击查看 https://github.com/<GitHub用户名>/<你的项目名>/actions， 部署完成后，前往 https://<GitHub用户名>.github.io 查看网站。

# 七、参考资料
- Hexo Docs：https://hexo.io/zh-cn/docs/
- Hexo Fluid 用户手册：https://fluid-dev.github.io/hexo-fluid-docs/