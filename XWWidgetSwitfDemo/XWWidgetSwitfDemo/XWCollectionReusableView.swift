//
//  XWCollectionReusableView.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/6.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

class XWCollectionReusableView: UICollectionReusableView {
    

    override init(frame: CGRect) {
        
        super.init(frame: frame) 

        self.backgroundColor = UIColor.red

    }
    
    override func reuseWithData(data: NSObject, indexPath: IndexPath, isHeader: Bool) {
        
        super.reuseWithData(data: data, indexPath: indexPath, isHeader: isHeader)
    }
 
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
