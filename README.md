# ZLSwiftGeneralBaseProject
该工程是Swift通用基础工程，可以以此工程搭建基于Rxswift的iOS应用。

## Requirements

- iOS 8.0 or later

## Introduce

### 普通模块
原则上每个模块有“controller”、“view”、“viewModel”、“model”。  
（1）controller存放视图控制器；  
（2）view包含普通视图和一个cell文件夹，所有的tableViewCell和collectionViewCell文件夹下存放cell文件夹下；  
（3）viewModel存放着所有viewModel文件；  
（4）model中存放所有的控制器或视图需要使用数据模型文件和一个vo文件夹，所有作为数据包装或者参数的数据模型文件存放在vo文件夹下。
### 基础模块
#### common模块
##### 基础组件
###### 视图控制器基类（BasicVC）
（1）原则上所有的视图控制器要继承于BasicVC；  
（2）BasicVC包含一个LoadStatusHud，改变其状态可显示数据请求状态，重写hudActionForLoadData()方法可响应其按钮重新加载的事件；  
（3）设置navigationEdgePanEnable属性决定左边缘右滑能否返回。  
###### 其他控制器
（1）选项卡控制器。CommonTabBarVC为选项卡控制器基类，子类重写appendChildVC()方法加入子视图控制器（通常是导航控制器）；  
（2）导航控制器。CommonNavigationVC为导航控制器类，其子控制器实现back()方法可处理导航栏返回按钮点击事件。  
###### 网络请求返回数据模型基类（APIBaseResponse）
（1）所有的网络请求返回的数据模型必须继承于APIBaseResponse；  
（2）根据统一的判断方法（APIBaseResponse.code）将返回的结果封装成一个APIResult枚举，判断其状态获取请求结果(例如isSuccess表示此次客户端和服务端进行了一次成功的会话，isCorrect表示此次从会话上传/获取的数据是正确的，等等)；  
（3）包含数据的接口使用APIResponse（APIBaseResponse子类），其中data（与接口字段data对应，如果接口字段为其他，做相应修改即可）成员变量为其泛型（需遵守Decodable协议），使用方法为APIResponse<Class>。  
###### 基础控件
例如可以设置图片与标题相对位置的按钮、控制器底部按钮、弹窗、自定义数字键盘等等。
##### 服务和工具
###### 服务。
对所有模块提供服务，例如验证输入号码是否手机号，数据纠错等等。
###### 单例
单例需要遵守SingletonAvaliable协议。使用SingletonFactory类建立单例。
格式：
SingletonFactory.getInstance(classType: Class.self)/Class.default(shared/current)。
###### ConvertUtil
使用ConvertUtil可以将Objective-C对象与Swift对象进行互转，swift对象必须继承于NSObject，并遵守Encodable/Decodable协议。
###### Http请求
遵守HttpRequestAble协议可以实现网络请求方法（协议已有默认实现）。
###### 调试
Logger类可控制输出控制台日志。
##### 网络接口与数据库接口
###### 内容格式
需要一个遵守Encodable协议的参数，返回一个Observable对象。格式如下：
func getLoginCode(info: LoginCodeReqInfo) -> Observable<APIResult<APIBaseResponse>>。
###### 接口的返回
数据库接口返回的Observable对象的泛型为直接所需要的对象；网络接口中Observable对象的泛型内容参照前文APIBaseResponse的叙述。
#### other模块。
Other模块存放桥接、本地框架、常量、拓展等文件。其中桥接文件是令Objective-C文件与Swift文件能相互访问、本地框架中包含自定义框架。
##### 常量
###### 普通常量
普通常量包含颜色（UIColor）、字体（UIFont）、广播名称（NSNotification.Name）、字符串（String）。
###### URL
URLs是一个枚举，将接口url定义成枚举值，不同应用环境用不同的枚举属性合成完整的url。
格式：
URLs.login.url。
##### 拓展
###### 基础拓展类为ZLExtension
（1）原则上所有的普通拓展都要在此类上拓展；  
（2）写法为extension ZLExtension where Base:(or ==) ClassName；  
（3）用法为ClassName.cl.staticFunctionName()、ClassName().cl.functionName()。  
###### RxSwift的拓展类为Reactive
（1）写法为extension Reactivewhere Base: (or ==) ClassName；  
（2）用法为ClassName().rx.functionName()。  
### 环境配置
本工程包含release和development两种环境配置，可以增加target以拓展环境配置。  
