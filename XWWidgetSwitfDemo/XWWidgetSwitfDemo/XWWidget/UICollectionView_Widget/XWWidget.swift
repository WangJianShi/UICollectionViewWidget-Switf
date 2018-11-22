//
//  XWWidget.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/10.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

enum XWWidgetState: Int {
    case XWWidgetStateDefault      // 正常状态
    case XWWidgetStateRequsting   // 正在请求刷新状态
    case XWWidgetStateRequestFail  // 请求刷新失败
    case XWWidgetStateRequestSuccess// 请求刷新成功
    case XWWidgetStateRequestNoMoreData// 请求刷新无更多数据状态
    case XWWidgetStateNetWorkError  //网络错误
}

class XWWidget: NSObject {
    
    weak var collectionView: UICollectionView?
    var state: XWWidgetState = .XWWidgetStateDefault
    
    private var _headerData: NSObject!
    private var _cellDataList: NSMutableArray!
    private var _footerData: NSObject!
    private var _decorationViewClass: AnyClass!
    
    private var _headerDataList: NSMutableArray = []
    private var _multiCellDataList: NSMutableArray = []
    private var _footerDataList: NSMutableArray = []
    private var _decorationViewClassList: NSMutableArray = []
    
    var needRequest: Bool = false {
        
        didSet{
            if needRequest {
                self.state = .XWWidgetStateRequsting
            }
        }
    }
    
    
    var headerData: NSObject {
        
        set{
            _headerData = newValue
            self.headerDataList = []
        }
        get{
            if _headerData == nil {
                _headerData = NSObject.init()
                _headerData.xw_width = 0.01;
                _headerData.xw_height = 0.01;
            }
            return _headerData
        }
    }
    
    var cellDataList: NSMutableArray {
        
        set{
            _cellDataList = newValue
            _multiCellDataList = NSMutableArray()
        }
        get{
            if _cellDataList == nil {
                _cellDataList = NSMutableArray()
            }
            
            return _cellDataList
        }
    }
    
    var footerData: NSObject {
        
        set{
            _footerData = newValue
            self.footerDataList = []
        }
        get{
            if _footerData == nil {
                _footerData = NSObject.init()
                _footerData.xw_width = 0.01;
                _footerData.xw_height = 0.01;
            }
            return _footerData
        }
    }
    
    var decorationViewClass: AnyClass {
        
        set {
            _decorationViewClass = newValue
            _decorationViewClassList = []
        }
        get{
            if _decorationViewClass == nil {
                _decorationViewClass = UICollectionReusableView.classForCoder()
            }
            return _decorationViewClass
        }
    }
    
    
    var  headerDataList: NSMutableArray {
        
        set{
            _headerDataList = newValue
        }
        get{
            if _headerData != nil && _headerDataList.count == 0{
                _headerDataList.add(self.headerData)
            }
            if _headerDataList.count < self.multiCellDataList.count {
                while _headerDataList.count < self.multiCellDataList.count {
                    _headerDataList.add(self.headerData)
                }
            }
            
            return _headerDataList
        }
    }
    
    var  multiCellDataList: NSMutableArray {
        
        set{
            _multiCellDataList = newValue
        }
        get{
            if _multiCellDataList.count == 0 && self.cellDataList.count != 0{
                _multiCellDataList.add(self.cellDataList)
            }
            return _multiCellDataList
        }
    }
    
    var  footerDataList: NSMutableArray {
        
        set{
            _footerDataList = newValue
        }
        get{
            if _footerData != nil && _footerDataList.count == 0{
                _footerDataList.add(self.footerData)
            }
            
            if _footerDataList.count < self.multiCellDataList.count {
                while _footerDataList.count < self.multiCellDataList.count {
                    _footerDataList.add(self.footerData)
                }
                
            }else if _footerDataList.count > self.multiCellDataList.count{
                while _footerDataList.count > self.multiCellDataList.count {
                    _footerDataList.removeLastObject()
                }
            }
            
            
            return _footerDataList
        }
    }
    
    var decorationViewClassList: NSMutableArray {
        
        set{
            _decorationViewClassList = newValue
        }
        
        get{
            if _decorationViewClassList.count < self.multiCellDataList.count {
                while _decorationViewClassList.count < self.multiCellDataList.count {
                    _decorationViewClassList.add(self.decorationViewClass)
                }
            }else if _decorationViewClassList.count > self.multiCellDataList.count {
                while _decorationViewClassList.count > self.multiCellDataList.count {
                    _decorationViewClassList.remove(self.decorationViewClass)
                }
            }
            return _decorationViewClassList
        }
        
        
    }

    
    func xw_reloadWidget() {
        
        if let cv: UICollectionView = self.collectionView {
            cv.xw_reloadWidgets()
        }

    }
    
    func requestHeaderRefresh()  {
        
        self.requestFinishWithState(state: XWWidgetState.XWWidgetStateRequestSuccess)
    }
    
    func requestFooterRefresh() {
        
        self.requestFinishWithState(state: XWWidgetState.XWWidgetStateRequestSuccess)
        
    }
    
    func requestSuccess()  {
        
        self.requestFinishWithState(state: XWWidgetState.XWWidgetStateRequestSuccess)
    }
    
    func requestFail()  {
        
        self.requestFinishWithState(state: XWWidgetState.XWWidgetStateRequestFail)
    }
    
    func requestNetWorkError()  {
        
        self.requestFinishWithState(state: XWWidgetState.XWWidgetStateNetWorkError)
    }
    
    func requestNoMoreData()  {
        
        self.requestFinishWithState(state: XWWidgetState.XWWidgetStateRequestNoMoreData)
    }
    
    func requestFinishWithState(state: XWWidgetState)  {
        
        self.needRequest = false
        self.state = state
        self.collectionView?.xw_requestFinish()
    }

    

}
