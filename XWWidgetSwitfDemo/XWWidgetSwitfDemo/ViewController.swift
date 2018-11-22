//
//  ViewController.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/8/16.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class ViewController: UIViewController,XWCollectionViewDataSource,UICollectionViewDelegate {
    
    lazy var cv: UICollectionView = {
        
        let collectionView: UICollectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.xw_delegates.add(self)
        collectionView.xw_dataSource = self
        return collectionView
    }()
    
    lazy var cells: NSMutableArray = {
        
        let list: NSMutableArray = NSMutableArray()
        return list
    }()
    
    lazy var headers: NSMutableArray = {
        
        let list: NSMutableArray = NSMutableArray()
        return list
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.view.addSubview(self.cv)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    func initData() {
        
        self.headers.add(XWTestHeaderData())
        
        let cell1s: NSMutableArray = NSMutableArray()
        for i in 0 ... 40 {
            
            let testData: XWTestData = XWTestData()
            testData.title =  "很不错，这是自动算高度的，你也来试试啊，看准不准确啊，哈哈哈哈啊哈哈很不错，这是自动算高度的，你也来试试啊，看准不准确啊，哈哈哈哈啊哈哈很不错，这是自动算高度的，你也来试试啊"
            cell1s.add(testData)
            if i == 4 {
                cell1s.add(XWUnReseableData())
            }
            
            if i == 30 {
                cell1s.add(XWUnReseableData())
            }
        }
        self.cells.add(cell1s)
        
        self.headers.add(XWTestHeaderData())
        
        let cell2s: NSMutableArray = NSMutableArray()
        cell2s.add(XWUnReseableData())
        for i in 0 ... 20 {
            
            let testData: XWTestData = XWTestData()
            testData.title =  "我比你高哦，哈哈，我也是自动算高度的，黑河的我到单位的味道我的味道我的我，我比你高哦，哈哈，我也是自动算高度的，黑河的我到单位的味道我的味道我的我，哈啊哈哈哈哈哈哈哈哈我比你高哦，哈哈，我也是自动算高度的，黑河的我到单位的味道我的味道我的我，哈啊哈哈哈哈哈哈哈哈我比你高哦，哈哈，我也是自动算高度的，黑河的我到单位的味道我的味道我的我，哈啊哈哈哈哈哈哈哈哈哈啊哈哈哈哈哈哈哈哈"
            cell2s.add(testData)
            
            if i == 15 {
                cell2s.add(XWUnReseableData())
            }
        }
        self.cells.add(cell2s)
    }
    
    //MARK: - dataSource
    
    func headerDataListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray {
        
        return self.headers
    }
    
    func cellDataListWithCollectionView(collectionView: UICollectionView) -> NSMutableArray {
        
        return self.cells
    }
    
    //MARK: - delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.present(XWTestViewController(), animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

