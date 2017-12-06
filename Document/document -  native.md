# TokenHybird文档 - native 能力篇

对native能力的获取需要用到token对象

### 用户数据获取

```
token.userInfo(); //获取用户数据
token.existUser(); //是否登录
token.didLoginLibrary(); //
token.didLogininOffice(); //
```

### 网络请求
```

token.request(
    {
        url:"https://xxxxx",
        method:"POST",
        UA:"",
        timeout:30,  //请求超时时间 ，30s
        header:{     //http请求头
            "key1":"value1",
            "key2":"value2",
        },
        httpParameter:{  // POST参数 - 方式1
            "key1":"value1",
            "key2":"value2",
        },
        jsonParameter:{  // POST参数 - 方式2   当方式一不行时尝试方式二,会相互覆盖
            "key1":"value1",
            "key2":"value2",
        },
        resultType:"text",   //请求结果的类型，是text还是json text|json
        success :(response) => {
        },
        failure:(code,reason) => {
        },
    }
);
```

### 定位
```
token.getLocation((obj)=>{
    console.log(obj.longitude);
    console.log(latitude);
});

```

### 本地存储操作
存储都是同步方法

```
//把数据存储到iPhone 磁盘
token.setStorage({
    key : "自定义key",
    value : 自定义value
});

//从iPhone 磁盘根据自定义key获取数据
token.getStorage('key');

//从iPhone 清除当前页 app 的所有磁盘数据
token.clearAllStorage();

//把数据存储到iPhone 磁盘  - 全局存储
token.setGlobleStorage({
    key : "自定义key",
    value : 自定义value
});

//从iPhone 磁盘根据自定义key获取数据   - 全局存储 所有的页面都可以获取
token.getGlobleStorage();

//从iPhone 磁盘 清除的所有磁盘数据
token.clearGlobleStorage();
```

### 打电话

```
token.makePhoneCall('110');
```

### 存储照片到相册

```
token.saveImage({
    url:'http:xxx',
    success:()=>{  //存储成功回调
    },
    failure:(reason)=>{  //存储失败回调 reason 字符串
    }
);

```

### toast 和 HUD

```
token.showNormalToast("我是文本显示5s",5s);  //紫色toast
token.showErrorToast("我是文本显示5s",5s);  //红色tosat
token.showHUDWithStatus("我开始转菊花-需要手动hide");
token.showSuccessHUD("带对勾的提示-自动hide")
token.showErrorHUD("带叉叉的提示-自动hide")
token.hideHUD();hide HUD

```

### 预览图片

```
token.previewImages(["图片1 URL","图片2 URL""图片3 URL",...],2);//初始在第二个图片
```

### 异步线程操作

可以配合storage使用

```
//5秒后在主线程执行回调 - 该方法为异步
token.dispatchMainAfter(5,()=>{});

//5秒后在其他线程执行回调 - 该方法为异步
token.dispatchGlobleAfter(5,()=>{});

```

### 弹框

```
token.alert("title","msg");
token.alertTitles({
    title: "弹框的title",
    msg: "",
    actionTitles : [
        "我是按钮1",
        "我是按钮2",
    ],
    feedBack:(index)=>{
        console.log("点击了"+index+"按钮");
    },
    cancleButton:true  // 是否显示取消按钮
});

//弹出输入框
token.alertInput(
{
    title: "弹框的title",
    msg: "",
    textFields : [
        {
            placeholder : "输入框1 的占位文字",
            defaultText : "输入框1 的默认文字",
            secureText : true //输入框开启密码隐私
        },
        {
            placeholder : "输入框2 的占位文字",
            defaultText : "输入框2 的默认文字",
            secureText : false //输入框未开启密码隐私
        },
    ],
    feedBack:(textArray)=>{
        console.log("输入框1文本是:" + textArray[0]);
        console.log("输入框2文本是:" + textArray[1]);
    }
});


token.showSheetView(参数);  //参数同token.alertTitles
```

### 其他 

```

//弹出数据选择时光滚轮
token.pickData(参数);

//请求touch ID验证
token.requestTouchID("xxx请求touchID",(code,desc)=>{
    //code == 1 验证成功
    //code == 0 验证失败
    
}); 

//当前屏幕的宽度
token.screenWidth();

//当前屏幕的高度
token.screenHeight();

//随机字符串颜色 
token.randomColor() 

//随机字符串颜色 - 随机的是掌理8个主题色
token.randomThemColor()
```

