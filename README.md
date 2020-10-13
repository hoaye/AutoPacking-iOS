# 一、背景

在实际多业务迭代开发中，持续打包是必须的工作，自动化实现是必须实现的功能，编辑脚本实现自动化打包上传指定位置。

##  1.1、知识储备

需要了解打包命令 xcodebuild 的基本知识

# 二、预览效果图

## 2.1 执行脚本 和 选项配置

![](http://ww2.sinaimg.cn/large/006tNc79ly1g37m4a2iy9j30k20u2gor.jpg)

## 2.2 开始构建

![](http://ww3.sinaimg.cn/large/006tNc79ly1g37m57lw1fj310e08ggn1.jpg)

## 2.3 构建成功并开始导出ipa 并上传到指定位置

![](https://tva1.sinaimg.cn/large/007S8ZIlly1gjnwwbwdtlj30r105t3zk.jpg)

# 二、脚本环境

基于 Xcode 10+ 设计，注意Xcode 8和9有所区别，请参考作者的另一篇：[http://www.jianshu.com/p/ba179c731e3f](http://www.jianshu.com/p/ba179c731e3f) ,
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

### 测试体验Demo的话，

需要更换的地方：

- 1. 你的Bundle identifier 
- 2.还有Plist里面的相应plist文件
- 3、上传蒲公英或者Fir的相关APPID和Key，
- 4.(可选) 如果是多个证书的话，需要指定证书，并打开下面的注释

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

如果不知道怎么填写，手动用**Xcode**打包，导出文件中会有ExportOptions.plist

![](https://tva1.sinaimg.cn/large/007S8ZIlly1gjnx0of0olj30yc0cgjtz.jpg)

直接复制到指定路径或者手动copy即可。

---

# FAQ

## 1.脚本支持多个target打包吗？
答：支持的，将您的所有target 写在 `__SELECT_TARGET_OPTIONS=("1.AutoPackingDemo")` 这个集合里面，比如：``__SELECT_TARGET_OPTIONS=("1.Tatget1" "2.Target2" "3.Target3")`, 同时修改下面的if else 判断。还有就是如果您是多个Target 对应多个Info.plist，请自行处理对应关系. so easy~

## 2. 编译报错，报 Print: Entry, "CFBundleVersion", Does Not Exist 类似错误怎么解决？
答：报这样的错误多半是Info.plist对应的路径不对 或者 Info.plist名称被修改，脚本 `__CURRENT_INFO_PLIST_NAME="Info.plist"` 处Info.plist 名称和你项目里的相对路径要对。如果是多个Targget对应多个Info.plist，请自行处理对应关系。


