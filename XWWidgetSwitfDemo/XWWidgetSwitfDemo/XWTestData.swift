//
//  XWTestData.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/10.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

class XWTestData: NSObject {
    
    var title: String = ""
    
    override init() {
        
        super.init()
        self.xw_width = (UIScreen.main.bounds.size.width - 30)/2.0
//        self.xw_height = CGFloat(arc4random() % 200) + 50
    }

}
