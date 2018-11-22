//
//  NSObject+XW.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/5.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import Foundation
import UIKit

extension NSObject {
    
    private struct XWData_Key {
        
        static var xw_height  = "xw_height"
        static var xw_width   = "xw_width"
        static var xw_reuseIdentifier = "reuseIdentify"
        static var xw_reusable = "reusable"
        static var xw_reusableNum = "reusableNum"

        static var xw_minimumLineSpacing = "minimumLineSpacing"
        static var xw_minimumInteritemSpacing = "minimumInteritemSpacing"
        static var xw_secionInset = "secionInset"
        
        static var xw_extra = "xw_extra"
    
    }
    
    var xw_extraData: AnyObject? {
        
        get {
            return objc_getAssociatedObject(self, &XWData_Key.xw_extra) as AnyObject?
        }
        set {
            objc_setAssociatedObject(self,&XWData_Key.xw_extra,newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        
    }
    
    var xw_height: CGFloat {
        
        get{
            if let height: CGFloat = objc_getAssociatedObject(self, &XWData_Key.xw_height) as? CGFloat {
                
                return height
            }
            return 0.0
        }
        set{
             objc_setAssociatedObject(self, &XWData_Key.xw_height, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_width: CGFloat {
        
        get{
            if let width: CGFloat = objc_getAssociatedObject(self, &XWData_Key.xw_width) as? CGFloat {
                
                return width
            }
            return UIScreen.main.bounds.size.width
        }
        set{
            objc_setAssociatedObject(self, &XWData_Key.xw_width, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_reuseIdentifier: String? {
        
        get {
            return objc_getAssociatedObject(self, &XWData_Key.xw_reuseIdentifier) as? String
        }
        set {
            objc_setAssociatedObject(self,&XWData_Key.xw_reuseIdentifier,newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_reusable: Bool {
        
        get {
            if let reusbale: Bool = objc_getAssociatedObject(self, &XWData_Key.xw_reusable) as? Bool {
                
                return reusbale
            }
            return true
        }
        set {
            objc_setAssociatedObject(self,&XWData_Key.xw_reusable,newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_reusableNum: Int {
        
        get {
            if let num: Int = objc_getAssociatedObject(self, &XWData_Key.xw_reusableNum) as? Int {
                
                return num
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self,&XWData_Key.xw_reusableNum,newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_minimumLineSpacing: CGFloat {
        
        get {
            if let space: CGFloat = objc_getAssociatedObject(self, &XWData_Key.xw_minimumLineSpacing) as? CGFloat {
                
                return space
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self,&XWData_Key.xw_minimumLineSpacing,newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_minimumInteritemSpacing: CGFloat {
        
        get {
            if let space: CGFloat = objc_getAssociatedObject(self, &XWData_Key.xw_minimumInteritemSpacing) as? CGFloat {
                
                return space
            }
            return 0
        }
        set {
            objc_setAssociatedObject(self,&XWData_Key.xw_minimumInteritemSpacing,newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_secionInset: UIEdgeInsets {
        
        get {
            if let inset: UIEdgeInsets = objc_getAssociatedObject(self, &XWData_Key.xw_secionInset) as? UIEdgeInsets {
                
                return inset
            }
            return UIEdgeInsets.zero
        }
        set {
            objc_setAssociatedObject(self,&XWData_Key.xw_secionInset,newValue,objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

