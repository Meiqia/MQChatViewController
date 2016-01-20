MQChatViewController
===============

An easy-to-customize messages UI Library for iOS.

**MQChatViewController** 是一套易于定制的 iOS 开源聊天界面。

该 Library 的**初衷**是为了方便**美洽用户**集成美洽 SDK、自定义美洽客服聊天界面。但为了能让该 Library 满足其他开发者的需要，我们尽量将美洽业务逻辑从该 Library 剥离出去。

**美洽 SDK** 的用户可以直接使用该界面，也可进行二次开发。

非美洽 SDK 用户的童鞋们经过简单的自定义，也可以将之当做聊天界面框架使用。

为什么再写一套聊天 Library？
---
之前在其他项目中用过 [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) 和 [UUChatTableView](https://github.com/ZhipingYang/UUChatTableView)，两个开源项目都很好，但由于 JSQMessage 多文字气泡[卡顿的问题](https://github.com/jessesquires/JSQMessagesViewController/issues/492)迟迟得不到解决，UUChatView 增加自定义 Cell 并不是那么方便，所以决定写一套方便自定义的聊天界面。

Goal - 目标
---
该聊天界面的**目标**是，**能让开发者很方便地进行定制**。

为了达成该目标，该 Library 做了如下设计：
* 避免 MVC (Massive View Controller)，将 TableView、TableView 的 DataSource 和 ViewController 的数据管理都独立出去，ViewController 只充当 View 和 Model 的接口；
* 为每一种 Cell 建立一个单独的类，以方便开发者进行修改和替换；
* 所有的 Cell 都继承于一个基 Cell，这样开发者就不需要修改 DataSource 中的逻辑；
* 所有的 CellModel 都必须满足一类协议方法，避免开发者过多的修改数据管理的逻辑；
* 如果开发者不需要再自定义其他的 View，则不需要修改 ViewController；

Usage - 使用方法
---
最简单的使用方式，即初始化 `MQChatViewManager`，然后对界面进行配置，最后调用启动聊天界面接口即可；

如果你想在某一个 ViewController，Push 一个聊天界面，可复制下面两行代码：
```objective-c
	MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
	[chatViewManager pushMQChatViewControllerInViewController:self];
```
有关聊天界面的配置，请见文档末尾的 [Configuration](#configuration---配置) 小节.

Project Structure - 代码结构
---

文件 | 作用
----- | -----
[Config/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatViewManager) | 对聊天界面进行配置的文件
[Controllers/MQChatViewController](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/ViewController/MQChatViewController.h) | 界面的 Controller 类
[Controllers/MQChatViewService](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/ViewController/MQChatViewService.h) | 界面的数据管理类，开发者可在该类中对接自己项目的 APIManager，来进行发送、收取消息等业务逻辑
[Controllers/MQChatViewTableDataSource](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/ViewController/MQChatViewTableDataSource.h) | 消息的 TableView 的 DataSource，开发者不需要修改该类
[Views/MQChatTableView](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/ViewController/MQChatTableView.h) | 消息的 TableView
[TableCells/CellModel](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatCells/CellModel) | 自定义 Cell 的 ViewModel，进行内容转换、布局计算等等
[TableCells/CellView](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatCells/Cell) | 自定义的 Cell，Cell 中的View直接使用在相应的 CellModel 中计算好的数据
[MessageModels/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatMessages) | 该文件夹中的类是该 Library 会用到的 Message 实体
[Utils/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/ChatUtil) | 自定义的工具类
[Views/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/Views) | 界面中用到的自定义 View，如聊天 TableView、下拉刷新、输入框等等
[Assets/MQChatViewAsset.bundle](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/MQChatViewBundle.bundle) | 资源文件，如图片、声音文件等，**注意**用户如果需要通过 MQChatViewManager 修改自定义元素图片，需要将图片放在该 bundle 中
[Vendors/](https://github.com/Meiqia/MQChatViewController/tree/master/MQChatViewControllerDemo/MQChatViewController/Vendors) | 第三方开源库

注意：
* 代码中的预处理是为了剥离美洽 SDK 的逻辑，如果你不是美洽 SDK 的用户，可将代码中所有 `#ifdef INCLUDE_MEIQIA_SDK` 中的逻辑换成自己的API逻辑，如下方：

```objective-c
	#ifdef INCLUDE_MEIQIA_SDK
	//调用美洽的API逻辑
	#endif
```

* 如果你是美洽 SDK 用户，则需要在 `MQChatViewConfig.h` 中，取消下面 define 的注释，以便打开美洽的 API：

```objective-c
	//是否引入美洽SDK
	//#define INCLUDE_MEIQIA_SDK
```

Demo - 示例
---
开发者可参考 Demo 中的用法，对聊天界面进行配置，来进行基本的自定义功能，例如下面的示例：

**开发者可这样 push 出聊天界面，效果如下：**
```objective-c
	MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager pushMQChatViewControllerInViewController:self];
```
![screenshot1](https://github.com/ijinmao/MQChatViewController/blob/master/DemoGif/MQChatViewDemo1.gif)

--------

**开发者可这样 present 出聊天界面的模态视图，效果如下：**
```objective-c
	MQChatViewManager *chatViewManager = [[MQChatViewManager alloc] init];
    [chatViewManager presentMQChatViewControllerInViewController:self];
```
![screenshot2](https://github.com/ijinmao/MQChatViewController/blob/master/DemoGif/MQChatViewDemo2.gif)

--------

**开发者可这样配置：底部按钮、修改气泡颜色、文字颜色、使头像设为圆形，效果如下：**
```objective-c
	[chatViewManager setPhotoSenderImage:photoImage highlightedImage:photoHighlightedImage];
    [chatViewManager setVoiceSenderImage:voiceImage highlightedImage:voiceHighlightedImage];
    [chatViewManager setTextSenderImage:keyboardImage highlightedImage:keyboardHighlightedImage];
    [chatViewManager setResignKeyboardImage:resightKeyboardImage highlightedImage:resightKeyboardHighlightedImage];
    [chatViewManager setIncomingBubbleColor:[UIColor redColor]];
    [chatViewManager setIncomingMessageTextColor:[UIColor whiteColor]];
    [chatViewManager setOutgoingBubbleColor:[UIColor yellowColor]];
    [chatViewManager setOutgoingMessageTextColor:[UIColor darkTextColor]];
    [chatViewManager enableRoundAvatar:true];
    [chatViewManager pushMQChatViewControllerInViewController:self];
```
![screenshot3](https://github.com/ijinmao/MQChatViewController/blob/master/DemoGif/MQChatViewDemo3.gif)

--------

**开发者可这样配置：是否支持发送语音、是否显示本机头像、修改气泡的样式，效果如下：**
```objective-c
    [chatViewManager enableSendVoiceMessage:false];
    [chatViewManager enableClientAvatar:false];
    [chatViewManager setIncomingBubbleImage:incomingBubbleImage];
    [chatViewManager setOutgoingBubbleImage:outgoingBubbleImage];
    [chatViewManager setBubbleImageStretchInsets:UIEdgeInsetsMake(stretchPoint.y, stretchPoint.x, incomingBubbleImage.size.height-stretchPoint.y+0.5, stretchPoint.x)];
    [chatViewManager pushMQChatViewControllerInViewController:self];
```
![screenshot4](https://github.com/ijinmao/MQChatViewController/blob/master/DemoGif/MQChatViewDemo4.gif)

--------

**开发者可这样配置：增加可点击链接的正则表达式( Library 本身已支持多种格式链接，如未满足需求可增加)、增加欢迎语、是否开启消息声音、修改接受消息的铃声，效果如下：**
```objective-c
	[chatViewManager setMessageLinkRegex:@"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|([a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)"];
    [chatViewManager enableChatWelcome:true];
    [chatViewManager setChatWelcomeText:@"你好，请问有什么可以帮助到您？"];
    [chatViewManager setIncomingMessageSoundFileName:@"MQNewMessageRingStyle2.wav"];
    [chatViewManager enableMessageSound:true];
    [chatViewManager pushMQChatViewControllerInViewController:self];
```
![screenshot5](https://github.com/ijinmao/MQChatViewController/blob/master/DemoGif/MQChatViewDemo5.gif)

--------

**如果 tableView 没有在底部，开发者可这样打开消息的提示，效果如下：**
```objective-c
	[chatViewManager enableShowNewMessageAlert:true];
    [chatViewManager pushMQChatViewControllerInViewController:self];
```
![screenshot6](https://github.com/ijinmao/MQChatViewController/blob/master/DemoGif/MQChatViewDemo6.gif)

--------

**开发者可这样配置：是否支持下拉刷新、修改下拉刷新颜色、增加导航栏标题，效果如下：**
```objective-c
	[chatViewManager enableTopPullRefresh:true];
    [chatViewManager setPullRefreshColor:[UIColor redColor]];
    [chatViewManager setNavTitleText:@"美洽SDK"];
    [chatViewManager pushMQChatViewControllerInViewController:self];
```
![screenshot7](https://github.com/ijinmao/MQChatViewController/blob/master/DemoGif/MQChatViewDemo7.gif)

--------

**开发者可这样修改导航栏颜色、导航栏左右键、取消图片消息的mask效果，效果如下：**
```objective-c
	[chatViewManager setNavTitleText:@"美洽SDK"];
    [chatViewManager setNavigationBarTintColor:[UIColor redColor]];
    [chatViewManager setNavRightButton:rightButton];
    [chatViewManager pushMQChatViewControllerInViewController:self];
```
![screenshot8](https://github.com/ijinmao/MQChatViewController/blob/master/DemoGif/MQChatViewDemo8.gif)


Customization - 深度自定义
---
**3步添加自定义 Cell**
* 添加自定义的 Cell 类，注意该 Cell 必须继承于 `MQChatBaseCell`;
* 添加自定义 Cell 的 CellModel，注意 CellModel 必须实现 `MQCellModelProtocol` 协议中的方法；
* 接下来你需要在 `MQChatViewService.m` 中，使用你自己的发送消息、接受消息的数据接口；注：你可以查看 `#ifdef INCLUDE_MEIQIA_SDK` 里面的内容，里面用到了我们数据层和UI层的中间接口 `MQServiceToViewInterface`；

**替换加载图片的策略**
* 该 Library 中没有使用**图片/文件缓存**等策略，加载图片的地方都新开了一个线程进行数据加载，如下方所示，开发者可根据自己的项目替换成不同的缓存策略，如 SDWebImage 等;

```objective-c
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
#warning 这里开发者可以使用自己的图片缓存策略，如SDWebImage
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:message.userAvatarPath]];
    });
```

Configuration - 配置
---
如果你不想修改聊天界面的内部逻辑，`MQChatViewManager` 提供了很多接口，可以实现一些自定义设置。

名词解释

名词 | 说明
--- | ---
incoming | 表示聊天对方
outgoing | 表示本机用户

下面列举一些常用的配置聊天界面的接口如下：(详细请见 [MQChatViewManager.h](https://github.com/ijinmao/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/ChatViewManager/MQChatViewManager.h))
```objective-c
	/**
	 * @brief 增加消息中可选中的链接的正则表达式，用于匹配消息，满足条件段落可以被用户点击。
	 * @param numberRegex 链接的正则表达式
	 */
	- (void)setMessageLinkRegex:(NSString *)linkRegex;

	/**
	 * @brief 增加消息中可选中的email的正则表达式，用于匹配消息，满足条件段落可以被用户点击。
	 * @param emailRegex email的正则表达式
	 */
	- (void)setMessageEmailRegex:(NSString *)emailRegex;

	/**
	 * @brief 设置收到消息的声音；
	 * @param soundFileName 声音文件
	 */
	- (void)setIncomingMessageSoundFileName:(NSString *)soundFileName;

	/**
	 * @brief 是否支持发送语音消息；
	 * @param enable YES:支持发送语音消息 NO:不支持发送语音消息
	 */
	- (void)enableSendVoiceMessage:(BOOL)enable;

	/**
	 * @brief 是否支持发送图片消息；
	 * @param enable YES:支持发送图片消息 NO:不支持发送图片消息
	 */
	- (void)enableSendImageMessage:(BOOL)enable;

	/**
	 * @brief 是否支持对方头像的显示；
	 * @param enable YES:支持 NO:不支持
	 */
	- (void)enableIncomingAvatar:(BOOL)enable;

	/**
	 * @brief 是否支持当前用户头像的显示
	 *
	 * @param enable YES:支持 NO:不支持
	 */
	- (void)enableOutgoingAvatar:(BOOL)enable;

	/**
	 * @brief 是否开启接受/发送消息的声音；
	 * @param enable YES:开启声音 NO:关闭声音
	 */
	- (void)enableMessageSound:(BOOL)enable;

	/**
	 * @brief 是否开启下拉刷新（顶部刷新）
	 *
	 * @param enable YES:支持 NO:不支持
	 */
	- (void)enableTopPullRefresh:(BOOL)enable;

	/**
	 *  @brief 设置下拉/上拉刷新的颜色
	 *
	 *  @param pullRefreshColor 颜色
	 */
	- (void)setPullRefreshColor:(UIColor *)pullRefreshColor;

	/**
	 * @brief 设置发送过来的message的文字颜色；
	 * @param textColor 文字颜色
	 */
	- (void)setIncomingMessageTextColor:(UIColor *)textColor;

	/**
	 *  @brief 设置发送过来的message气泡颜色
	 *
	 *  @param bubbleColor 气泡颜色
	 */
	- (void)setIncomingBubbleColor:(UIColor *)bubbleColor;

	/**
	 * @brief 设置发送出去的message的文字颜色；
	 * @param textColor 文字颜色
	 */
	- (void)setOutgoingMessageTextColor:(UIColor *)textColor;

	/**
	 *  @brief 设置发送的message气泡颜色
	 *
	 *  @param bubbleColor 气泡颜色
	 */
	- (void)setOutgoingBubbleColor:(UIColor *)bubbleColor;
```
更多配置请见 [MQChatViewManager.h](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/Config/MQChatViewManager.h) 文件。

Localization - 国际化/本地化
---
本项目支持[英文](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/Assets/MQChatViewAsset.bundle/en.lproj/MQChatViewController.strings)、[简体中文](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/Assets/MQChatViewAsset.bundle/zh-Hans.lproj/MQChatViewController.strings)和[繁体中文](https://github.com/Meiqia/MQChatViewController/blob/master/MQChatViewControllerDemo/MQChatViewController/Assets/MQChatViewAsset.bundle/zh-Hant.lproj/MQChatViewController.strings)，语言的定义在 Assets/MQChatViewAsset.bundle 中。

如果开发者想增加多种语言，在 Assets/MQChatViewAsset.bundle 增加对应的语言项目即可。

**注意**

为了能正常识别App的系统语言，开发者的 App 的 info.plist 中需要有添加 Localizations 配置。如果需要支持英文、简体中文、繁体中文，info.plist 的 Souce Code 中需要有如下配置：

```
<key>CFBundleLocalizations</key>
<array>
	<string>zh_CN</string>
	<string>zh_TW</string>
	<string>en</string>
</array>
```

To-do-list - 待修复问题
---
由于 SDK 发布催的很紧，以下问题还没有得到妥善解决，但影响不大，所以还没有修复，开发者打怪得分后可提 PR ^.^：
* 目前只支持单张图片全屏浏览，还不支持多张图片浏览；
* 下拉刷新的瞬间，tableView 会跳跃一下，给人造成一种"卡了一下"的感觉；
* 启动上拉刷新(底部刷新)，只显示了 loading 的 indicator，没有显示出 loading 的 path 效果；
* 使用 TTTAttributedLabel，输入 emoji，text 会往下偏移；
* TTTAttributedLabel 中使用了 NSUnderlineColorAttributeName，导致不兼容 iOS 6，所以对于 iOS 7 以下的用户，消息气泡中的文字用的是 UILabel；所以对于 iOS 7 以下用户，没有文字选中的效果；
* 开发者可在项目中搜索#warning，其中有一个 warning 是 TTTAttributedLabel 的 bug，开发者感兴趣可以解决一下；

Vendors - 用到的第三方开源库
---
以下是该 Library 用到的第三方开源代码，如果开发者的项目中用到了相同的库，需要删除一份，避免类名冲突：

第三方开源库 | 说明
----- | -----
[SDWebImage](https://github.com/rs/SDWebImage) | 知名的异步图片下载和图片缓存库；
VoiceConvert | AMR 和 WAV 语音格式的互转；没找到出处，哪位童鞋找到来源后，请更新下文档~
[MLAudioRecorder](https://github.com/molon/MLAudioRecorder) | 边录边转码，播放网络音频 Button (本地缓存)，实时语音。**注意**，由于该开源项目中的 [lame.framework](https://github.com/molon/MLAudioRecorder/tree/master/MLRecorder/MLAudioRecorder/mp3_en_de/lame.framework) 不支持 `bitCode` ，所以我们去掉了该项目中有关 MP3 的文件；
[MHFacebookImageViewer](https://github.com/michaelhenry/MHFacebookImageViewer) | 图片查看器；**注意**，我们对该开源库进行了修改，以支持单击关闭Viewer等一些操作，该修改版本可见[MHFacebookImageViewer](https://github.com/ijinmao/MHFacebookImageViewer)；
[FBDigitalFont](https://github.com/lyokato/FBDigitalFont) | 类 LED 显示效果，用于本项目中的语音倒计时显示；
[GrowingTextView](https://github.com/HansPinckaers/GrowingTextView) | 随文字改变高度的的 textView，用于本项目中的聊天输入框；
[TTTAttributedLabel](https://github.com/TTTAttributedLabel/TTTAttributedLabel) | 支持多种效果的 Lable，用于本项目中的聊天气泡的文字 Label；
[CustomIOSAlertView](https://github.com/wimagguc/ios-custom-alertview) | 自定义的 AlertView，用于显示本项目的评价弹出框；

Hope to Help Each Other - 互助
---
由于开发进度紧张，该项目写的较快，肯定有很多地方没有考虑周到，欢迎开发者指正和建议~

如果该 Library 有帮助到你，或是你想完善此 Library，欢迎通过任何形式联系我们，一起讨论、一起互帮互助总是好的^.^

美洽官方开发者群:  295646206
