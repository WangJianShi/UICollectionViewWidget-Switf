//
//  UICollectionView+XW.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/7.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import Foundation
import UIKit

@objc protocol XWCollectionViewDataSource: NSObjectProtocol {
    
    //cell数据源
    func cellDataListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray
    
    //头部数据源
    @objc optional func headerDataListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray
    
    //尾部数据源
    @objc optional func footerDataListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray
    
    //每个secion对应的修饰背景view
    @objc optional func decorationViewClassListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray
}



@objc extension UICollectionView {
    
    
    private struct XWCV_Key {
        
        static var xw_delegates = "xw_delegates"
        static var xw_dataSource = "xw_dataSource"
        static var xw_dataSourceManager = "xw_dataSourceManager"
    
    }
    
    //MARK: - 添加删除元素可以使用NSPointerArray扩展类中的快捷方法
    var xw_delegates: NSPointerArray {
        
        get{
            if let array: NSPointerArray = objc_getAssociatedObject(self, &XWCV_Key.xw_delegates) as? NSPointerArray {
                //TODO: -每次添加或者删除时先去掉NULL值
                //array.compact()
                return array
            }
            let weakArray: NSPointerArray = NSPointerArray.weakObjects()
            objc_setAssociatedObject(self, &XWCV_Key.xw_delegates, weakArray, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return weakArray
        }
        set{
            
             objc_setAssociatedObject(self, &XWCV_Key.xw_delegates, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_dataSource: XWCollectionViewDataSource? {
        
        get{
            if let array: NSPointerArray = objc_getAssociatedObject(self, &XWCV_Key.xw_dataSource) as? NSPointerArray,array.count > 0 {
                if let dataSource: XWCollectionViewDataSource = array.object(at: 0) as? XWCollectionViewDataSource {
                    return dataSource
                }
            }
            return nil
        }
        set{
            self.dataSourceManager.dataSource = newValue
            self.dataSource = self.dataSourceManager
            self.delegate = self.dataSourceManager
            let weakArray: NSPointerArray = NSPointerArray.weakObjects()
            weakArray.add(newValue)
            objc_setAssociatedObject(self, &XWCV_Key.xw_dataSource, weakArray, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    fileprivate var dataSourceManager: XWDataSourceManager {
        
        get{
            if let manager: XWDataSourceManager = objc_getAssociatedObject(self, &XWCV_Key.xw_dataSourceManager) as? XWDataSourceManager {
                
                return manager
            }
            let manager1: XWDataSourceManager = XWDataSourceManager()
            objc_setAssociatedObject(self, &XWCV_Key.xw_dataSourceManager, manager1, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return manager1
        }
    }
}

extension NSPointerArray {
    
    func add(_ object: AnyObject?) {
        guard let strongObject = object else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        addPointer(pointer)
    }
    
    func insert(_ object: AnyObject?, at index: Int) {
        guard index < count, let strongObject = object else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        insertPointer(pointer, at: index)
    }
    
    func replace(at index: Int, withObject object: AnyObject?) {
        guard index < count, let strongObject = object else { return }
        
        let pointer = Unmanaged.passUnretained(strongObject).toOpaque()
        replacePointer(at: index, withPointer: pointer)
    }
    
    func object(at index: Int) -> AnyObject? {
        guard index < count, let pointer = self.pointer(at: index) else { return nil }
        return Unmanaged<AnyObject>.fromOpaque(pointer).takeUnretainedValue()
    }
    
    func remove(at index: Int) {
        guard index < count else { return }
        
        removePointer(at: index)
    }
}


