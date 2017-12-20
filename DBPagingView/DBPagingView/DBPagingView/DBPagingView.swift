//
//  DBPagingView.swift
//  DBPagingView
//
//  Created by mbApple on 2017/11/14.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit
let KscreenWidth = UIScreen.main.bounds.size.width
let KscreenHeight = UIScreen.main.bounds.size.height
// iPhone X
let iphoneX = (KscreenWidth == 375.0 && KscreenHeight == 812.0 ? true : false) as Bool
// Status bar height.
let StatusBarHeight = (iphoneX ? 44.0 : 20.0)
// Navigation bar height.
let NavigationBarHeight = 44.0
// Tabbar height.
let TabbarHeight = (iphoneX ? (49.0 + 34.0) : 49.0)
//// Tabbar safe bottom margin.
let TabbarSafeBottomMargin = (iphoneX ? 34.0 : 0.01)
// Status bar & navigation bar height.
let StatusBarAndNavigationBarHeight = (iphoneX ? 88.0 : 64.0)

class DBPagingView: UIView,UITableViewDelegate,UITableViewDataSource,PageContentViewDelegate {
    
    //样式修改
    public var textColor:UIColor?{ //默认字体颜色
        didSet{
            if textColor != nil {
                self.titleView?.textColor = textColor!
            }
        }
    }
    public var selectedTextColor:UIColor?{//默认选中颜色
        didSet{
            if selectedTextColor != nil {
               self.titleView?.selectedTextColor = selectedTextColor!
            }
        }
    }
    public var font:Double?{ //默认字体大小
        didSet{
            if font != nil {
               self.titleView?.font = font!
            }
        }
    }
    public var selectedFont:Double?{//选中字体大小
        didSet{
            if selectedFont != nil {
                self.titleView?.selectedFont = selectedFont!
            }
        }
    }
    public var segViewHeight:CGFloat = 50 //标签默认高度50
    public var selectIndex = 0{ //可以修改, 选中的标签下标
        didSet{
            self.titleView?.selectedIndex = selectIndex
            if self.pageView != nil {
                self.pageView?.contentViewCurrentIndex = selectIndex
            }else{
                self.contentCell.pageView?.contentViewCurrentIndex = selectIndex
            }
        }
    }
    
    fileprivate lazy var tableView : DB_ContentTableView = { //tableView 必须继承DB_ContentTableView, 目的: 解决多手势冲突问题
        let tableView = DB_ContentTableView(frame: CGRect(x: 0, y: CGFloat(StatusBarAndNavigationBarHeight), width: self.frame.width, height: self.frame.height - CGFloat(StatusBarAndNavigationBarHeight)), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
        tableView.separatorStyle = .none
        tableView.register(ContentViewCell.classForCoder(), forCellReuseIdentifier: "cell")
        if #available(iOS 11.0, *){
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        }else{
        }
        return tableView
    }()
    fileprivate lazy var titleView: DB_SegmentView? = { //标签View
        let titleView = DB_SegmentView(frame: CGRect(x: 0, y: CGFloat(StatusBarAndNavigationBarHeight), width: UIScreen.main.bounds.size.width, height: self.segViewHeight), titles: self.titleArray)
        titleView.selectBlock = {[weak self] in
            if self?.pageView != nil{
                self?.pageView?.contentViewCurrentIndex = (self?.titleView?.selectedIndex)!
            }else{
                self?.contentCell.pageView?.contentViewCurrentIndex = (self?.titleView?.selectedIndex)!
            }
        }
        return titleView
    }()
   
    fileprivate var canScroll:Bool = true //默认可以滚动
    fileprivate var titleArray = [String]() //标签title
    fileprivate lazy var contentCell: ContentViewCell = {
        let cellIdentifier = "cell"
        let contentCell = ContentViewCell(style: .default, reuseIdentifier: cellIdentifier)
        contentCell.selectionStyle = .none
        for index in 0..<self.titleArray.count {
            let contentVC = self.controllers[index]
            contentVC.segTitle = self.titleArray[index]
        }
        contentCell.viewControllers = self.controllers
        contentCell.pageView = DB_PageContentView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), childVCs: self.controllers, delegate: self)
        contentCell.addSubview((contentCell.pageView)!)
        return contentCell
    }()
    fileprivate var controllers = [ContentViewController]()
    fileprivate var headView:UIView?
    fileprivate var pageView:DB_PageContentView?
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - titles: 标签title
    ///   - controllersArray: 标签controllers
    ///   - superController: 父视图VC
    ///   - headerView: 头部试图
    init(frame: CGRect,titles:[String],controllersArray:[ContentViewController],headerView:UIView) {
        super.init(frame: frame)
        titleArray = titles
        controllers = controllersArray
        headView = headerView
        self.addSubview(self.tableView)
        if headerView.frame.height == 0 {
            self.addSubview(self.titleView!)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeScrollStatus), name: NSNotification.Name(rawValue: "leaveTop"), object: nil)
    }
    
    /// 初始化方法
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - titles: 标签title
    ///   - controllersArray: 标签controllers
    ///   - superController: 父视图VC
    init(frame: CGRect,titles:[String],controllersArray:[ContentViewController]) {
        super.init(frame: frame)
        titleArray = titles
        controllers = controllersArray
        self.addSubview(self.titleView!)
        
        for index in 0..<titleArray.count {
            let contentVC = controllers[index]
            contentVC.isHeader = false
            contentVC.segTitle = titleArray[index]
        }
        
        pageView = DB_PageContentView(frame: CGRect(x: 0, y: (self.titleView?.frame.size.height)! + CGFloat(StatusBarAndNavigationBarHeight), width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height), childVCs: controllers, delegate: self)
        self.addSubview(pageView!)
        
    }
    
    @objc fileprivate func changeScrollStatus() {
        canScroll = true
        contentCell.cellCanScroll = false
    }
    
    //MARK --- tableView 协议方法
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            return self.contentCell
        }else{
            let cell = UITableViewCell()
            cell.addSubview(headView!)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 1{
            return UIScreen.main.bounds.size.height
        }else{
            return (headView?.frame.height)!
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if section == 1{
            return segViewHeight
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section == 1 && headView?.frame.height != 0{
            return self.titleView
        }else{
            return nil
        }
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
                contentCell.cellCanScroll = true
            }
        }else{
            if !canScroll {
                scrollView.contentOffset = CGPoint(x: 0, y: bottomCellOffset)
            }
        }
        tableView.showsVerticalScrollIndicator = canScroll ? true:false
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
