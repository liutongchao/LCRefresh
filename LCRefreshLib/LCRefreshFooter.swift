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
    
    func setStatus(_ status:LCRefreshFooterStatus){
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
        case .loadover:
            setLoadoverStatus()
            break
        }
    }

}


extension LCRefreshFooter{
    /** 各种状态切换 */
    fileprivate func setNomalStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        contentLab.text = "上拉加载更多数据"
    }
    
    fileprivate func setWaitRefreshStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        
        contentLab.text = "松开加载更多数据"
    }
    
    fileprivate func setRefreshingStatus() {
        activity.isHidden = false
        activity.startAnimating()
        
        contentLab.text = "正在加载更多数据..."
    }
    
    fileprivate func setLoadoverStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        contentLab.text = "全部加载完毕"
    }
    
    
}

