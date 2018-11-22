//
//  XWAlignedFlowLayout.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/11/7.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

protocol XWAlignment {}

public enum XWHorizontalAlignment: XWAlignment {
    case left
    case justified
    case right
}

public enum XWVerticalAlignment: XWAlignment {
    case top
    case center
    case bottom
}

private struct XWAlignmentAxis<A: XWAlignment> {
    let alignment: A
    let position: CGFloat
}

class XWAlignedFlowLayout: UICollectionViewFlowLayout {
    
    public var horizontalAlignment: XWHorizontalAlignment = .left
    
    public var verticalAlignment: XWVerticalAlignment = .center
    
    fileprivate var alignmentAxis: XWAlignmentAxis<XWHorizontalAlignment>? {
        switch horizontalAlignment {
        case .left:
            return XWAlignmentAxis(alignment: XWHorizontalAlignment.left, position: sectionInset.left)
        case .right:
            guard let collectionViewWidth = collectionView?.frame.size.width else {
                return nil
            }
            return XWAlignmentAxis(alignment: XWHorizontalAlignment.right, position: collectionViewWidth - sectionInset.right)
        default:
            return nil
        }
    }
    
    private var contentWidth: CGFloat? {
        guard let collectionViewWidth = collectionView?.frame.size.width else {
            return nil
        }
        return collectionViewWidth - sectionInset.left - sectionInset.right
    }
    
    public init(horizontalAlignment: XWHorizontalAlignment = .justified, verticalAlignment: XWVerticalAlignment = .center) {
        super.init()
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        if horizontalAlignment != .justified {
            layoutAttributes.alignHorizontally(collectionViewLayout: self)
        }
        
        if verticalAlignment != .center {
            layoutAttributes.alignVertically(collectionViewLayout: self)
        }
        
        return layoutAttributes
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = copy(super.layoutAttributesForElements(in: rect))
        layoutAttributesObjects?.forEach({ (layoutAttributes) in
            setFrame(forLayoutAttributes: layoutAttributes)
        })
        return layoutAttributesObjects
    }
    
    private func setFrame(forLayoutAttributes layoutAttributes: UICollectionViewLayoutAttributes) {
        if layoutAttributes.representedElementCategory == .cell {
            let indexPath = layoutAttributes.indexPath
            if let newFrame = layoutAttributesForItem(at: indexPath)?.frame {
                layoutAttributes.frame = newFrame
            }
        }
    }
    
    fileprivate func originalLayoutAttribute(forItemAt indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForItem(at: indexPath)
    }
    
    fileprivate func isFrame(for firstItemAttributes: UICollectionViewLayoutAttributes, inSameLineAsFrameFor secondItemAttributes: UICollectionViewLayoutAttributes) -> Bool {
        guard let lineWidth = contentWidth else {
            return false
        }
        let firstItemFrame = firstItemAttributes.frame
        let lineFrame = CGRect(x: sectionInset.left,
                               y: firstItemFrame.origin.y,
                               width: lineWidth,
                               height: firstItemFrame.size.height)
        return lineFrame.intersects(secondItemAttributes.frame)
    }
    
    fileprivate func layoutAttributes(forItemsInLineWith layoutAttributes: UICollectionViewLayoutAttributes) -> [UICollectionViewLayoutAttributes] {
        guard let lineWidth = contentWidth else {
            return [layoutAttributes]
        }
        var lineFrame = layoutAttributes.frame
        lineFrame.origin.x = sectionInset.left
        lineFrame.size.width = lineWidth
        return super.layoutAttributesForElements(in: lineFrame) ?? []
    }
    
    private func verticalAlignmentAxisForLine(with layoutAttributes: [UICollectionViewLayoutAttributes]) -> XWAlignmentAxis<XWVerticalAlignment>? {
        
        guard let firstAttribute = layoutAttributes.first else {
            return nil
        }
        
        switch verticalAlignment {
        case .top:
            let minY = layoutAttributes.reduce(CGFloat.greatestFiniteMagnitude) { min($0, $1.frame.minY) }
            return XWAlignmentAxis(alignment: .top, position: minY)
            
        case .bottom:
            let maxY = layoutAttributes.reduce(0) { max($0, $1.frame.maxY) }
            return XWAlignmentAxis(alignment: .bottom, position: maxY)
            
        default:
            let centerY = firstAttribute.center.y
            return XWAlignmentAxis(alignment: .center, position: centerY)
        }
    }
    
