//
//  LCRefreshGifHeader.swift
//  LCCFD
//
//  Created by 刘通超 on 2017/8/3.
//  Copyright © 2017年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit

public final class LCRefreshGifHeader: LCBaseRefreshHeader {
    
    public let image = UIImageView()
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configView()
    }
    
    public init(refreshBlock:@escaping (()->Void)) {
        super.init(frame: CGRect(x: LCRefresh.Const.Header.X, y: LCRefresh.Const.Header.Y, width: LCRefresh.Const.Common.screenWidth, height: LCRefresh.Const.Header.height))
        self.backgroundColor = UIColor.clear
        self.refreshBlock = refreshBlock
        configView()
        
    }
    
    public init(width:CGFloat ,refreshBlock:@escaping (()->Void)) {
        super.init(frame: CGRect(x: LCRefresh.Const.Header.X, y: LCRefresh.Const.Header.Y, width:width , height: LCRefresh.Const.Header.height))
        self.backgroundColor = UIColor.clear
        self.refreshBlock = refreshBlock
        configView()
        
    }
    
    func configView() {
        addSubview(image)
        
        image.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
        image.center = CGPoint.init(x: LCRefresh.Const.Common.screenWidth/2, y: LCRefresh.Const.Header.height/2)
        image.contentMode = .scaleAspectFit
        
        let bundle = "LCRefresh.bundle/"
        let imagesStr = ["huhu_1.png","huhu_2.png","huhu_3.png","huhu_4.png","huhu_5.png","huhu_6.png","huhu_7.png","huhu_8.png"]
        var images = [UIImage]()
        for item in imagesStr {
            if let temp1 = UIImage.init(named: bundle+item) {
                images.append(temp1)
            }else{
                if let temp2 = UIImage.init(named: "Frameworks/LCRefresh.framework/"+bundle+item) {
                    images.append(temp2)
                }
            }
        }
        image.animationImages = images
        image.animationDuration = 0.5
    }
    
    public override func setRefreshStatus(status: LCRefreshHeaderStatus) {
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
        case .end:
            setEndStatus()
            break
        }
    }
}

extension LCRefreshGifHeader{
    /** 各种状态切换 */
    func setNomalStatus() {
        if image.isAnimating {
            image.stopAnimating()
        }
    }
    
    func setWaitRefreshStatus() {
        if !image.isAnimating {
            image.startAnimating()
        }
    }
    
    func setRefreshingStatus() {
        if !image.isAnimating {
            image.startAnimating()
        }
    }
    
    func setEndStatus() {
        if image.isAnimating {
            image.stopAnimating()
        }
    }
    
}
