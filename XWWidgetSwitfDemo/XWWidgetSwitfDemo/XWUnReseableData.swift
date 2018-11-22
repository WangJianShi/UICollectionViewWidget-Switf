//
//  XWUnReseableData.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/11/7.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

class XWUnReseableData: NSObject {
    
    override init() {
        
        super.init()
        self.xw_width = UIScreen.main.bounds.size.width - 20
        self.xw_height = 200
        self.xw_reusable = false
    }


}
