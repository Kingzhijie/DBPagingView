//
//  ViewController.swift
//  DBPagingView
//
//  Created by mbApple on 2017/11/3.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,PageContentViewDelegate {
    fileprivate lazy var tableView : DB_ContentTableView = { //tableView 必须继承DB_ContentTableView, 目的: 解决多手势冲突问题
        let tableView = DB_ContentTableView(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        if #available(iOS 11.0, *){
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }else{
            self.automaticallyAdjustsScrollViewInsets = false
        }
        return tableView
    }()
    fileprivate var canScroll:Bool = true //默认可以滚动
    fileprivate var segViewHeight:CGFloat = 50 //标签默认高度50
    fileprivate var titleArray = [String]() //标签title
    fileprivate var titleView:DB_SegmentView? //标签View
    fileprivate var contentCell:ContentViewCell?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "滚动视图"
        view.addSubview(self.tableView)
        tableView.register(ContentViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        view.backgroundColor = .yellow
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeScrollStatus), name: NSNotification.Name(rawValue: "leaveTop"), object: nil)
        titleArray = ["第一个","第二个","第三个"]
    }
    
    @objc fileprivate func changeScrollStatus() {
        canScroll = true
        contentCell?.cellCanScroll = false
    }
    
    //MARK --- tableView 协议方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cellIdentifier = "cell"
            contentCell = ContentViewCell(style: .default, reuseIdentifier: cellIdentifier)
            contentCell?.selectionStyle = .none
            var contentVCs = [ContentViewController]()
            for title:String in titleArray{
                let contentVC = ContentViewController()
                contentVC.segTitle = title
                contentVCs.append(contentVC)
            }
            contentCell?.viewControllers = contentVCs
            contentCell?.pageView = DB_PageContentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), childVCs: contentVCs, parentVC: self, delegate: self)
            contentCell?.addSubview((contentCell?.pageView)!)
            
            return contentCell!
        }
        let cell = UITableViewCell()
        cell.backgroundColor = .blue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0 {
            return 182
        }
        return UIScreen.main.bounds.size.height
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 0 {
            return 0.01
        }
        return segViewHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section == 0 {
            return nil
        }
        let headerView = UIView()
        titleView = DB_SegmentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: segViewHeight), titles: titleArray)
        titleView?.textColor = UIColor.gray
        titleView?.font = 14
        titleView?.selectedFont = 15
        titleView?.selectedTextColor = UIColor.black
        headerView.addSubview(titleView!)
        titleView?.selectBlock = {[weak self] in
            self?.contentCell?.pageView?.contentViewCurrentIndex = (self?.titleView?.selectedIndex)!
        }
        return headerView
    }
    
    // MARK: - PageContentViewDelegate
    func PageContentViewDidEndDecelerating(contentView: DB_PageContentView, startIndex: NSInteger, endIndex: NSInteger) {
        titleView?.selectedIndex = endIndex
        tableView.isScrollEnabled = true //此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动
    }
    
    func PageContentViewDidScroll(contentView: DB_PageContentView, startIndex: NSInteger, endIndex: NSInteger, progress: CGFloat) {
        tableView.isScrollEnabled = false //pageView开始滚动主tableview禁止滑动
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView:UIScrollView) {
        let bottomCellOffset = tableView.rect(forSection: 1).origin.y
        if scrollView.contentOffset.y >= bottomCellOffset {
            scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)
            if canScroll {
                canScroll = false
                contentCell?.cellCanScroll = true
            }
        }else{
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)
            }
        }
        tableView.showsVerticalScrollIndicator = canScroll ? true:false
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

