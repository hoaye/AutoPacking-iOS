# 一、背景

在实际开发中，需要不停的打各种包，开发人员忙于新需求实现，打包时重复而且没有意义的事情。于是造了这个轮子，配置好参数一键上传到内测网站(蒲公英、Fir等)或者APPStore。

##  1.1、知识储备

使用本脚本的亲们，需要了解打包命令的基本知识，对于打包命令一点不懂的补一下知识再尝试吧，最近好多小伙伴问我报错为什么，一看什么都没有配置就执行，我乐意为大家解决报错问题，私信我的时候请先补充一下相关知识，谢谢。

# 二、预览效果图

## 2.1 执行脚本 和 选项配置

![](https://ws3.sinaimg.cn/large/006tNbRwly1fkfjub1e73j30g60jmmzh.jpg)

## 2.2 开始构建

![](https://ws4.sinaimg.cn/large/006tNbRwly1fkfjve1ztcj30kx0fr0u9.jpg)

## 2.3 构建成功并开始导出ipa

![](https://ws2.sinaimg.cn/large/006tNbRwly1fkfjwg2ey7j30dd044zk9.jpg)

## 2.4 导出ipa成功并上传到内测网站

![](https://ws1.sinaimg.cn/large/006tNbRwly1fkfjximvk6j30le0750u0.jpg)

# 二、脚本环境

基于 Xcode 9 设计，注意Xcode 8和9有所区别，请参考我的另一篇：[http://www.jianshu.com/p/ba179c731e3f](http://www.jianshu.com/p/ba179c731e3f) ,
如有问题，欢迎指正。

# 三、功能

* 支持 xcworkspace 和 xcodeproj 两种类型的工程；
* 可以自动化清理、编译、构建工程导出ipa；
* 支持Debug 和 Release；
* 支持导出app-store, ad-hoc, enterprise, development的包；
* 支持自动上传到蒲公英或者Fir等内测网站

# 四、实现

## 4.1   更新RVM

```bash
curl -L get.rvm.io | bash -s stable
```

## 4.2 所需知识点

```bash

xcodebuild clean 			// 等同于Xcode下点击Product -> Clean
xcodebuild -xcworkspace  	// 等同于xcworkspace工程 command+B
xcodebuild -xcodeproj 		// 等同于xcworkspace工程 command+B
xcodebuild archive 			// 等同于Xcode下点击Product -> Archive
xcodebuild -exportArchive	// 等同于点击 export

```
# 五、脚本

## 配置完项目结构(可以根据自己喜好自由定义)

可以仿照Demo调整

测试体验Demo的话，需要更换的地方：1. 你的Bundle identifier 2.还有Plist里面的相应plist文件，3、上传蒲公英或者Fir的相关APPID和Key，4.(可选) 如果是多个证书的话，需要指定证书，并打开下面的注释

# 六、注意事项

注意ExportOptions.plist配置，如下所示：

```plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>compileBitcode</key>
    <false/>
    <key>method</key>
    <string>enterprise</string>
    <key>provisioningProfiles</key>
    <dict>
        <key>com.houmanager.enterprise.test</key>
        <string>com.houmanager.enterprise.test</string>
    </dict>
    <key>signingCertificate</key>
    <string>iPhone Distribution</string>
    <key>signingStyle</key>
    <string>manual</string>
    <key>stripSwiftSymbols</key>
    <true/>
    <key>teamID</key>
    <string>5XXXXXXXXXXXHM</string>
    <key>thinning</key>
    <string><none></string>
</dict>
</plist>
```

如果不知道怎么填写，手动用Xcode9打包，导出文件中会有ExportOptions.plist

![](https://ws3.sinaimg.cn/large/006tKfTcly1fke46g4ppwj305f02maa1.jpg)

直接复制到指定路径或者手动copy即可。

---
