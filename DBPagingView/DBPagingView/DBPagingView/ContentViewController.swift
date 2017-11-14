//
//  ContentViewController.swift
//  DBPagingView
//
//  Created by mbApple on 2017/11/3.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    public var vcCanScroll = false
    public var Title:String?
    fileprivate var fingerIsTouch:Bool = false
    public lazy var tableView : UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - CGFloat(StatusBarAndNavigationBarHeight) - 50), style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.white
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        view.addSubview(self.tableView)

        // Do any additional setup after loading the view.
    }
    
    // MARK: - UITableView Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView:UIScrollView) {
        fingerIsTouch = true
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>){
        fingerIsTouch = false
    }
    
    func scrollViewDidScroll(_ scrollView:UIScrollView) {
        if !vcCanScroll {
            scrollView.contentOffset = CGPoint.zero
        }
        if scrollView.contentOffset.y <= 0 {
            //  if !fingerIsTouch{
            //       return
            //    }
            vcCanScroll = false
            scrollView.contentOffset = CGPoint.zero
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "leaveTop"), object: nil) ////到顶通知父视图改变状态
        }
        tableView.showsVerticalScrollIndicator = vcCanScroll ? true:false
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
