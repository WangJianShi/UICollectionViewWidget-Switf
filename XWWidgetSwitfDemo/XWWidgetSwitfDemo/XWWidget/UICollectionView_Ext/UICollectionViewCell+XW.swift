//
//  UICollectionViewCell+XW.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/6.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import Foundation
import UIKit

@objc extension UICollectionViewCell{
    
    
    func xw_didSelectCell() {
        
    }
    
    func xw_didDeselectCell() {
        
    }
    
    func xw_willDisplayCell() {
        
    }
    
    func xw_didEndDisplayCell() {
        
    }
    
    func xw_shouldSelectCell() -> Bool{
        
        return true
    }
    
    func xw_shouldDeselectCell() -> Bool {
        
        return true
    }
    
    func xw_shouldHighlightCell()  -> Bool {
        
         return true
    }
    
    func xw_didHighlightCell() {
        
    }
    
    func xw_didUnhighlightCell() {
        
    }
    
    func reuseWithData(data: NSObject, indexPath: IndexPath) {
        
        self.xw_data = data
        self.xw_indexPath = indexPath
        self.xw_reusableNum += 1
    }
    
}

