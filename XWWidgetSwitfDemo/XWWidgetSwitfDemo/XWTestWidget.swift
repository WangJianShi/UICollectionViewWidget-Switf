//
//  XWTestWidget.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/10.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

class XWTestWidget: XWWidget {
    
    override init() {
        
        super.init()
        
        self.headerData = XWTestHeaderData()
        self.headerData.xw_minimumInteritemSpacing = 10
        self.headerData.xw_minimumLineSpacing = 10;
        
        let cells: NSMutableArray = NSMutableArray()
        for _ in 0 ... 40 {
            
            let testData: XWTestData = XWTestData()
            testData.title =  "很不错，这是自动算高度的，你也来试试啊，看准不准确啊，哈哈哈哈啊哈哈"
            cells.add(testData)
        }
        
        self.cellDataList = cells
        
        self.decorationViewClass = XWDecroationView1.self
    }
    
    init(col: Int) {
        
        super.init()
        self.headerData = XWTestHeaderData()
        self.headerData.xw_minimumInteritemSpacing = 5
        self.headerData.xw_minimumLineSpacing = 5;
        
        let cells: NSMutableArray = NSMutableArray()
        for _ in 0 ... 40 {
            
            let testData: XWTestData = XWTestData()
            testData.title =  "很不错，这是自动算高度的，你也来试试啊，看准不准确啊，哈哈哈哈啊哈哈"
            testData.xw_width = (UIScreen.main.bounds.width - 20 - CGFloat((col - 1)*5))/CGFloat(col)
            testData.xw_height = CGFloat(arc4random() % 100) + 100
            cells.add(testData)
        }
        
        self.cellDataList = cells

        self.decorationViewClass = XWDecroationView1.self
    }

}
