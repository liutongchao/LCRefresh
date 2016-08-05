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
    
    func setStatus(status:LCRefreshHeaderStatus){
        refreshStatus = status
        switch status {
        case .Normal:
            setNomalStatus()
            break
        case .WaitRefresh:
            setWaitRefreshStatus()
            break
        case .Refreshing:
            setRefreshingStatus()
            break
        }
    }
}

extension LCRefreshHeader{
    /** 各种状态切换 */
    private func setNomalStatus() {
        if activity.isAnimating() {
            activity.stopAnimating()
        }
        activity.hidden = true
        
        contenLab.text = "下拉可以刷新"
        image.hidden = false
        
        UIView.animateWithDuration(0.2) { 
            self.image.transform = CGAffineTransformIdentity
        }
    }
    
    private func setWaitRefreshStatus() {
        if activity.isAnimating() {
            activity.stopAnimating()
        }
        activity.hidden = true
        
        contenLab.text = "松开立即刷新"
        image.hidden = false
        
        UIView.animateWithDuration(0.2) { 
            self.image.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI))

        }
    }
    
    private func setRefreshingStatus() {
        activity.hidden = false
        activity.startAnimating()

        contenLab.text = "正在刷新数据..."
        image.hidden = true
    }
    
}



