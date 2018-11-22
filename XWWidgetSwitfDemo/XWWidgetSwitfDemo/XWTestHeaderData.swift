//
//  XWTestHeaderData.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/10.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

class XWTestHeaderData: NSObject {
    
    override init() {
        
        super.init()
        self.xw_width = UIScreen.main.bounds.size.width
        self.xw_height = 100
        self.xw_reuseIdentifier = "XWCollectionReusableView"
        self.xw_secionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        self.xw_minimumLineSpacing = 5
        self.xw_minimumInteritemSpacing = 5
    }

}
