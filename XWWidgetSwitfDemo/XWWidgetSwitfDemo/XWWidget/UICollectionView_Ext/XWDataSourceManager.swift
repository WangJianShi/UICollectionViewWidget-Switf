//
//  XWDataSourceManager.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/6.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit


class XWDataSourceManager: NSObject{
    
   weak var dataSource: XWCollectionViewDataSource?
    
   lazy var cacheReusables: NSMutableArray = {
        
        let list: NSMutableArray = NSMutableArray.init()
        return list
    }()
    
    lazy var cacheReusableClassDic: NSMutableDictionary = {
        
        let dic: NSMutableDictionary = NSMutableDictionary()
        return dic
    }()
    
    //mark -- 数据源管理
    
    func cellDataList(collectionView: UICollectionView) -> NSArray {
        
        if let source: XWCollectionViewDataSource = self.dataSource {
            
            let dataList: NSArray = source.cellDataListWithCollectionView(collectionView: collectionView)
            return dataList
        }
        return NSArray()
    }
    
    func headerDataList(collectionView: UICollectionView) -> NSArray {
        
        if let source: XWCollectionViewDataSource = self.dataSource {
            
            if let dataList: NSArray = source.headerDataListWithCollectionView?(collectionView: collectionView) {
                
                return dataList
            }
        }
        return NSArray()
        
    }
    
    func footerDataList(collectionView: UICollectionView) -> NSArray {
        
        if let source: XWCollectionViewDataSource = self.dataSource {
            
            if let dataList: NSArray = source.footerDataListWithCollectionView?(collectionView: collectionView) {
                
                return dataList
            }
        }
        return NSArray()
    }
    
    func decorationViewClassList(collectionView: UICollectionView) -> NSArray {
        
        if let source: XWCollectionViewDataSource = self.dataSource {
            
            if let dataList: NSArray = source.decorationViewClassListWithCollectionView?(collectionView: collectionView) {
                
                return dataList
            }
        }
        return NSArray()
    
    }
    
    func getSecionDataListWithSection(section: Int,collectionView: UICollectionView) -> NSArray {
        
        let cellList: NSArray = self.cellDataList(collectionView: collectionView)
        if section == 0 && cellList.count > 0 {
            //MARK: - 当cell数据源返回的是一重数组时当作第一一个section处理
            if let firstObjc: NSObject = cellList[0] as? NSObject,!firstObjc.isKind(of: NSArray.self) {
                return cellList
            }
        }
        if section < cellList.count,let sectionArry: NSArray = cellList[section] as? NSArray {
            
            return sectionArry
        }
        return NSArray()
    }
    
    func getCellDataWithIndexPath(indexPath: IndexPath,collectionView: UICollectionView) -> NSObject? {
        
        let sectionDataList : NSArray = self.getSecionDataListWithSection(section: indexPath.section,collectionView: collectionView) as NSArray
        
        if indexPath.row < sectionDataList.count {
            
            return sectionDataList[indexPath.row] as? NSObject
        }
        
        return nil
        
    }
    
    func getHeaderOrFooterDataWithKind(kind: String, indexPath: IndexPath,collectionView: UICollectionView) -> NSObject? {
        
        var list : NSArray!
        if kind == UICollectionElementKindSectionHeader {
            
            list = self.headerDataList(collectionView: collectionView)
        }else if kind == UICollectionElementKindSectionFooter {
            
            list = self.footerDataList(collectionView: collectionView)
        }
        
        if indexPath.section < list.count {
            
            return list[indexPath.section] as? NSObject
        }
        
        return nil
    }
    
    //MARK: - cell,ReusableView注册及缓存
    
    func registerCellClassIfNeedWithIdentifier(collectionView: UICollectionView,obj: NSObject,indexPath: IndexPath) -> String {
        
        if obj.xw_reuseIdentifier == nil
        {
            var identify: String = NSStringFromClass(obj.classForCoder).components(separatedBy: ".").last ?? "UICollectionViewCell"
            if identify.count > 4 {
                identify = (identify as NSString).substring(to: identify.count - 4) + "Cell"
            }
            obj.xw_reuseIdentifier = self.classFromString(className: identify) == nil ? "UICollectionViewCell" : identify
        }
        var identify: String = obj.xw_reuseIdentifier!
        if !obj.xw_reusable
        {
           identify = identify + "\(indexPath.section)" + "\(indexPath.row)"
        }
        guard self.cacheReusables.contains(identify) else
        {
            if let cellClass: AnyClass = self.classFromString(className: obj.xw_reuseIdentifier!)
            {
                collectionView.register(cellClass, forCellWithReuseIdentifier: identify)
                self.cacheReusables.add(identify)
                if let classType = cellClass as? UIView.Type {
                    self.cacheReusableClassDic.setValue(classType.init(), forKey: identify)
                }
            }
            return identify
        };
        
        return identify
    }
    
