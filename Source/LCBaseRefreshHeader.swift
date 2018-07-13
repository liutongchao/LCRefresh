//
//  LCBaseRefreshHeader.swift
//  LCRefreshDemo
//
//  Created by 刘通超 on 2017/7/11.
//  Copyright © 2017年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit
public class LCBaseRefreshHeader: UIView,RefreshHeaderInterface {
    var refreshStatus: LCRefreshHeaderStatus?
    var refreshBlock: (()->Void)?

    open func setRefreshStatus(status: LCRefreshHeaderStatus) {}
}
