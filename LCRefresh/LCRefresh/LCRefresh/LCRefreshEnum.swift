//
//  LCRefreshEnum.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/4.
//  Copyright © 2016年 West. All rights reserved.
//

import Foundation

/** Header 刷新状态 */
enum LCRefreshHeaderStatus {
    case
    Normal,
    WaitRefresh,
    Refreshing
}
/** Footer 刷新状态 */
enum LCRefreshFooterStatus {
    case
    Normal,
    WaitRefresh,
    Refreshing,
    Loadover
}

/** 当前刷新对象 */
enum LCRefreshObject {
    case None,
        Header,
        Footer
}

