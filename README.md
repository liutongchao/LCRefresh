# LCRefresh 
### `0.1.16` 更新动态
1、修复数据未充满屏幕，上拉刷新问题<br>
2、支持Carthage

**********

### `0.1.15` 更新动态
1、修复了销毁view崩溃bug
注意：在视图将要销毁的时候记得removeobserver
**********

### `0.1.14` 更新动态
1、修复了刷新结束时的动画问题。<br>
2、修复了swift 关于 PI 的警告

**********

使用 `LCRefresh` 非常方便，只需添加一行代码。

#### Pod 支持
>pod 'LCRefresh', '~> 0.1.16'

#### Carthage 支持
>github "liutongchao/LCRefresh"

##### 添加下拉刷新 和 上拉加载

    import LCRefresh

    table.refreshHeader = LCRefreshHeader.init(refreshBlock: {
           print("Header 刷新")
            //TODO
     })

    table.refreshFooter = LCRefreshFooter.init(refreshBlock: {
             print("Footer 刷新")
            //TODO
     })


##### 完成刷新

    weak var weakSelf = self
    if weakSelf!.table.isHeaderRefreshing() {
        weakSelf!.table.endHeaderRefreshing()
    }

    if weakSelf!.table.isFooterRefreshing() {
        weakSelf!.table.endFooterRefreshing()
    }

##### 数据加载完毕

    weakSelf!.table.setDataLoadover()
    
    weakSelf!.table.resetDataLoad()
    
##### 对象将要销毁时，移除观察者

    table.removeOffsetObserver()

##### 刷新的效果图


![HeaderRefresh.png](http://upload-images.jianshu.io/upload_images/1951020-a07715badbfa03ec.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

详细信息请移步到我的博客
[Swift 让我来告诉你封装下拉刷新多么简单](http://www.jianshu.com/p/725cd8028c8a)

##--by West
