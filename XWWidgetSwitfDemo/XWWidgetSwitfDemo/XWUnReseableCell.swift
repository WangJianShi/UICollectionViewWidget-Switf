//
//  XWUnReseableCell.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/11/7.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

class XWUnReseableCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.green
    }
    
    override func reuseWithData(data: NSObject, indexPath: IndexPath) {
        
        super.reuseWithData(data: data, indexPath: indexPath)
        if self.xw_reusableNum <= 1 {
            
             print("index----\(self.xw_indexPath),class----\(self)")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