    fileprivate func verticalAlignmentAxis(for currentLayoutAttributes: UICollectionViewLayoutAttributes) -> XWAlignmentAxis<XWVerticalAlignment> {
        let layoutAttributesInLine = layoutAttributes(forItemsInLineWith: currentLayoutAttributes)
        return verticalAlignmentAxisForLine(with: layoutAttributesInLine)!
    }
    
    private func copy(_ layoutAttributesArray: [UICollectionViewLayoutAttributes]?) -> [UICollectionViewLayoutAttributes]? {
        return layoutAttributesArray?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
    }
    
}

fileprivate extension UICollectionViewLayoutAttributes {
    
    private var currentSection: Int {
        return indexPath.section
    }
    
    private var currentItem: Int {
        return indexPath.item
    }
    
    private var precedingIndexPath: IndexPath {
        return IndexPath(item: currentItem - 1, section: currentSection)
    }
    
    private var followingIndexPath: IndexPath {
        return IndexPath(item: currentItem + 1, section: currentSection)
    }
    
    func isRepresentingFirstItemInLine(collectionViewLayout: XWAlignedFlowLayout) -> Bool {
        if currentItem <= 0 {
            return true
        }
        else {
            if let layoutAttributesForPrecedingItem = collectionViewLayout.originalLayoutAttribute(forItemAt: precedingIndexPath) {
                return !collectionViewLayout.isFrame(for: self, inSameLineAsFrameFor: layoutAttributesForPrecedingItem)
            }
            else {
                return true
            }
        }
    }
    
    func isRepresentingLastItemInLine(collectionViewLayout: XWAlignedFlowLayout) -> Bool {
        guard let itemCount = collectionViewLayout.collectionView?.numberOfItems(inSection: currentSection) else {
            return false
        }
        
        if currentItem >= itemCount - 1 {
            return true
        }
        else {
            if let layoutAttributesForFollowingItem = collectionViewLayout.originalLayoutAttribute(forItemAt: followingIndexPath) {
                return !collectionViewLayout.isFrame(for: self, inSameLineAsFrameFor: layoutAttributesForFollowingItem)
            }
            else {
                return true
            }
        }
    }
    
    func align(toAlignmentAxis alignmentAxis: XWAlignmentAxis<XWHorizontalAlignment>) {
        switch alignmentAxis.alignment {
        case .left:
            frame.origin.x = alignmentAxis.position
        case .right:
            frame.origin.x = alignmentAxis.position - frame.size.width
        default:
            break
        }
    }
    
    func align(toAlignmentAxis alignmentAxis: XWAlignmentAxis<XWVerticalAlignment>) {
        switch alignmentAxis.alignment {
        case .top:
            frame.origin.y = alignmentAxis.position
        case .bottom:
            frame.origin.y = alignmentAxis.position - frame.size.height
        default:
            center.y = alignmentAxis.position
        }
    }
    
    private func alignToPrecedingItem(collectionViewLayout: XWAlignedFlowLayout) {
        let itemSpacing = collectionViewLayout.minimumInteritemSpacing
        
        if let precedingItemAttributes = collectionViewLayout.layoutAttributesForItem(at: precedingIndexPath) {
            frame.origin.x = precedingItemAttributes.frame.maxX + itemSpacing
        }
    }
    
    private func alignToFollowingItem(collectionViewLayout: XWAlignedFlowLayout) {
        let itemSpacing = collectionViewLayout.minimumInteritemSpacing
        
        if let followingItemAttributes = collectionViewLayout.layoutAttributesForItem(at: followingIndexPath) {
            frame.origin.x = followingItemAttributes.frame.minX - itemSpacing - frame.size.width
        }
    }
    
    func alignHorizontally(collectionViewLayout: XWAlignedFlowLayout) {
        
        guard let alignmentAxis = collectionViewLayout.alignmentAxis else {
            return
        }
        
        switch collectionViewLayout.horizontalAlignment {
            
        case .left:
            if isRepresentingFirstItemInLine(collectionViewLayout: collectionViewLayout) {
                align(toAlignmentAxis: alignmentAxis)
            } else {
                alignToPrecedingItem(collectionViewLayout: collectionViewLayout)
            }
            
        case .right:
            if isRepresentingLastItemInLine(collectionViewLayout: collectionViewLayout) {
                align(toAlignmentAxis: alignmentAxis)
            } else {
                alignToFollowingItem(collectionViewLayout: collectionViewLayout)
            }
            
        default:
            return
        }
    }
    
    func alignVertically(collectionViewLayout: XWAlignedFlowLayout) {
        let alignmentAxis = collectionViewLayout.verticalAlignmentAxis(for: self)
        align(toAlignmentAxis: alignmentAxis)
    }
    
}
