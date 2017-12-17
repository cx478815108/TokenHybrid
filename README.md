# TokenHybrid


![](http://ou3yprhbt.bkt.clouddn.com/hybridBanner.png)
![](https://img.shields.io/badge/platform-iOS-blue.svg) ![](https://img.shields.io/badge/support-iOS9+-blue.svg) ![](https://img.shields.io/dub/l/vibe-d.svg) ![](https://img.shields.io/cocoapods/v/TokenHybrid.svg?style=flat)

------------------------
### What is TokenHybrid？

This is a tool that will **get you out of a server** ,using HTML,CSS,JS to build native interface. The following troubles will disappear.
    
 -  1. You can skip the long process that you need to update the content of app or submit it to the app store.
 -  2. No longer rely on the server. You can control the contents of the app dynamically. Bonus scenes are easy to creat.
 -  3. Replace some H5 apps with this tool and provide a better experience.

Thesr is no doubt that `TokenHybrid` will increase the flexibility of development！
 

------------------------
### How to get out of a server

 1. How `TokenHybrid` updates the app without a server？
    It requests the HTML text and analyzes the text into a data structure. And Native UI based on the data structure.

2. How to place HTML, CSS, JS files?
    You can do it with github or other code hosting services. Just needs the row URL of the HTML.
    -  First ,write these files and push to github.
    -  Second ,click the file and get the row URL.


## Features

1. light weight，high scalability，**independent developers no longer rely on the server to upgrade the app**.
2. Replace a part of H5 apps.It caches the data structures including view coordinate information automatically for opening the application more quickly the next time.
3. As long as the HTML update, the interface will automatically update!

## Preview the screenshots

**All of the following interfaces are built using TokenHybrid.And the HTML source codes are [here](https://github.com/cx478815108/TokenHybridHTML)**

![](http://ou3yprhbt.bkt.clouddn.com/tokenhybrid.png)
![](https://raw.githubusercontent.com/cx478815108/TokenHybrid/master/screenshots/example.gif)


------------------------
## How to use

```
- (IBAction)start:(id)sender {
    NSString *url = @"your html url";   
    TokenHybridRenderController *obj = [[TokenHybridRenderController alloc] initWithHTMLURL:url];
    [self.navigationController pushViewController:obj animated:YES];
}
```

## Install

```
pod 'TokenHybrid'
```

## API
please see Document

## Contact me
[XiongChen](mailto:feelings0811@wutnews.net) -> feelings0811@wutnews.net

-------

### TokenHybrid是什么？

这是一个可以让你**脱离服务器**，使用HTML,CSS,JS构建iOS 原生界面的工具，**帮你解除以下烦恼**
    
-  1. 不在为了修复一个小BUG 或者为更新一点内容就得去app store 审核，跳过这个漫长的过程。
-  2. 不再依赖服务器，自己控制app 的内容，动态更新界面或者功能，给用户创造彩蛋，吸引用户。
-  3. 取代部分H5，提供更好的体验。

------------------------
### 如何不依赖服务器？

 1. `TokenHybrid`如何做到无需服务器更新app？
       
        原理：请求一段HTML 文本，将HTML分析成相应的数据结构（DOM树），根据这个数据结构来创建Native UI，
        并且分析CSS，将样式表合并到Native UI，通过JS来操纵Native。

2. 如何放置HTML,CSS,JS文件呢？
        
        利用github或者其他的代码托管服务就可以做到。
        1. 写好的这些文件，Push 到github
        2. 在github里面点击HTML 文件，查看并在该工具里面使用Row 地址。


## TokenHybrid 特性

-  1. 轻量，可扩展性高，独立开发者的更新程序**不用依赖服务器更新app**。
-  2. 取代部分H5应用，自动缓存数据结构，包括视图的坐标信息，第二次打开更加迅速。
-  3. 支持部分HTML,CSS标准，使用Flex布局，HTML 更新后，重新打开界面会自动生成新界面！

## 预览

**以上英文说明中所有界面，都使用TokenHybrid 构建 图片中所有HTML源码在[这里](https://github.com/cx478815108/TokenHybridHTML)**



------------------------
## 如何接入

```
- (IBAction)start:(id)sender {
    NSString *url = @"your html url";   
    TokenHybridRenderController *obj = [[TokenHybridRenderController alloc] initWithHTMLURL:url];
    [self.navigationController pushViewController:obj animated:YES];
}
```

## 安装

```
pod 'TokenHybrid'
```
或者

[下载这个Demo](https://github.com/cx478815108/TokenHybrid/archive/master.zip) 将 工程里面的 `TokenExtension`和`source` 文件夹拖入你的项目即可，依赖的库你可以根据你自己的需要选择去掉或者保留。

## API使用
请看Document文件夹

## 联系我
[XiongChen](mailto:feelings0811@wutnews.net) -> feelings0811@wutnews.net


