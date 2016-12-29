//
//  LCRefreshFooter.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/3.
//  Copyright © 2016年 West. All rights reserved.
//

import UIKit

public final class LCRefreshFooter: UIView {

    public let contenLab = UILabel()
    public let activity = UIActivityIndicatorView()

    var refreshStatus: LCRefreshFooterStatus?
    var refreshBlock: (()->Void)?

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configView()
    }
    
    public init(refreshBlock:@escaping (()->Void)) {
        super.init(frame: CGRect(x: LCRefreshFooterX, y: LCRefreshFooterY, width: LCRefreshScreenWidth, height: LCRefreshFooterHeight))
        self.backgroundColor = UIColor.clear
        self.refreshBlock = refreshBlock
        configView()
    }
    
    public init(width:CGFloat ,refreshBlock:@escaping (()->Void)) {
        super.init(frame: CGRect(x: LCRefreshFooterX, y: LCRefreshFooterY, width: width, height: LCRefreshFooterHeight))
        self.backgroundColor = UIColor.clear
        self.refreshBlock = refreshBlock
        configView()
    }
    
    func configView() {
        addSubview(contenLab)
        addSubview(activity)
        
        contenLab.frame = self.bounds
        contenLab.textAlignment = .center
        contenLab.text = "上拉加载更多数据"
        contenLab.font = UIFont.systemFont(ofSize: 14)
    
        activity.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        activity.activityIndicatorViewStyle = .gray
        activity.center = CGPoint.init(x: 40, y: LCRefreshHeaderHeight/2)
        
    }

    
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
    func setNomalStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        contenLab.text = "上拉加载更多数据"
    }
    
    func setWaitRefreshStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        
        contenLab.text = "松开加载更多数据"
    }
    
    func setRefreshingStatus() {
        activity.isHidden = false
        activity.startAnimating()
        
        contenLab.text = "正在加载更多数据..."
    }
    
    func setLoadoverStatus() {
        if activity.isAnimating {
            activity.stopAnimating()
        }
        activity.isHidden = true
        contenLab.text = "全部加载完毕"
    }
    
    
}

