MQChatViewController
===============
**编辑中...**

An easy to cutomized messages UI library for iOS.

**MQChatViewController**是一套易于定制的开源聊天界面。

该library的**初衷**是为了方便**美洽用户**集成美洽SDK、自定义美洽客服聊天界面。但为了能让该library满足其他开发者的需要，我们尽量将美洽业务逻辑从该library剥离出去。

**美洽SDK**的用户可以直接使用该界面，也可进行二次开发。

非美洽SDK用户的童鞋们经过简单的自定义，也可以将之当做聊天界面框架使用。

为什么再写一套聊天library？
---
之前在其他项目中用过[JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController)和[UUChatTableView](https://github.com/ZhipingYang/UUChatTableView)，两个开源项目都很好，但由于JSQMessage多文字气泡[卡顿的问题](https://github.com/jessesquires/JSQMessagesViewController/issues/492)迟迟得不到解决，UUChatView增加自定义Cell并不是那么方便，所以决定写一套方便自定义的聊天界面。

目标
---
该聊天界面的**目标**是，**能让开发者很方便地添加自定义的cell**。

为了达成该目标，该library做了如下设定：
* 该项目为每一个cell建立一个单独的UITableViewCell类，以便开发者进行修改和替换；
* 所有的Cell都继承于一个基cell，这样在DataSource中就可以直接使用；
* 所有的CellModel都必须满足一个协议，这样在数据管理中即不需要区分CellModel的类型，可直接使用；
* 只要满足Cell和CellModel的要求，`MQChatViewTableDataSource`中即不需要开发者进行更改；

Usage
---
最简单的使用方式，即初始化`MQChatViewManager`，并对界面进行配置，然后调用`presentMQChatViewControllerInViewController`或`pushMQChatViewControllerInViewController`即可；

Configuration
---
如果你不想修改聊天界面的内部逻辑，`MQChatViewManager`提供了很多接口，可以实现一些自定义设置。

## 框架结构

[文件] | 作用
----- | -----
[ChatMessages/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatMessages) | 该文件夹中的类是该library会用到的Message实体
[ChatCells/CellModels](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatCells/cellModel) | 自定义Cell的ViewModel，进行内容转换、布局计算等等
[ChatCells/Cells](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatCells/cell) | 自定义的Cell类，cell中的自定义View直接使用在相应的CellModel中计算好的数据
[ChatViewManager/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatViewManager) | 对聊天界面进行配置的文件
[ViewController/MQChatViewController](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/ViewController/MQChatViewController.h) | 界面的Controller类
[ViewController/MQChatViewTableDataSource](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/ViewController/MQChatViewTableDataSource.h) | 消息的TableView的DataSource，开发者不需要修改该类
[ViewController/MQChatViewService](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/ViewController/MQChatViewService.h) | 界面的数据管理类，开发者可在该类中对接自己项目的APIManager，来进行发送、收取消息等业务逻辑
[ViewController/MQChatTableView](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/ViewController/MQChatTableView.h) | 消息的TableView
[ChatUtil/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatUtil) | 自定义的工具类
[Views/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/Views) | 界面中用到的自定义View，如下拉刷新、输入框等等
[MQChatViewBundle.bundle](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/MQChatViewBundle.bundle) | 资源文件，如图片、声音文件等
[Vendors/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/Vendors) | 第三方开源库

注意：
* 代码中的预处理是为了集成美洽SDK的逻辑，如果你不是美洽SDK的用户，可将代码中所有`#ifdef INCLUDE_MEIQIA_SDK`中的逻辑换成自己的API

```objective-c
	#ifdef INCLUDE_MEIQIA_SDK
	//调用美洽的API逻辑
	#endif
```

* 如果你是美洽SDK用户，则需要在MQChatViewConfig.h中，取消下面define的注释，以便打开美洽的API：

```objective-c
	//是否引入美洽SDK
	//#define INCLUDE_MEIQIA_SDK
```

## 自定义
**3步添加自定义cell**
* 添加自定义的UITableViewCell类，注意该cell必须继承于`MQChatBaseCell`;
* 添加自定义Cell的CellModel，注意CellModel必须实现`MQCellModelProtocol`协议中的方法；
* 接下来你需要在`MQChatViewService.m`中，使用你自己的发送消息、接受消息的数据接口；注：你可以查看`#ifdef INCLUDE_MEIQIA_SDK`里面的内容，里面用到了我们数据层和UI层的中间接口`MQServiceToViewInterface`；