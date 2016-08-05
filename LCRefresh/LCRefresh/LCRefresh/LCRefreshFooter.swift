//
//  LCRefreshFooter.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/3.
//  Copyright © 2016年 West. All rights reserved.
//

import UIKit

class LCRefreshFooter: UIView {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var contentLab: UILabel!

    var refreshStatus: LCRefreshFooterStatus?
    
    func setStatus(status:LCRefreshFooterStatus){
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
        case .Loadover:
            setLoadoverStatus()
            break
        }
    }

}


extension LCRefreshFooter{
    /** 各种状态切换 */
    private func setNomalStatus() {
        if activity.isAnimating() {
            activity.stopAnimating()
        }
        activity.hidden = true
        contentLab.text = "上拉加载更多数据"
    }
    
    private func setWaitRefreshStatus() {
        if activity.isAnimating() {
            activity.stopAnimating()
        }
        activity.hidden = true
        
        contentLab.text = "松开加载更多数据"
    }
    
    private func setRefreshingStatus() {
        activity.hidden = false
        activity.startAnimating()
        
        contentLab.text = "正在加载更多数据..."
    }
    
    private func setLoadoverStatus() {
        if activity.isAnimating() {
            activity.stopAnimating()
        }
        activity.hidden = true
        contentLab.text = "全部加载完毕"
    }
    
    
}

