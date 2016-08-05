# LCRefresh 

使用 `LCRefresh` 非常方便，只需添加一行代码。
######添加下拉刷新 和 上拉加载

    table.addRefreshHeaderWithBlock {
            print("Header 刷新")
            //TODO
     }

    table.addRefreshFooterWithBlock {
            print("Footer 刷新")
            //TODO
    }

######完成刷新

    weak var weakSelf = self
    if weakSelf!.table.isHeaderRefreshing() {
        weakSelf!.table.endHeaderRefreshing()
    }

    if weakSelf!.table.isFooterRefreshing() {
        weakSelf!.table.endFooterRefreshing()
    }

######数据加载完毕

    weakSelf!.table.setDataLoadover()
    
    weakSelf!.table.resetDataLoad()

######刷新的效果图

![HeaderRefresh.png](http://upload-images.jianshu.io/upload_images/1951020-03286bc8c3fd87a5.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![FooterRefresh.png](http://upload-images.jianshu.io/upload_images/1951020-8b78a79cd6f9140c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
