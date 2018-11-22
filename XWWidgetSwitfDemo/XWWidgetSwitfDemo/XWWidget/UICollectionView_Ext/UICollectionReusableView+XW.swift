//
//  UICollectionReusableView+XW.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/6.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import Foundation
import UIKit

@objc extension UICollectionReusableView{
   
    
    private struct XWView_Key {

        static var xw_data = "viewData"
        static var xw_indexPath = "viewIndexPath"
        static var xw_collectionView = "xwCollectionView"
        static var xw_bHeader = "bHeader"

    }

    var xw_data: NSObject {

        get{

            if let data: NSObject = objc_getAssociatedObject(self, &XWView_Key.xw_data) as? NSObject {

                return data
            }
            return NSObject()
        }

        set{

            objc_setAssociatedObject(self, &XWView_Key.xw_data, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var xw_indexPath: IndexPath {

        get{

            if let indexPath: IndexPath = objc_getAssociatedObject(self, &XWView_Key.xw_indexPath) as? IndexPath {

                return indexPath
            }
            return IndexPath.init()
        }

        set{

            objc_setAssociatedObject(self, &XWView_Key.xw_indexPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    unowned var xw_collectionView: UICollectionView {

        get{

            if let cv: UICollectionView = objc_getAssociatedObject(self, &XWView_Key.xw_collectionView) as? UICollectionView {

                return cv
            }
            return UICollectionView.init()
        }
        set{

            objc_setAssociatedObject(self, &XWView_Key.xw_collectionView, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var xw_bHeader: Bool {

        get{

            if let header: Bool = objc_getAssociatedObject(self, &XWView_Key.xw_bHeader) as? Bool {

                return header
            }
            return true
        }
        set{

            objc_setAssociatedObject(self, &XWView_Key.xw_bHeader, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func reuseWithData(data: NSObject, indexPath: IndexPath, isHeader: Bool) {
        
        self.xw_data = data
        self.xw_indexPath = indexPath
        self.xw_bHeader = isHeader
    }
    
    
}


//自动计算高度
extension UICollectionReusableView {
    
    func view_size() -> CGSize {
        
        var view: UIView = self
        if let cell:UICollectionViewCell = self as? UICollectionViewCell {
            
            view = cell.contentView
        }
        let width: CGFloat = self.view_width()
        let height: CGFloat = self.view_height()
        if self.isVerticalLayout() && height > 0
        {
            return CGSize(width: width, height: height)
        }
        else if (!self.isVerticalLayout() && width > 0)
        {
            return CGSize(width: width, height: height)
        }
        self.frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        if self.isVerticalLayout()
        {
            self.updateWidthWithView(view: view, width: width)
        }
        else
        {
            self.updateHeightWithView(view: view, height: height)
        }
        
        var comproessedSize: CGSize = view.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if self.isVerticalLayout()
        {
            comproessedSize.width = width
        }
        else
        {
            comproessedSize.height = height
        }
        return comproessedSize
        
    }
    
    func view_width() -> CGFloat {
        
        if self.isVerticalLayout() {
            
            let insets: UIEdgeInsets = self._seciontInset()
            return self.xw_collectionView.frame.size.width - insets.left - insets.right
        }
        return 0
    }
    
    func view_height() -> CGFloat {
        
        if !self.isVerticalLayout() {
            
            let insets: UIEdgeInsets = self._seciontInset()
            return self.xw_collectionView.frame.size.height - insets.top - insets.bottom
        }
        return 0
    }
    
    func isVerticalLayout() -> Bool {
        
        if let layout: UICollectionViewFlowLayout = self.xw_collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            return layout.scrollDirection == .vertical
        }
        
        return true
    }
    
    func _seciontInset() -> UIEdgeInsets {
        
        if let delegate: UICollectionViewDelegateFlowLayout = self.xw_collectionView.delegate as? UICollectionViewDelegateFlowLayout, let insets: UIEdgeInsets =  delegate.collectionView?(self.xw_collectionView, layout: self.xw_collectionView.collectionViewLayout, insetForSectionAt: self.xw_indexPath.section){
            
            return insets
        }
        return UIEdgeInsets.zero
    }
    
    func updateWidthWithView(view: UIView, width: CGFloat) {
        
        var updated: Bool = false
        let constraints: [NSLayoutConstraint] = view.constraints
        for constraint: NSLayoutConstraint in constraints {
            
            if (constraint.firstAttribute ==  .width && constraint.secondAttribute == .notAnAttribute && constraint.relation == .equal && constraint.secondItem == nil && constraint.multiplier == 1 && constraint.firstItem === view)
            {
                
                if constraint.constant != width {
                    constraint.constant = width
                }
                updated = true
                
            }
            else if (constraint.firstAttribute ==  .height && constraint.secondAttribute == .notAnAttribute && constraint.relation == .equal && constraint.secondItem == nil && constraint.multiplier == 1 && constraint.firstItem === view)
            {
                view.removeConstraint(constraint)
            }
        }
        
        if !updated {
            
            let widthConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: view, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(widthConstraint)
        }
        
    }
    
    
    func updateHeightWithView(view: UIView, height: CGFloat) {
        
        var updated: Bool = false
        let constraints: [NSLayoutConstraint] = view.constraints
        for constraint: NSLayoutConstraint in constraints {
            
            if (constraint.firstAttribute ==  .height && constraint.secondAttribute == .notAnAttribute && constraint.relation == .equal && constraint.secondItem == nil && constraint.multiplier == 1 && constraint.firstItem === view)
            {
                
                if constraint.constant != height {
                    constraint.constant = height
                }
                updated = true
                
            }
            else if (constraint.firstAttribute ==  .width && constraint.secondAttribute == .notAnAttribute && constraint.relation == .equal && constraint.secondItem == nil && constraint.multiplier == 1 && constraint.firstItem === view)
            {
                view.removeConstraint(constraint)
            }
        }
        
        if !updated {
            
            let heightConstraint: NSLayoutConstraint = NSLayoutConstraint.init(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.addConstraint(heightConstraint)
        }
        
    }
}

