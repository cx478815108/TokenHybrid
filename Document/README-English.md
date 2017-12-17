# TokenHybrid


![](http://ou3yprhbt.bkt.clouddn.com/hybridBanner.png)
![](https://img.shields.io/badge/platform-iOS-blue.svg) ![](https://img.shields.io/badge/support-iOS9+-blue.svg) ![](https://img.shields.io/dub/l/vibe-d.svg) ![](https://img.shields.io/cocoapods/v/TokenHybrid.svg?style=flat)

------------------------
### What is TokenHybrid？

This is a tool that will **get you out of a server** ,using HTML,CSS,JS to build native interface. The following troubles will disappear.
    
 -  1. You can skip the long process that you need to update the app content or submit to the app store.
 -  2. No longer rely on the server. You can control the contents of the app dynamically. Bonus scenes are easy to creat.
 -  3. Replace some H5 apps with this tool and provide a better experience.

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


