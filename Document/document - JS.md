# TokenHybird文档 - JS 篇

**使用JS可以控制或者设置更多native组件的外观或者其他属性**。
JS执行不用担心时机问题，所有JS文本会在DOM渲染完后开始执行。

## DOM操作 - 操作native组件
 每个标签都都对应一个node，都继承TokenPureNode,都对应一个native组件
 而TokenPureNode又继承至最根本的TokenXMLNode
 
 所有所有的组件拥有TokenXMLNode能力，所有的(button,label,等组件)有view组件能力

#### 1. document对象能力

方法包含如下:

```
document.getElementById()
document.getElementsByTagName()
document.getElementsByClassName()
document.pushNavigatorWithURL("http:xxx",value) value是传递到下个页面的数据
document.setTitle("标题")  //设置标题
document.html
document.sourceURL
document.rootNode;
document.bodyNode;
document.headNode;
document.titleNode;
document.navigationBarNode;
```
#### 2. TokenXMLNode能力

```
node.getElementById()
node.getElementsByTagName()
node.getElementsByClassName()
node.name
node.innerText
node.identifier
node.parentNode
node.innerAttributes
node.cssAttributes
node.childNodes

```

#### 3. view组件能力
var view = document.getElementById("customID");

```
view.setHidden(1)                        //隐藏视图， 相当于 css display : none
view.setBackgroundColor("rgb(120,0,0)"); // 
view.setCornerRadius(4);
view.setBorderColor(4);
view.setBorderWidth("rgb(120,0,0)");
view.setUserInteractionEnabled(1);        // 允许和用户交互，关闭后，button.image,label都不在响应事件


view.componentWidth;            //获取视图宽度
view.componentHeight;           //获取视图高度
view.originX;                   //获取视图左上角X坐标
view.originY;                   //获取视图左上角Y坐标
view.centerX;                   //获取视图中心点X坐标
view.centerY;                   //获取视图中心点Y坐标
view.maxX;                      //获取视图在父视图的最右边
view.maxY;                      //获取视图在父视图的最下边
```

#### 3. button组件能力

var button = document.getElementById("customID");

```
button.setSelectedTitle();                          //参数字符串
button.setHightTitle();                             //参数字符串
button.setTitle();                                  //参数字符串
button.setHightTitleColor();                        //参数字符串
button.setTitleColor();                             //参数字符串
button.setSelectedTitleColor();                     //参数字符串
button.setSelectedBackgroundColor();                //参数字符串
button.setFont({fontName : "字体名字",size : 14px}); 
button.setOnClick(()=>{});                          //参数为回调函数
button.setSelected(1);
```

#### 4. image组件能力

var image = document.getElementById("customID");

```
image.setImage("http:xxx");
image.setOnClick(()=>{});                          //参数为回调函数
```
#### 5. label组件 能力

var label = document.getElementById("customID");

```
label.setText();             //参数字符串
label.setFont({fontName : "字体名字",size : 14px});
label.setTextColor();        //参数字符串
label.setNumberOfLines(1);   //设置文本的行数
label.setTextAlign();        //参数字符串
label.setOnClick(()=>{});    //参数为回调函数
label.adjustFontSize(1);     //开启文字大小自适应
```
#### 6. input组件能力

var input = document.getElementById("customID");

```
input.setFont({fontName : "字体名字",size : 14px});
input.setText()              //参数字符串
input.setTextColor();        //参数字符串
input.setCursorColor();      //参数字符串
input.setPlaceHolder();      //参数字符串
input.setTextAlign();        //参数字符串
input.onBeginEditing(()=>{});    //参数为回调函数  -  监听是否开始编辑
input.onEndEditing(()=>{});      //参数为回调函数  -  监听是否开结束编辑
input.onTextChange(()=>{});      //参数为回调函数  -  监听文本改变
input.onClearClick(()=>{});      //参数为回调函数  -  监听是否点击了清除按钮
input.onKeyBoardReturn(()=>{});  //参数为回调函数  -  监听是否点击了键盘上的return按钮
input.endEditing()              //退出编辑，键盘消失
input.text                      //组件的文本

```

#### 7. textArea组件能力

var textArea = document.getElementById("customID");

**textArea有input的所有能力，还有以下能力**

```
textArea.setEditable(1)   //是否允许编辑
textArea.showVBar(1)      //是否显示滚动条
textArea.scrollEnable(1)  //是否允许滚动

```

