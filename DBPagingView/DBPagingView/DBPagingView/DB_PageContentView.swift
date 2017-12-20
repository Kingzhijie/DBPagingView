//
//  DB_PageContentView.swift
//  DBProject
//
//  Created by mbApple on 2017/11/3.
//  Copyright © 2017年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit

@objc protocol PageContentViewDelegate{ //协议
   
   /// DB_PageContentView开始滑动
   ///
   /// - Parameter contentView: DB_PageContentView
    @objc optional func PageContentViewWillBeginDragging(contentView:DB_PageContentView) -> Void
    
    
   /// DB_PageContentView滑动调用
   ///
   /// - Parameters:
   ///   - contentView: DB_PageContentView
   ///   - startIndex: 开始滑动页面索引
   ///   - endIndex: 结束滑动页面索引
   ///   - progress: 滑动进度
  @objc optional func PageContentViewDidScroll(contentView:DB_PageContentView,startIndex:NSInteger,endIndex:NSInteger,progress:CGFloat) -> Void
    
    
   /// DB_PageContentView 结束滑动
   ///
   /// - Parameters:
   ///   - contentView: DB_PageContentView
   ///   - startIndex: 开始滑动索引
   ///   - endIndex: 结束滑动索引
   @objc optional func PageContentViewDidEndDecelerating(contentView:DB_PageContentView,startIndex:NSInteger,endIndex:NSInteger) -> Void
    
}

class DB_PageContentView: UIView ,UICollectionViewDelegate,UICollectionViewDataSource{
    
    weak public var delegate:PageContentViewDelegate? //代理
    /**
     设置contentView当前展示的页面索引，默认为0
     */
    public var contentViewCurrentIndex:NSInteger = 0{
        didSet{
            if contentViewCurrentIndex < 0 || contentViewCurrentIndex > (childsVCs?.count ?? 0 - 1){
                return
            }
            isSelectBtn = true
            self.collectionView.scrollToItem(at: IndexPath.init(row: contentViewCurrentIndex, section: 0), at: UICollectionViewScrollPosition.init(rawValue: 0), animated: false)
        }
    }
    /**
     设置contentView能否左右滑动，默认YES
     */
    public var contentViewCanScroll:Bool = true{
        didSet{
            collectionView.isScrollEnabled = contentViewCanScroll
        }
    }
    
    private let collectionCellIdentifier = "collectionCellIdentifier"
    private var childsVCs:Array<UIViewController>? //子视图数组
    private var startOffsetX:CGFloat = 0
    private var isSelectBtn:Bool = false //是否是滑动
    private lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = self.bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: self.collectionCellIdentifier)
        return collectionView
    }()
    
    /// 对象方法创建DB_PageContentView
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - childVCs: 子VC数组
    ///   - parentVC: 父视图VC
    ///   - delegate: delegate
    init(frame: CGRect,childVCs:Array<UIViewController>,delegate:PageContentViewDelegate) {
        super.init(frame: frame)
        self.childsVCs = childVCs
        self.delegate = delegate
        self.addSubview(self.collectionView)
        setupSubViews()
    }
    
    private func setupSubViews() {
        startOffsetX = 0
        isSelectBtn = false
        contentViewCanScroll = true
        self.collectionView.reloadData()
    }
    
    
    //MARK --- UICollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childsVCs?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath)
        cell.backgroundColor = .yellow
        let childVC = self.childsVCs![indexPath.item] as UIViewController
        childVC.view.frame = cell.contentView.bounds
        childVC.view.removeFromSuperview()  //防止重复添加
        cell.contentView.addSubview(childVC.view)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        let childVC = self.childsVCs![indexPath.item] as UIViewController
//        childVC.view.frame = cell.contentView.bounds
//        if cell.contentView.subviews.contains(childVC.view) == false {
//            cell.contentView.addSubview(childVC.view)
//        }
//    }
    
    //MARK --- UIScrollView
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isSelectBtn = false
        startOffsetX = scrollView.contentOffset.x
        
        if delegate != nil && ((delegate?.PageContentViewWillBeginDragging) != nil) {
            delegate?.PageContentViewWillBeginDragging!(contentView: self)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isSelectBtn {
            return
        }
        
        let scrollView_W:CGFloat = scrollView.bounds.size.width
        let currentOffsetX:CGFloat = scrollView.contentOffset.x
        let startIndex = floor(startOffsetX/scrollView_W)
        var endIndex:Int = 0
        var progress:CGFloat = 0
        if currentOffsetX > startOffsetX { //左划left
            progress = (currentOffsetX - startOffsetX)/scrollView_W
            endIndex = Int(startIndex) + 1
            if endIndex > childsVCs?.count ?? 0 - 1 {
                endIndex = childsVCs?.count ?? 0 - 1
            }
        }else if currentOffsetX == startOffsetX{ //没有划过去
            progress = 0
            endIndex = Int(startIndex)
        }else{
            progress = (startOffsetX - currentOffsetX)/scrollView_W
            endIndex = Int(startIndex - 1)
            endIndex = endIndex < 0 ? 0:endIndex
        }
        
        if delegate != nil && ((delegate?.PageContentViewDidScroll) != nil) {
            delegate?.PageContentViewDidScroll!(contentView: self, startIndex: NSInteger(startIndex), endIndex: endIndex, progress: progress)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let scrollView_W = scrollView.bounds.size.width
        let currentOffsetX = scrollView.contentOffset.x
        let startIndex = floor(startOffsetX/scrollView_W)
        let endIndex = floor(currentOffsetX/scrollView_W)
        
        if delegate != nil && ((delegate?.PageContentViewDidEndDecelerating) != nil) {
            delegate?.PageContentViewDidEndDecelerating!(contentView: self, startIndex: NSInteger(startIndex), endIndex: NSInteger(endIndex))
        }
    }
    
 
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
