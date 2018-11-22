//
//  XWCollectionViewFlowLayout.swift
//  XWWidgetSwitfDemo
//  TODO:装饰视图
//  Created by 王剑石 on 2018/9/26.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

class XWCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    weak var delegate: UICollectionViewDelegateFlowLayout? {
        
        get {
            return self.collectionView?.dataSource as? UICollectionViewDelegateFlowLayout
        }
    }
    
    var verticalDir: Bool{
        get{
            return self.scrollDirection == .vertical
        }
    }

    var decroationViewAttsArray: [UICollectionViewLayoutAttributes]?
    
    var numOfSection: Int = 0
    
    override func prepare() {
        
        super.prepare()
        numOfSection = getNumOfSection()
        decroationViewAttsArray = nil
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let arrayRect = self.xw_layoutAttributesForElements(in: rect)
        
        if self.getDecroationViewAttsArray() != nil && arrayRect != nil {
            
            let array: NSMutableArray = NSMutableArray.init(array: arrayRect!)
            
            for attr in self.decroationViewAttsArray! {
                
                array.add(attr)
            }
            
            return array as? [UICollectionViewLayoutAttributes]
            
        }
        
        return arrayRect
        
    }
    
    //MARK: - 默认返回super.layoutAttributesForElements(in: rect)
    func xw_layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return super.layoutAttributesForElements(in: rect)
    }
    
    func getDecroationViewAttsArray() -> [UICollectionViewLayoutAttributes]? {
        
        if self.decroationViewAttsArray == nil {
            
            self.decroationViewAttsArray = [UICollectionViewLayoutAttributes]()
            let sections:Int   = numOfSection
            for i  in 0 ..< sections {
                
                let first = self.firstAttributeWithSection(section: i)
                
                let last = self.lastAttributeWithSection(section: i)
                
                let decorationViewAtt = self.getDecorationViewAttributesWithSection(section: i, firstAttr: first, lastAttr: last)
                
                if decorationViewAtt != nil {
                    
                    self.decroationViewAttsArray?.append(decorationViewAtt!)
                }
            }
        }
        
        return self.decroationViewAttsArray
    }
    
    
    func getNumOfSection() -> Int {
        
        return self.collectionView?.numberOfSections ?? 0
    }
    
    func numOfItemInSection(section: Int) -> Int {
        
        if section < getNumOfSection() {
            
            if let num = self.collectionView?.dataSource?.collectionView(self.collectionView!, numberOfItemsInSection: section) {
                return num
            }
        }
        return 0
        
    }
    
    func  headerSizeWithSection(section: Int) -> CGSize {
        
        if let size = self.delegate?.collectionView?(self.collectionView!, layout: self, referenceSizeForHeaderInSection: section) {
            
            return size
        }
        
        return self.headerReferenceSize
    }
    
    func  footerSizeWithSection(section: Int) -> CGSize {
        
        if let size = self.delegate?.collectionView?(self.collectionView!, layout: self, referenceSizeForFooterInSection: section) {
            
            return size
        }
        
        return self.footerReferenceSize
    }
    func minimumLineSpacingWithSection(section: Int) -> CGFloat {
        
        if let min = self.delegate?.collectionView?(self.collectionView!, layout: self, minimumLineSpacingForSectionAt: section)  {
            
            return min
        }
        
        return self.minimumLineSpacing
    }
    
    func minimumInteritemSpacingWithSection(section: Int) -> CGFloat {
        
        if let min = self.delegate?.collectionView?(self.collectionView!, layout: self, minimumInteritemSpacingForSectionAt: section) {
            
            return min
        }
        
        return self.minimumInteritemSpacing
    }
    
    func itemSizeWithSection(section: Int,row: Int) ->CGSize {
        
        if let size = self.delegate?.collectionView?(self.collectionView!, layout: self, sizeForItemAt: IndexPath.init(row: row, section: section))  {
            
            return size
        }
        
        return self.itemSize
    }
    
    func sectionInsetWithSecion(section: Int) ->UIEdgeInsets {
        
        if let insert = self.delegate?.collectionView?(self.collectionView!, layout: self, insetForSectionAt: section)  {
            
            return insert
        }
        
        return self.sectionInset
    }
    
    
    func firstAttributeWithSection(section: Int) -> UICollectionViewLayoutAttributes? {
        
        let size = self.headerSizeWithSection(section: section)
        var first: UICollectionViewLayoutAttributes?
        if size.width > 0.01 && size.height > 0.01 {
            
            first = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: IndexPath.init(row: 0, section: section))
            
        }else {
            
            if self.numOfItemInSection(section: section) > 0 {
                
                first = self.layoutAttributesForItem(at: IndexPath.init(row: 0, section: section))
            }
        }
        
        return first
        
    }
    
    func lastAttributeWithSection(section: Int) -> UICollectionViewLayoutAttributes?  {
        let size = self.footerSizeWithSection(section: section)
        var last: UICollectionViewLayoutAttributes?
        if size.width > 0.01 && size.height > 0.01 {
            
            last = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionFooter, at: IndexPath.init(row: 0, section: section))
        }else {
            
            let num = self.numOfItemInSection(section: section)
            if num > 1 {
                
                last = self.layoutAttributesForItem(at: IndexPath.init(row: num - 1, section: section))
            }
        }
        
        return last
        
    }
    
    func getDecorationViewAttributesWithSection(section: Int, firstAttr: UICollectionViewLayoutAttributes? , lastAttr: UICollectionViewLayoutAttributes?) -> UICollectionViewLayoutAttributes? {
        
        var firstAtt = firstAttr
        let lastAtt = lastAttr
        
        if firstAtt == nil {
            firstAtt = lastAtt
        }
        
        let cla: AnyClass? = self.getDecorationViewClassWithSecion(section: section)
        
        if cla != nil && firstAtt != nil {
            
            self.register(cla, forDecorationViewOfKind: NSStringFromClass(cla!))
            
            let att = UICollectionViewLayoutAttributes.init(forDecorationViewOfKind: NSStringFromClass(cla!), with: IndexPath.init(row: 0, section: section))
            let insets: UIEdgeInsets = self.sectionInsetWithSecion(section: section)
            
            if verticalDir {
                
                var minY: CGFloat = firstAtt!.frame.minY
                if firstAtt?.representedElementCategory == .cell {
                    minY -= insets.top
                }
                var maxY: CGFloat = lastAtt!.frame.maxY
                if lastAtt?.representedElementCategory == .cell {

                    maxY += insets.bottom
                }
                let height = maxY - minY
                att.frame = CGRect(x: 0, y: minY, width:self.collectionView!.frame.size.width, height: height)
                
            }else {
                
                var minX: CGFloat = firstAtt!.frame.minX
                if firstAtt?.representedElementCategory == .cell {
                    
                    minX -= insets.left
                }
                var maxX: CGFloat = lastAtt!.frame.maxX
                if lastAtt?.representedElementCategory == .cell {
                    
                    maxX += insets.right
                }
                
                let width = maxX - minX
                att.frame = CGRect(x: minX, y: 0, width: width, height: self.collectionView!.frame.size.height)
                
            }
            
            att.zIndex = -1
            
            return att
            
        }
        
        
        return nil
    }
    
    func getDecorationViewClassWithSecion(section: Int) -> AnyClass? {
        
        if let collectionView = self.collectionView {
            
            if let decorations = collectionView.xw_dataSource?.decorationViewClassListWithCollectionView?(collectionView: collectionView){
                
                if decorations.count > section {
                    
                    return decorations[section] as? AnyClass
                }
            }
        }
        
        return nil
    }
    
}
