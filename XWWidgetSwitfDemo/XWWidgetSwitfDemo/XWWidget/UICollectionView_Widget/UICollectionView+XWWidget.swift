//
//  UICollectionView+XWWidget.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/10.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView:XWCollectionViewDataSource {
    
    private struct XWWidget_Key {
        static var xw_headerDataList = "xw_headerDataList"
        static var xw_cellDataList = "xw_cellDataList"
        static var xw_footerDataList = "xw_footerDataList"
        static var xw_decorationViewClassList = "xw_decorationViewClassList"
        static var xw_widgets = "xw_widgets"
        static var dataSourceManager = "dataSourceManager"
        static var refreshType = "refreshType"
        
    }
    
    //-----------------------------------数据源-----------------------------------------//
    
    internal func cellDataListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray {
        
        return self.xw_cellDataList
    }
    
    func headerDataListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray {
        
        return self.xw_headerDataList
    }
    
    func footerDataListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray {
        
        return self.xw_footerDataList
    }
    
    func decorationViewClassListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray {
        
        return self.xw_decorationViewClassList
    }
    
    
    // -----------------------------------模块插件的拼接----------------------------------//
    @objc func xw_reloadWidgets()  {
        
        self.xw_headerDataList.removeAllObjects()
        self.xw_cellDataList.removeAllObjects()
        self.xw_footerDataList.removeAllObjects()
        for idx in 0..<self.xw_widgets.count {
            let widget: XWWidget = self.xw_widgets[idx] as! XWWidget
            self.xw_headerDataList.addObjects(from: widget.headerDataList as [AnyObject])
            self.xw_cellDataList.addObjects(from: widget.multiCellDataList as [AnyObject])
            self.xw_footerDataList.addObjects(from: widget.footerDataList as [AnyObject])
            self.xw_decorationViewClassList.addObjects(from: widget.decorationViewClassList as [AnyObject])
            
        }
        
        if self.xw_dataSource == nil {
            
            self.xw_dataSource = self
        }
        DispatchQueue.main.async {
            UIView.performWithoutAnimation({
                self.reloadData()
            })
        }
        
        
    }
  
    func xw_addWidget(widget: XWWidget)  {
        
        let index: Int = self.xw_widgets.count
        self.xw_insertWidget(widget: widget,index: index)
        
    }
    
    func xw_insertWidget(widget: XWWidget, index: Int)  {
        
        if widget.isKind(of: XWWidget.self) && self.xw_widgets.count <= index
        {
            if !self.xw_containWidget(widget: widget)
            {
                widget.collectionView = self
                self.xw_widgets.insert(widget, at: index)
                self.xw_delayReload()
            }
        }
        
    }
    
    func xw_removeWidget(widget: XWWidget)  {
        
        if self.xw_widgets.contains(widget) {
            
            self.xw_widgets.remove(widget)
            self.xw_delayReload()
        }
    }
    
    func xw_removeAllWidgets()  {
        
        if self.xw_widgets.count > 0{
            
            self.xw_widgets.removeAllObjects()
            self.xw_delayReload()
        }
    }
    
    func xw_containWidget(widget: XWWidget) -> Bool {
        
        return self.xw_widgets.contains(widget)
    }
    
    func xw_delayReload()  {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(xw_reloadWidgets), object: nil)
        self.perform(#selector(xw_reloadWidgets), with: nil, afterDelay: 0)
        
    }
    
    //--------------------------------------------网络请求----------------------------------------//
    
    func xw_endRefreshingWithWidgetState(headeRefresh: Bool) {
        
        self.xw_reloadWidgets()
        
    }
    
    var xw_state: XWWidgetState {
        
        get{
            
            var state: XWWidgetState = XWWidgetState.XWWidgetStateDefault
            
            for idx in 0..<self.xw_widgets.count {
                let widget: XWWidget = self.xw_widgets[idx] as! XWWidget
                
                if widget.state == XWWidgetState.XWWidgetStateNetWorkError {
                    
                    return XWWidgetState.XWWidgetStateNetWorkError
                }
                
                if widget.state == XWWidgetState.XWWidgetStateRequsting {
                    
                    return XWWidgetState.XWWidgetStateRequsting
                }
                
            }
            for idx in 0..<self.xw_widgets.count {
                let widget: XWWidget = self.xw_widgets[idx] as! XWWidget
                if widget.state == XWWidgetState.XWWidgetStateRequestNoMoreData {
                    
                    return XWWidgetState.XWWidgetStateRequestNoMoreData
                    
                }
                if widget.state == XWWidgetState.XWWidgetStateRequestSuccess {
                    
                    state = XWWidgetState.XWWidgetStateRequestSuccess
                }
                if widget.state != XWWidgetState.XWWidgetStateRequestSuccess && widget.state == XWWidgetState.XWWidgetStateRequestFail {
                    
                    state = XWWidgetState.XWWidgetStateRequestFail
                }
            }
            
            return state
            
            
        }
    }
    
    func xw_collectionViewHeaderRefresh()  {
        
        self.isHeaderRefresh = true
        for i in 0 ..< self.xw_widgets.count {
            
            let widget: XWWidget = self.xw_widgets.object(at: i) as! XWWidget
            widget.setValue(true, forKey: "needRequest")
            widget.requestHeaderRefresh()
            
        }
    }
    
    func xw_collectionViewFooterRefresh()  {
        
        self.isHeaderRefresh = false
        for i in 0 ..< self.xw_widgets.count {
            
            let widget: XWWidget = self.xw_widgets.object(at: i) as! XWWidget
            widget.setValue(true, forKey: "needRequest")
            widget.requestFooterRefresh()
            
        }
    }
    
    
    func xw_requestFinish()  {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadAllWidgetsIfNeed), object: nil)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(reloadData), object: nil)
        self.perform(#selector(reloadAllWidgetsIfNeed), with: nil, afterDelay: 0)
        
    }
    
    @objc func reloadAllWidgetsIfNeed()  {
        
        var need: Bool = true
        
        for idx in 0..<self.xw_widgets.count {
            let widget: XWWidget = self.xw_widgets[idx] as! XWWidget
            if widget.state == .XWWidgetStateRequsting {
                
                need = false
                break
            }
        }
        
        if  need {
            self.xw_endRefreshingWithWidgetState(headeRefresh: self.isHeaderRefresh)
        }
        
    }
    
    //-------------------------------------计算属性-------------------------------------//
    
    var xw_headerDataList: NSMutableArray {
        
        get{
            if let data: NSMutableArray = objc_getAssociatedObject(self, &XWWidget_Key.xw_headerDataList) as! NSMutableArray? {
                return data
            }
            
            let headDateList = NSMutableArray()
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_headerDataList, headDateList, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return headDateList
        }
        
        set{
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_headerDataList, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_cellDataList: NSMutableArray {
        
        get{
            
            if let data: NSMutableArray = objc_getAssociatedObject(self, &XWWidget_Key.xw_cellDataList) as! NSMutableArray? {
                
                return data
            }
            let cellDateList = NSMutableArray()
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_cellDataList, cellDateList, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return cellDateList
            
        }
        
        set{
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_cellDataList, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_footerDataList: NSMutableArray {
        
        get{
            
            if let data: NSMutableArray = objc_getAssociatedObject(self, &XWWidget_Key.xw_footerDataList) as! NSMutableArray? {
                
                return data
            }
            let footDateList = NSMutableArray()
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_footerDataList, footDateList, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return footDateList
        }
        
        set{
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_footerDataList, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var xw_decorationViewClassList: NSMutableArray {
        
        get{
            
            if let data: NSMutableArray = objc_getAssociatedObject(self, &XWWidget_Key.xw_decorationViewClassList) as! NSMutableArray? {
                
                return data
            }
            let footDateList = NSMutableArray()
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_decorationViewClassList, footDateList, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return footDateList
        }
        
        set{
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_decorationViewClassList, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    var xw_widgets: NSMutableArray {
        
        get{
            
            if let data: NSMutableArray = objc_getAssociatedObject(self, &XWWidget_Key.xw_widgets) as! NSMutableArray? {
                
                return data
            }
            let widgets = NSMutableArray()
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_widgets, widgets, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return widgets
            
        }
        
        set{
            
            objc_setAssociatedObject(self, &XWWidget_Key.xw_widgets, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var isHeaderRefresh: Bool {
        
        get{
            
            if let bHead: Bool = objc_getAssociatedObject(self, &XWWidget_Key.refreshType) as! Bool?  {
                
                return bHead
            }
            return true
        }
        
        set{
            
            objc_setAssociatedObject(self, &XWWidget_Key.refreshType, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
