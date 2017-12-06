# TokenHybird文档 - html- css篇

### 1. html必须标记 'html-identify = "Token"'

```
<!DOCTYPE html>
<html lang="en" html-identify = "Token">
<head>
	<meta charset="UTF-8">                             //可以不写该标签，加快解析速度
	<title>button标签</title>
	<script type="text/javascript" charset="utf-8">    //可以不写'charset="utf-8"'加快解析速度
		token.alert("提示","请仔细阅读文档");
	</script>
</head>
<body>
</body>
</html>
```
## 2. html结构说明
#### `<head></head>`定义非视图内容
1. 标题(title)
2. script标签
3. link,style标签 
<head></head>里面的内容不会被解析成视图组件

**通常 不写CSS，直接写内联style会极大加快解析速度 ，减少script下载，会加快执行js的速度**

#### `<body></body>`里面定义视图组件
支持的标签有下面这些 - 样例请看实验室
> * `<view>` 同等于`<div>`
> * `<label>`
> * `<scrollView>`
> * `<button>`
> * `<image>`
> * `<input>`
> * `<textArea>`
> * `<segment>`
> * `<switch>`
> * `<webView>`
> * `<table>` 
> * `<searchBar>`

## 3. 视图组件的外观设置

1. 你可以在CSS里面设定视图组件的"flex布局"，从而给定具体的视图大小。
2. flex布局写的不对，视图很有可能不会显示，但是会存在。
3. 毕竟是native视图，有些属性在CSS里面会没有，需要写在标签里面。
4. 视图组件支持的通用CSS 属性如下 
    
```
background-color - 视图组件背景色  支持rgb格式和hex格式
border-radius    - 视图组件圆角
border-width     - 视图组件边框宽度
border-color     - 视图组件边框色
z-index          - 见CSS标准
color            - 文本颜色
text-align       - 文本对其方式  格式 (left ,center ,right)
font-size        - 字体大小
font             - 字体样式 格式 (font : 字体名 字体大小) 名字和大小之间有空格 缺一不可！！！会覆盖font-size

示例
<view class = "box" style = "width: 33%;height: 50px;margin-right: 1px ;background-color: rgb(200,0,0)"></view>
```

## 4. native 组件独有的外观设置 - [标签设置方式]
独有的外观设置会比CSS属性优先级高，优先级越高，越显示

#### 1. `<label></label>`

```
<label font = "PingFangSC-Medium 14px"></label> 设置字体
<label lines = "0"></label>                     设置label的行数， 0 为自动换行
<label textAlign = "center"></label>            设置label的行数， 0 为自动换行
```

示例  -  一个文本居中，只有1行，字体大小为14px，字体名字为PingFangSC-Medium的标签 

```
<label class = "typeA" textAlign = "center" lines = "1" font = "PingFangSC-Medium 14px">我是文本 </label>
```

#### 2. `<image></image>`
```
imageMode : 'fill','aspectfit','aspectfill'          图片显示方式 
<image src = "http:xxxx" imageMode = "fill"></image>
效果可以自己试一试
```
#### 3. `<button></button>`

button 一共有三种状态，普通，高亮，选中
普通: 最普通状态
高亮: 用户点击一瞬间
选中: 需要通过js设置为selected

```
type :'system','detailDisclosure','contactAdd'
<button type = "system">我是普通状态标题</button>             标准的 按钮 ，可以试一试其他两个值
<button title = "我是普通状态标题"></button>                  效果和上一个等效
<button highlightTitle = "我是高亮状态标题"></button> 
<button titleColor = "rgb(120,0,0)"></button>              普通状态标题颜色
<button highlightTitleColor = "rgb(120,0,0)"></button>     高亮状态标题颜色
<button selectedBackgroundColor = "rgb(120,0,0)"></button> 选中状态背景颜色
<button image = "http:xxx"></button>                       按钮显示的图片
<button selectedImage = "http:xxx"></button>               按钮选中状态图片
<button highlightImage = "http:xxx"></button>              按钮高亮状态图片
<button imageMode = "fill"></button>                       按钮图片显示方式 - 同image标签
```

#### 4. `<input></input>`


```
<input textColor = "rgb(120,0,0)"></input>         输入框文本颜色
<input cursorColor = "rgb(120,0,0)"></input>       输入框光标颜色
<input placeholder = "rgb(120,0,0)"></input>       输入框占位文本
<input fontSize = "14px"></input>`                 输入框文本大小
<input font = "PingFangSC-Medium 14px"></input>    输入框文本字体 - 同label标签
<input showClear = "true"></input>                 是否显示输入框清楚按钮 - true | false
<input clearOnBegin = "true"></input>              是否显示在开始输入的时候自动清空文本
<input align = "true"></input>                     文本对其方式 - left| center |right
<input borderStyle = "roundedRect"></input>        输入框边框类型 - none|line|bezel|roundedRect
```

#### 5. `<textArea></textArea>`


```
<textArea textColor = "rgb(120,0,0)"></textArea>         输入框文本颜色
<textArea cursorColor = "rgb(120,0,0)"></textArea>       输入框光标颜色
<textArea fontSize = "14px"></textArea>`                 输入框文本大小
<textArea font = "PingFangSC-Medium 14px"></textArea>    输入框文本字体 - 同label标签
<textArea showVBar = "true"></textArea>                  是否显示垂直滚动条
<textArea allowScroll = "true"></textArea>               是否允许滚动
<textArea editable = "true"></textArea>                  是否允许输入文本
<textArea selectable = "true"></textArea>                是否允许长按选择文本
<textArea align = "left"></textArea>                     文本对齐方式 left|rightcenter 
<textArea keyBoardType = "default"></textArea>           键盘类型: default|ASCIICapable|NumbersAndPunctuation|URL|Number

```

#### 6. `<searchBar></searchBar>`


```
<searchBar cursorColor = "rgb(120,0,0)"></searchBar>       搜索框光标颜色
<searchBar placeholder = "rgb(120,0,0)"></searchBar>       搜索框占位文本
<searchBar showsCancelButton = "true"></searchBar>         是否显示搜索框取消按钮 - true | false
```

#### 7. `<scrollView></scrollView>`

```
<scrollView showVBar = "true"></scrollView>    是否显示垂直滚动条
<scrollView showHBar = "true"></scrollView>    是否显示水平滚动条
<scrollView allowScroll = "true"></scrollView> 是否允许滚动
<scrollView pageEnable = "true"></scrollView>  是否允许分页
```

#### 8. `<segment></segment>`

```
<segment color = "rgb(120,0,0)"></segment> 分段控件的主题颜色
```

#### 9. `<switch></switch>`

```
<switch color = "rgb(120,0,0)"></switch>   开关的主题颜色
<switch onColor = "rgb(120,0,0)"></switch> 开关的打开时候的颜色
```

