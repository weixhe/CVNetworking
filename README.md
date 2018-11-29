# CVNetworking

### 引入工程
  ` pod CVNetworking `
  
### 使用

第一步：创建项目中需要用到的服务service，这里可以设置域名，基础参数，基础header，参数编码，公共错误处理，网络监听等。
  方法一、继承默认的CVService，该类已经做了部分初始化，用起来更为方便。
  方法二、CVServiceProxy，实现完全自定义，这里需要设置的东西比较多，所以推荐使用方法一，直接继承
  
  网络监听类 `CVReachability`，已自动开启了监听，在请求发起之前会判断网络的连接状态，若要实时监听网络的变化，仍需在service中调用以下方法
  ```
  CVReachability.share.stateChanged { (state: CVNetworkState) in
      if state == .notReachable {
         ALERT(message: "没有网")
      }
  }
  ```
  
第二步：创建ApiManager，在这里，每一个Api都需要创建一个多对应的mananger类，且必须继承基类`CVBaseApiManager`和 `实现CVBaseApiManagerChild`协议，在子类manager中，可以填充一些方法名，请求方式（GET,POST），参数等


最后，调起请求，在ViewController或viewModel中创建manager的实例对象，直接调用reloadData() 方法，即可调起请求，需要实现`CVBaseApiManagerDelegate`协议，以方便接受请求结果的回调
        

  
