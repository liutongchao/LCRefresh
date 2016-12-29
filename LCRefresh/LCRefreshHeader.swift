//
//  LCRefreshHeader.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/2.
//  Copyright © 2016年 West. All rights reserved.
//

import UIKit

public final class LCRefreshHeader: UIView {
    
    public let image = UIImageView()
    public let contenLab = UILabel()
    public let activity = UIActivityIndicatorView()
    
    var refreshStatus: LCRefreshHeaderStatus?
    var refreshBlock: (()->Void)?
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configView()
    }
    
    public init(refreshBlock:@escaping (()->Void)) {
        super.init(frame: CGRect(x: LCRefreshHeaderX, y: LCRefreshHeaderY, width: LCRefreshScreenWidth, height: LCRefreshHeaderHeight))
        self.backgroundColor = UIColor.clear
        self.refreshBlock = refreshBlock
        configView()
        
    }
    
    public init(width:CGFloat ,refreshBlock:@escaping (()->Void)) {
        super.init(frame: CGRect(x: LCRefreshHeaderX, y: LCRefreshHeaderY, width:width , height: LCRefreshHeaderHeight))
        self.backgroundColor = UIColor.clear
        self.refreshBlock = refreshBlock
        configView()
        
    }
    
    func configView() {
        addSubview(contenLab)
        addSubview(image)
        addSubview(activity)
        
        contenLab.frame = self.bounds
        contenLab.textAlignment = .center
        contenLab.text = "下拉可以刷新"
        contenLab.font = UIFont.systemFont(ofSize: 14)
        
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
    func setNomalStatus() {
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
    
    func setWaitRefreshStatus() {
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
    
    func setRefreshingStatus() {
        activity.isHidden = false
        activity.startAnimating()
        
        contenLab.text = "正在刷新数据..."
        image.isHidden = true
    }
    
}



