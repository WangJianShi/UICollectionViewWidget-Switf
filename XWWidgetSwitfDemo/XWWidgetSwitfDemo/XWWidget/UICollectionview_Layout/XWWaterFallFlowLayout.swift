//
//  XWWaterFallFlowLayout.swift
//  XWWidgetSwitfDemo
//  TODO: 瀑布流（兼容装饰视图）
//  Created by 王剑石 on 2018/11/6.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

class XWWaterFallFlowLayout: XWCollectionViewFlowLayout {
    
    var contentSize: CGSize = CGSize.zero
    
    var offset: CGPoint = CGPoint.zero
    
    var rect: CGRect = CGRect.zero
    
    var attributesArray: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        self.prepareLayoutForWaterfallType()
       
    }
    
    override var collectionViewContentSize: CGSize {
        
        return CGSize(width:self.contentSize.width, height:self.contentSize.height)
    }
    
    override func xw_layoutAttributesForElements( in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        self.rect = rect
        if self.attributesArray.count > 0 {
            
            let list: [UICollectionViewLayoutAttributes] = self.getAttributesInRectWithArray(array: self.attributesArray, from: 0, to: self.attributesArray.count - 1)
            
            return list
        }
        
        return nil
    }
    
    func prepareLayoutForWaterfallType()  {
        
        if self.collectionView?.frame.size.width == 0 {
            
            self.collectionView?.layoutIfNeeded()
        }
        attributesArray.removeAll()
        self.offset = CGPoint.zero
        self.decroationViewAttsArray = [UICollectionViewLayoutAttributes]()
        for i in 0 ..< self.numOfSection {
            let attrs: [UICollectionViewLayoutAttributes] = self.getAttributesWithSection(section: i, fromOffset: self.offset)
            let decorationViewAtt = self.getDecorationViewAttributesWithSection(section: i, firstAttr: attrs.first, lastAttr: attrs.last)
            if decorationViewAtt != nil {
                self.decroationViewAttsArray?.append(decorationViewAtt!)
            }
            attributesArray.append(contentsOf: attrs)
        }
        if self.verticalDir  {
            
            self.contentSize = CGSize(width: (self.collectionView?.frame.size.width)!, height: self.offset.y)
        }else{
            
            self.contentSize = CGSize(width: self.offset.x, height: (self.collectionView?.frame.size.height)! - 1)
        }
        
    }
    
    func getAttributesWithSection(section: Int, fromOffset: CGPoint) ->  [UICollectionViewLayoutAttributes]{
        
        var attributesList: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        if self.verticalDir  {

            //头部
            let headerSize = self.headerSizeWithSection(section: section)
            if headerSize.height > 0 {
                let arrtibute = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath.init(row: 0, section: section))
                arrtibute.frame = CGRect(x: 0, y: self.offset.y,width: headerSize.width, height: headerSize.height)
                attributesList.append(arrtibute)
            }
            //cells
            let cellAttrs: [UICollectionViewLayoutAttributes] = self.getCellsAttributesForVerticalWithSection(section: section, fromOffset: self.offset)
            attributesList.append(contentsOf: cellAttrs)
            //尾部
            let footerSize = self.footerSizeWithSection(section: section)
            if footerSize.height > 0 {
                let arrtibute = UICollectionViewLayoutAttributes.init(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, with: IndexPath.init(row: 0, section: section))
                arrtibute.frame = CGRect(x: 0, y: self.offset.y - footerSize.height, width: footerSize.width , height: footerSize.height)
                attributesList.append(arrtibute)
                
            }
            
        }
        
        return attributesList
    }
    
    func getCellsAttributesForVerticalWithSection(section: Int, fromOffset: CGPoint) -> [UICollectionViewLayoutAttributes] {
        
        let lineSpace: CGFloat = self.minimumLineSpacingWithSection(section: section)
        var itemSpace: CGFloat = self.minimumInteritemSpacingWithSection(section: section)
        let insert: UIEdgeInsets = self.sectionInsetWithSecion(section: section)
        let headerSize = self.headerSizeWithSection(section: section)
        let footerSize = self.footerSizeWithSection(section: section)
        let count: Int = self.numOfItemInSection(section: section)
        var array: [UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
        
        if count > 0 {
            
            var itSize = self.itemSizeWithSection(section: section, row: 0)
            let width = (self.collectionView?.frame.size.width)! - insert.left - insert.right
            let rows: Int = Int((width + itemSpace) / (itSize.width + itemSpace))
            if rows > 0 {
                if rows - 1  > 0 {
                    itemSpace = (width - itSize.width * CGFloat(rows)) / CGFloat(rows - 1)
                }else{
                    itemSpace = (width - itSize.width) / CGFloat(rows)
                }
                let offsetX = (rows == 1) ? (insert.left + itemSpace) : insert.left
                let initValue = self.offset.y + headerSize.height + insert.top - lineSpace
                var heightArray = self.createArrayWithSize(size: rows, initValue: Int(initValue))
                for i in 0 ..< count {
                    
                    itSize = self.itemSizeWithSection(section: section, row: i)
                    let addHeight = itSize.height + lineSpace
                    let row  = self.minHeightInRowWithArray(array: heightArray)
                    let rowHeight =  heightArray[row]
                    
                    let newHeight: CGFloat = heightArray[row]  + addHeight
                    heightArray[row] = newHeight
                    
                    let arrtibute = UICollectionViewLayoutAttributes.init(forCellWith: IndexPath.init(row: i, section: section) )
                    let x  = offsetX + (CGFloat(row) * (itSize.width + itemSpace))
                    
                    arrtibute.frame = CGRect(x: x, y: rowHeight + lineSpace , width: itSize.width, height: itSize.height)
                    array.append(arrtibute)
                }
                self.offset.y = CGFloat(self.maxHeightInArray(array: heightArray)) + insert.bottom + footerSize.height
                
            }
            
        }else{
            
            self.offset.y = self.offset.y + headerSize.height + footerSize.height + insert.top + insert.bottom
        }
        
        return array
    }
    
    func getAttributesInRectWithArray(array: [UICollectionViewLayoutAttributes], from: Int, to : Int) -> [UICollectionViewLayoutAttributes] {
        
        let fromAtt: UICollectionViewLayoutAttributes = array[from]
        let toAtt: UICollectionViewLayoutAttributes = array[to]
        
        if !self.isContainRectWithLeftAttribute(left: fromAtt, right: toAtt) {
            return [UICollectionViewLayoutAttributes]()
        }
        if fromAtt == toAtt {
            
            return [fromAtt]
        }
        let divide = (from + to) / 2
        let leftArray = self.getAttributesInRectWithArray(array: array, from: from, to: divide)
        let rightArray  = self.getAttributesInRectWithArray(array: array, from: divide + 1, to: to)
        var result = leftArray
        if result.count > 0 {
            if  rightArray.count > 0{
                result.append(contentsOf: rightArray)
            }
        }else{
            result = rightArray
        }
        return result
        
    }
    
    func isContainRectWithLeftAttribute(left: UICollectionViewLayoutAttributes, right: UICollectionViewLayoutAttributes) -> Bool {
        
        if self.verticalDir {
            let top  = left.frame.origin.y
            let bottom = right.frame.origin.y + right.frame.size.height
            if self.rect.origin.y > bottom || (self.rect.origin.y + self.rect.size.height < top) {
                return false
            }else{
                return true
            }
        }else{
            
            return false
        }
    }
    
    func createArrayWithSize(size: Int, initValue: Int) -> [CGFloat] {
        
        var array = [CGFloat]()
        for _ in 0 ..< size {
            array.append(CGFloat(initValue))
        }
        
        func creat() {
            
            
        }
        
        creat()
        return array
        
    }
    
    func minHeightInRowWithArray(array: [CGFloat]) -> Int  {
        
        var minIndex = 0
        for  i in 1 ..< array.count {
            
            let num: CGFloat = array[i]
            let minNum: CGFloat = array[minIndex]
            if minNum > num {
                
                minIndex = i
            }
            
        }
        return minIndex
        
    }
    
    func maxHeightInRowWithArray(array: [CGFloat]) -> Int  {
        
        var maxIndex = 0
        for  i in 1 ..< array.count {
            
            let num: CGFloat =  array[i]
            let maxNum: CGFloat = array[maxIndex]
            if maxNum < num {
                
                maxIndex = i
            }
        }
        return maxIndex
        
    }
    
    func maxHeightInArray(array: [CGFloat]) -> Float {
        
        let index = self.maxHeightInRowWithArray(array: array)
        let num: CGFloat = array[index]
        return Float(num)
        
    }
    
}