    func registerReusableViewClassIfNeedWithIdentifier(collectionView: UICollectionView, kind: String, obj: NSObject,indexPath: IndexPath) -> String {
        
        if obj.xw_reuseIdentifier == nil
        {
            var identify: String = NSStringFromClass(obj.classForCoder).components(separatedBy: ".").last ?? "UICollectionReusableView"
            if identify.count > 4
            {
                identify = (identify as NSString).substring(to: identify.count - 4) + "View"
            }
            obj.xw_reuseIdentifier = self.classFromString(className: identify) == nil ? "UICollectionReusableView" : identify
        }
        
        var identify: String = obj.xw_reuseIdentifier ?? "UICollectionReusableView" + kind
        if !obj.xw_reusable
        {
            identify = identify + "\(indexPath.section)"
        }
        guard self.cacheReusables.contains(identify) else
        {
            if let cellClass: AnyClass = self.classFromString(className: obj.xw_reuseIdentifier ?? "UICollectionReusableView")
            {
                collectionView.register(cellClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: identify)
                self.cacheReusables.add(identify)
                if let classType = cellClass as? UIView.Type {
                    self.cacheReusableClassDic.setValue(classType.init(), forKey: identify)
                }
            }
            return identify
        };
        
        return identify
    }
    
    func getStaticCellWithIdentifier(collectionView: UICollectionView,obj: NSObject,indexPath: IndexPath) -> UICollectionViewCell? {
        
        let identify: String = self.registerCellClassIfNeedWithIdentifier(collectionView: collectionView, obj: obj, indexPath: indexPath)
        if let cell: UICollectionViewCell = self.cacheReusableClassDic[identify] as? UICollectionViewCell {
            return cell
        }
        return nil
    }
    
    func getStaticReusableViewWithIdentifier(collectionView: UICollectionView, kind: String, obj: NSObject,indexPath: IndexPath) -> UICollectionReusableView? {
        
        let identify: String = self.registerReusableViewClassIfNeedWithIdentifier(collectionView: collectionView, kind: kind, obj: obj, indexPath: indexPath)
        if let view: UICollectionReusableView = self.cacheReusableClassDic[identify] as? UICollectionReusableView {
           
            return view
        }
        return nil
    }
    
    func classFromString(className: String) -> AnyClass? {
        
        if className == "UICollectionReusableView"
        {
            return UICollectionReusableView.self
        }
        
        if className == "UICollectionViewCell"
        {
            return UICollectionViewCell.self
        }
        
        let namespace : String = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
        
        let cls : AnyClass? = NSClassFromString(namespace + "." + className)
        
        return cls
        
    }
    

}

//MARK: - UICollectionViewDataSource

extension XWDataSourceManager: UICollectionViewDataSource {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        let headers: NSArray = self.headerDataList(collectionView: collectionView)
        if headers.count > 0 {
            return headers.count
        }
        let cellList : NSArray = self.cellDataList(collectionView: collectionView) as NSArray
        if cellList.count > 0, let firstObjc: NSObject = cellList[0] as? NSObject,!firstObjc.isKind(of: NSArray.self) {
            return 1
        }
        return cellList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.getSecionDataListWithSection(section: section,collectionView: collectionView).count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellData = self.getCellDataWithIndexPath(indexPath: indexPath ,collectionView: collectionView)
        if cellData != nil
        {
            let identify: String = self.registerCellClassIfNeedWithIdentifier(collectionView: collectionView, obj: cellData!, indexPath: indexPath)
            let cell : UICollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identify, for: indexPath)
            cell.xw_collectionView = collectionView
            cell.reuseWithData(data: cellData!, indexPath: indexPath)
            return cell
            
        }
        
        return collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let data = self.getHeaderOrFooterDataWithKind(kind: kind, indexPath: indexPath ,collectionView: collectionView)
        if data != nil
        {
            let reuseIdentifier: String = self.registerReusableViewClassIfNeedWithIdentifier(collectionView: collectionView, kind: kind, obj: data!, indexPath: indexPath)
            let view: UICollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
            view.xw_collectionView = collectionView
            view.reuseWithData(data: data!, indexPath: indexPath, isHeader: kind == UICollectionElementKindSectionHeader)
            return view
            
        }
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "UICollectionReusableView", for: indexPath)
        
    }
}

