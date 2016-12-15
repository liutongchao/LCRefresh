//
//  LCRefreshHeader.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/2.
//  Copyright © 2016年 West. All rights reserved.
//

import UIKit

class LCRefreshHeader: UIView {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var contenLab: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var refreshStatus: LCRefreshHeaderStatus?
    
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



