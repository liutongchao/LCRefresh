//
//  MyTableView.swift
//  LCRefreshDemo
//
//  Created by west on 2018/7/13.
//  Copyright © 2018年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit

class MyTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    deinit {
        print("table 释放")
    }
}
