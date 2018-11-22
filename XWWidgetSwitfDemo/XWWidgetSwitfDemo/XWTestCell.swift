//
//  XWTestCell.swift
//  XWWidgetSwitfDemo
//
//  Created by 王剑石 on 2018/9/10.
//  Copyright © 2018年 wangjianshi. All rights reserved.
//

import UIKit
import SnapKit

class XWTestCell: UICollectionViewCell {
    
    var titleLab: UILabel = UILabel.init()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.yellow
        titleLab.numberOfLines = 0
        contentView.addSubview(titleLab)
        titleLab.snp.makeConstraints { (make) in
            
            make.top.left.equalTo(10)
            make.bottom.right.equalTo(-10)
        }


    }
    
    override func reuseWithData(data: NSObject, indexPath: IndexPath) {
        
        super.reuseWithData(data: data, indexPath: indexPath)
        if let testData: XWTestData = data as? XWTestData {
            
            titleLab.text = testData.title
        }
        
    }
    
    lazy var deleteView: UIView = {
        
        let view: UIView = UIView.init(frame: CGRect.zero)
        view.backgroundColor = UIColor.red
        let btn: UIButton = UIButton.init(frame: CGRect.zero)
        btn.setTitle("删除", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        view.addSubview(btn)
        btn.snp.makeConstraints({ (make) in
            
            make.center.equalTo(btn.superview!);
            make.left.equalTo(btn.superview!).offset(25);
            make.right.equalTo(btn.superview!).offset(-25);
        })
        return view
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
