//
//  LCRefreshHeader.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/2.
//  Copyright © 2016年 West. All rights reserved.
//

import UIKit

// 图片路径
//#define MJRefreshSrcName(file) [@"MJRefresh.bundle" stringByAppendingPathComponent:file]
//#define MJRefreshFrameworkSrcName(file) [@"Frameworks/MJRefresh.framework/MJRefresh.bundle" stringByAppendingPathComponent:file]

//static let MJRefreshSrcName

class LCRefreshHeader: UIView {
        
    let image = UIImageView()
    let contenLab = UILabel()
    let activity = UIActivityIndicatorView()
    
    var refreshStatus: LCRefreshHeaderStatus?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configView() {
        addSubview(contenLab)
        addSubview(image)
        addSubview(activity)

        contenLab.frame = self.bounds
        contenLab.textAlignment = .center
        contenLab.text = "下拉可以刷新"
        
        image.frame = CGRect.init(x: 0, y: 0, width: 18, height: 30)
        image.center = CGPoint.init(x: 40, y: LCRefreshHeaderHeight/2)
        
        let bundleImage = UIImage.init(named: "LCRefresh.bundle/lc_refresh_down.png")
        if bundleImage != nil {
            image.image = bundleImage
        }else{
            image.image = UIImage.init(named: "Frameworks/LCRefresh.framework/LCRefresh.bundle/lc_refresh_down.png")
        }


        activity.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        activity.activityIndicatorViewStyle = .gray
        activity.center = CGPoint.init(x: 40, y: LCRefreshHeaderHeight/2)
        
    }
    
    func setStatus(_ status:LCRefreshHeaderStatus){
        refreshStatus = status
        switch status {
        case .normal:
            setNomalStatus()
            break
        case .waitRefresh:
            setWaitRefreshStatus()
            break
        case .refreshing:
            setRefreshingStatus()
            break
        }
    }
}

extension LCRefreshHeader{
    /** 各种状态切换 */
    fileprivate func setNomalStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        
        contenLab.text = "下拉可以刷新"
        image.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.image.transform = CGAffineTransform.identity
        }) 
    }
    
    fileprivate func setWaitRefreshStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        
        contenLab.text = "松开立即刷新"
        image.isHidden = false
        
        UIView.animate(withDuration: 0.2, animations: { 
            self.image.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI))

        }) 
    }
    
    fileprivate func setRefreshingStatus() {
        activity.isHidden = false
        activity.startAnimating()

        contenLab.text = "正在刷新数据..."
        image.isHidden = true
    }
    
}



