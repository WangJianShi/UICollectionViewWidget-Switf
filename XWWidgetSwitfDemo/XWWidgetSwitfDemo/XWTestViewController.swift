//
//  XWTestViewController.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/10.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit

class XWTestViewController: UIViewController,XWCollectionViewDataSource,UICollectionViewDelegate  {

    lazy var cv: UICollectionView = {
        
        let collectionView: UICollectionView = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: XWWaterFallFlowLayout())
        collectionView.backgroundColor = UIColor.white
        collectionView.xw_delegates.add(self)
//        collectionView.xw_dataSource = self
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
        self.cv.xw_addWidget(widget: XWTestWidget.init(col: 2))
        self.cv.xw_addWidget(widget: XWTestWidget.init(col: 3))
        self.cv.xw_addWidget(widget: XWTestWidget.init(col: 1))
        self.cv.xw_addWidget(widget: XWTestWidget.init(col: 4))
        self.view.addSubview(self.cv)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func initData() {
        
        self.headers.add(XWTestHeaderData())
        
        let cell1s: NSMutableArray = NSMutableArray()
        for _ in 0 ... 20 {
            
            let testData: XWTestData = XWTestData()
            testData.title =  "很不错，这是自动算高度的，你也来试试啊，看准不准确啊，哈哈哈哈啊哈哈"
            cell1s.add(testData)
        }
        self.cells.add(cell1s)
        
        self.headers.add(XWTestHeaderData())
        
        let cell2s: NSMutableArray = NSMutableArray()
        for _ in 0 ... 10 {
            
            let testData: XWTestData = XWTestData()
            testData.title =  "我比你高哦，哈哈，我也是自动算高度的，黑河的我到单位的味道我的味道我的我，哈啊哈哈哈哈哈哈哈哈我也是自动算高度的，黑河的我到单位的味道我的味道我的我，哈啊哈哈哈哈哈哈哈哈我也是自动算高度的，黑河的我到单位的味道我的味道我的我，哈啊哈哈哈哈哈哈哈哈"
            cell2s.add(testData)
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
        
        self.dismiss(animated: true, completion: nil)
    }

    deinit {
        
         print("XWTestViewController--deinit")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
