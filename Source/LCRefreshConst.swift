//
//  LCRefreshConst.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/3.
//  Copyright © 2016年 West. All rights reserved.
//

import UIKit

struct LCRefresh {
    struct Const {
        struct Common {
            static let screenWidth: CGFloat = UIScreen.main.bounds.width
            static let screenHeight: CGFloat = UIScreen.main.bounds.height
        }
        struct Header {
            static let X: CGFloat = 0
            static let Y: CGFloat = -50
            static let width: CGFloat = 300
            static let height: CGFloat = 50
        }
        
        struct Footer {
            static let X: CGFloat = 0
            static let Y: CGFloat = 0
            static let width: CGFloat = 300
            static let height: CGFloat = 50
        }
    }
    
    struct Object {
        static let current = "LCRefreshCurrentObject"
        static let last = "LCRefreshLastObject"
        static let header = "LCRefreshHeader"
        static let footer = "LCRefreshFooter"
    }
}