#### 8. searchBar组件能力

var searchBar = document.getElementById("customID");

```
searchBar.showsCancelButton(1);
searchBar.setPlaceHolder();
searchBar.setCursorColor();
searchBar.setBarColor();
searchBar.onBeginEditing(()=>{});           //参数为回调函数  -  监听是否开始编辑
searchBar.onEndEditing(()=>{});             //参数为回调函数  -  监听是否结束编辑
searchBar.onTextChange((text)=>{});         //参数为回调函数  -  监听文本改变
searchBar.onSearchButtonClick((text)=>{});  //参数为回调函数  -  监听是否点击了键盘的搜索按钮

```

#### 9. segment组件能力

var segment = document.getElementById("customID");

```
segment.setSelectedIndex(1)  //设置选中第二个
segment.setOnClick(()=>{});  //参数为回调函数 - 监听点击事件

```

#### 10. switch组件能力

var switch = document.getElementById("customID");

```
switch.setSwitchState(1)     //设置开关状态
segment.setOnClick(()=>{});  //参数为回调函数 - 监听点击事件

```

#### 11. webView组件能力

var webView = document.getElementById("customID");

```
webView.onStartLoad(()=>{});           //参数为回调函数  -  监听网页是否开始加载
webView.onReceiveContent(()=>{});      //参数为回调函数  -  监听网页是否开始接收内容
webView.onFinish(()=>{});              //参数为回调函数  -  监听网页是否成功加载结束
webView.onFailLoad(()=>{});            //参数为回调函数  -  监听网页是否加载失败
webView.onReceiveJSMessage(()=>{});    //参数为回调函数  -  监听网页的JS给native的消息
webView.loadURL("http:xxxx");   //webView加载网页
webView.goBack();               //webView返回上一页
webView.goForward();            //webView前进一页
webView.reload();               //webView重新加载
webView.stopLoading();          //webView停止加载
webView.setUA();                //webView设置UA
webView.openHeaderRefresh();     //开启下拉刷新
webView.stopHeaderRefresh();     //停止下拉刷新
webView.hiddenHeaderRefresh();   //关闭下拉刷新
webView.openFooterRefresh();     //开启上拉刷新 - webView 几乎用不到
webView.stopFooterRefresh();     //停止上拉刷新 - webView 几乎用不到
webView.hiddenFooterRefresh();   //关闭上拉刷新 - webView 几乎用不到
webView.onHeaderRefresh(()=>{}); //参数为回调函数  -  监听到用户下拉刷新了;
webView.onFooterRefresh(()=>{}); //参数为回调函数- webView 几乎用不到

```

#### 12. scrollView组件能力
var scrollView = document.getElementById("customID");

```
scrollView.scrollToTop(1);                //是否滚动到顶部 参数控制是否动画
scrollView.setScrollInset(10，20，30，40)  //给scrollView增加额外的滚动区域 参数顺序- 上边10px，左边20px，下边30px，右边40px;
scrollView.setContentSize(宽,高);          //参数为数字，设置ScrollView的滚动区域大小，大于自身可视区域滚动生效
scrollView.offsetX;                 //获取滚动到的x坐标
scrollView.offsetY;                 //获取滚动到的y坐标
scrollView.openHeaderRefresh();     //开启下拉刷新
scrollView.stopHeaderRefresh();     //停止下拉刷新
scrollView.hiddenHeaderRefresh();   //关闭下拉刷新
scrollView.openFooterRefresh();     //开启上拉刷新
scrollView.stopFooterRefresh();     //停止上拉刷新
scrollView.hiddenFooterRefresh();   //关闭上拉刷新
scrollView.showHBar(1);             //是否显示水平滚动条
scrollView.showVBar(1);             //是否显示竖直滚动条
scrollView.scrollEnable(1);         //是否允许滚动
scrollView.pageEnable:(1);          //是否开启滚动分页
scrollView.onHeaderRefresh(()=>{}); //参数为回调函数  -  监听到用户下拉刷新了;
scrollView.onFooterRefresh(()=>{}); //参数为回调函数  -  监听到用户上拉刷新了;
```

#### 13. table组件能力

var table = document.getElementById("customID");
table组件继承自 scrollView组件，拥有其全部能力，额外有

```
table.reloadData(参数参加demo);  //加载数据
tablesetOnClick((section,index)=>{}) //参加掌理实验室demo代码
```