//MARK: - UICollectionViewDelegate

extension XWDataSourceManager: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
        let dataList = self.headerDataList(collectionView: collectionView)
        if section < dataList.count
        {
            if  let headerData: NSObject = dataList.object(at: section) as? NSObject
            {
                if headerData.xw_width == 0 && headerData.xw_height == 0
                {
                    let layout: UICollectionViewFlowLayout! = collectionView.collectionViewLayout as?  UICollectionViewFlowLayout
                    headerData.xw_width = layout.headerReferenceSize.width
                    headerData.xw_height = layout.headerReferenceSize.height
                }
                if headerData.xw_width == 0 || headerData.xw_height == 0
                {
                    if let view: UICollectionReusableView = self.getStaticReusableViewWithIdentifier(collectionView: collectionView, kind: UICollectionElementKindSectionHeader, obj: headerData, indexPath: IndexPath.init(row: 0, section: section)) {
                        view.xw_collectionView = collectionView
                        view.reuseWithData(data: headerData, indexPath: IndexPath.init(row: 0, section: section), isHeader: true)
                        let  size: CGSize = view.view_size()
                        headerData.xw_width = size.width
                        headerData.xw_height = size.height
                    }
                }
                return  CGSize(width: headerData.xw_width, height: headerData.xw_height)
            }
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let data  = self.getCellDataWithIndexPath(indexPath: indexPath as IndexPath,collectionView: collectionView)
        if let cellData: NSObject = data
        {
            if cellData.xw_width == 0 || cellData.xw_height == 0
            {

                if let cell: UICollectionViewCell = self.getStaticCellWithIdentifier(collectionView: collectionView, obj: cellData, indexPath: indexPath) {
                    cell.xw_collectionView = collectionView
                    cell.reuseWithData(data: cellData, indexPath: indexPath)
                    let  size: CGSize = cell.view_size()
                    cellData.xw_width = size.width
                    cellData.xw_height = size.height
                }
            }
            
            return CGSize(width: cellData.xw_width, height: cellData.xw_height)
        }
        return CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let dataList = self.footerDataList(collectionView: collectionView)
        if section < dataList.count
        {
            if  let footerData: NSObject = dataList.object(at: section) as? NSObject
            {
                if footerData.xw_width == 0 && footerData.xw_height == 0
                {
                    let layout: UICollectionViewFlowLayout! = collectionView.collectionViewLayout as?  UICollectionViewFlowLayout
                    footerData.xw_width = layout.footerReferenceSize.width
                    footerData.xw_height = layout.footerReferenceSize.height
                }
                if footerData.xw_width == 0 || footerData.xw_height == 0
                {
                    if let view: UICollectionReusableView = self.getStaticReusableViewWithIdentifier(collectionView: collectionView, kind: UICollectionElementKindSectionFooter, obj: footerData, indexPath: IndexPath.init(row: 0, section: section)) {
                        view.xw_collectionView = collectionView
                        view.reuseWithData(data: footerData, indexPath: IndexPath.init(row: 0, section: section), isHeader: true)
                        let  size: CGSize = view.view_size()
                        footerData.xw_width = size.width
                        footerData.xw_height = size.height
                    }
                }
                return  CGSize(width: footerData.xw_width, height: footerData.xw_height)
            }
        }
        return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var insets: UIEdgeInsets = UIEdgeInsets.zero
        //MARK: - 如果header有设置secionInset则优先
        let dataList = self.headerDataList(collectionView: collectionView)
        if section < dataList.count
        {
            if  let headerData: NSObject = dataList.object(at: section) as? NSObject
            {
                if !UIEdgeInsetsEqualToEdgeInsets(headerData.xw_secionInset, UIEdgeInsets.zero)
                {
                    insets = headerData.xw_secionInset
                }
            }
        }
         //MARK: - 如果header没有设置但footer设置了则footer优先
        if UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsets.zero)
        {
            let footerDataList = self.footerDataList(collectionView: collectionView)
            if  let footerData: NSObject = footerDataList.object(at: section) as? NSObject
            {
                if !UIEdgeInsetsEqualToEdgeInsets(footerData.xw_secionInset, UIEdgeInsets.zero)
                {
                    insets = footerData.xw_secionInset
                }
            }
        }
        //MARK: - 如果header,footer都没有设置，则取layout的
         if UIEdgeInsetsEqualToEdgeInsets(insets, UIEdgeInsets.zero)
         {
            if (collectionView.collectionViewLayout.isKind(of: UICollectionViewFlowLayout.self))
            {
                let layout: UICollectionViewFlowLayout! = collectionView.collectionViewLayout as?  UICollectionViewFlowLayout
                
               insets = layout.sectionInset
                
            }
         }
        return insets
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        var minimumLineSpacing: CGFloat = 0
        //MARK: - 如果header有设置minimumLineSpacing则优先
        let dataList = self.headerDataList(collectionView: collectionView)
        if section < dataList.count
        {
            if  let headerData: NSObject = dataList.object(at: section) as? NSObject
            {
                if headerData.xw_minimumLineSpacing != 0
                {
                    minimumLineSpacing = headerData.xw_minimumLineSpacing
                }
            }
        }
        //MARK: - 如果header没有设置但footer设置了则footer优先
        if minimumLineSpacing == 0
        {
            let footerDataList = self.footerDataList(collectionView: collectionView)
            if  let footerData: NSObject = footerDataList.object(at: section) as? NSObject
            {
                if footerData.xw_minimumLineSpacing != 0
                {
                    minimumLineSpacing = footerData.xw_minimumLineSpacing
                }
            }
        }
        //MARK: - 如果header,footer都没有设置，则取layout的
        if minimumLineSpacing == 0
        {
            if (collectionView.collectionViewLayout.isKind(of: UICollectionViewFlowLayout.self))
            {
                let layout: UICollectionViewFlowLayout! = collectionView.collectionViewLayout as?  UICollectionViewFlowLayout
                
                minimumLineSpacing = layout.minimumLineSpacing
                
            }
        }
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        var minimumInteritemSpacing: CGFloat = 0
        //MARK: - 如果header有设置minimumLineSpacing则优先
        let dataList = self.headerDataList(collectionView: collectionView)
        if section < dataList.count
        {
            if  let headerData: NSObject = dataList.object(at: section) as? NSObject
            {
                if headerData.xw_minimumLineSpacing != 0
                {
                    minimumInteritemSpacing = headerData.xw_minimumInteritemSpacing
                }
            }
        }
        //MARK: - 如果header没有设置但footer设置了则footer优先
        if minimumInteritemSpacing == 0
        {
            let footerDataList = self.footerDataList(collectionView: collectionView)
            if  let footerData: NSObject = footerDataList.object(at: section) as? NSObject
            {
                if footerData.xw_minimumLineSpacing != 0
                {
                    minimumInteritemSpacing = footerData.xw_minimumInteritemSpacing
                }
            }
        }
        //MARK: - 如果header,footer都没有设置，则取layout的
        if minimumInteritemSpacing == 0
        {
            if (collectionView.collectionViewLayout.isKind(of: UICollectionViewFlowLayout.self))
            {
                let layout: UICollectionViewFlowLayout! = collectionView.collectionViewLayout as?  UICollectionViewFlowLayout
                
                minimumInteritemSpacing = layout.minimumInteritemSpacing
                
            }
        }
        return minimumInteritemSpacing
    }
    

    //MARK: - delegate事件分发
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool{
        
        for i in 0..<collectionView.xw_delegates.count
        {
            if let delegate: UICollectionViewDelegate = collectionView.xw_delegates.object(at: i) as? UICollectionViewDelegate
            {
                if let value: Bool = delegate.collectionView?(collectionView, shouldHighlightItemAt: indexPath)
                {
                    return value
                }
            }
        }
        if let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)
        {
           return cell.xw_shouldHighlightCell()
        }
        
        return true
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath){
        
        for i in 0..<collectionView.xw_delegates.count
        {
            if let delegate: UICollectionViewDelegate = collectionView.xw_delegates.object(at: i) as? UICollectionViewDelegate
            {
               delegate.collectionView?(collectionView, didHighlightItemAt: indexPath)
            }
        }
        if let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)
        {
           cell.xw_didHighlightCell()
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath){
        
        for i in 0..<collectionView.xw_delegates.count
        {
            if let delegate: UICollectionViewDelegate = collectionView.xw_delegates.object(at: i) as? UICollectionViewDelegate
            {
                delegate.collectionView?(collectionView, didUnhighlightItemAt: indexPath)
            }
        }
        if let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)
        {
            cell.xw_didUnhighlightCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool{
        
        for i in 0..<collectionView.xw_delegates.count
        {
            if let delegate: UICollectionViewDelegate = collectionView.xw_delegates.object(at: i) as? UICollectionViewDelegate
            {
                if let value: Bool = delegate.collectionView?(collectionView, shouldSelectItemAt: indexPath)
                {
                    return value
                }
            }
        }
        if let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)
        {
            return cell.xw_shouldSelectCell()
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        
        for i in 0..<collectionView.xw_delegates.count
        {
            if let delegate: UICollectionViewDelegate = collectionView.xw_delegates.object(at: i) as? UICollectionViewDelegate
            {
                if let value: Bool = delegate.collectionView?(collectionView, shouldDeselectItemAt: indexPath)
                {
                    return value
                }
            }
        }
        if let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)
        {
            return cell.xw_shouldDeselectCell()
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for i in 0..<collectionView.xw_delegates.count
        {
            if let delegate: UICollectionViewDelegate = collectionView.xw_delegates.object(at: i) as? UICollectionViewDelegate
            {
                delegate.collectionView?(collectionView, didSelectItemAt: indexPath)
            }
        }
        if let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)
        {
            cell.xw_didSelectCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        for i in 0..<collectionView.xw_delegates.count
        {
            if let delegate: UICollectionViewDelegate = collectionView.xw_delegates.object(at: i) as? UICollectionViewDelegate
            {
                delegate.collectionView?(collectionView, didDeselectItemAt: indexPath)
            }
        }
        if let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)
        {
            cell.xw_didDeselectCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        for i in 0..<collectionView.xw_delegates.count
        {
            if let delegate: UICollectionViewDelegate = collectionView.xw_delegates.object(at: i) as? UICollectionViewDelegate
            {
                delegate.collectionView?(collectionView, willDisplay: cell, forItemAt: indexPath)
            }
        }
        if let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)
        {
            cell.xw_willDisplayCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        
        if elementKind == UICollectionElementKindSectionHeader
        {
            view.layer.zPosition = 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        for i in 0..<collectionView.xw_delegates.count
        {
            if let delegate: UICollectionViewDelegate = collectionView.xw_delegates.object(at: i) as? UICollectionViewDelegate
            {
                delegate.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
            }
        }
        if let cell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)
        {
            cell.xw_didEndDisplayCell()
        }
    }
    
    //TODO: - 其他代理方法待添加

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
        
    }
    
    //MARK: - UIScrollViewDelegate （UIScrollView滑动相关）
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewDidScroll?(scrollView)
                }
            }
        }
    }
    
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewDidScrollToTop?(scrollView)
                }
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewWillBeginDragging?(scrollView)
                }
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewDidEndDragging?(scrollView, willDecelerate: decelerate)
                }
            }
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewWillBeginDecelerating?(scrollView)
                }
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewDidEndDecelerating?(scrollView)
                }
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewDidEndScrollingAnimation?(scrollView)
                }
            }
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewDidZoom?(scrollView)
                }
            }
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewWillBeginZooming?(scrollView, with: view)
                }
            }
        }
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
       
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                    delegate.scrollViewDidEndZooming?(scrollView, with: view, atScale: scale)
                }
            }
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        
        if let cv: UICollectionView = scrollView as? UICollectionView
        {
            for i in 0..<cv.xw_delegates.count
            {
                if let delegate: UICollectionViewDelegate = cv.xw_delegates.object(at: i) as? UICollectionViewDelegate
                {
                   return delegate.scrollViewShouldScrollToTop?(scrollView) ?? true
                }
            }
        }
        
        return true
    }
    
}

