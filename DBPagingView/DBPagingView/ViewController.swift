//
//  ViewController.swift
//  DBPagingView
//
//  Created by mbApple on 2017/11/3.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "滚动视图"
        view.backgroundColor = .yellow

        let header = UIView(frame: CGRect(x: 0, y: 0, width: KscreenWidth, height: 200))  //设置头部试图 (注: 高度为0, 则没有头部)
        header.backgroundColor = .blue
        
        let titles = ["第一个","第二个","第三个"]  //标签title数组
        var controllers = [myViewController]()  //对应controllers数组
        for _ in titles {
            let myVC = myViewController()  //myViewController 内容控制器. 必须继承ContentViewController 父控制器
            controllers.append(myVC)
        }

        let pagingView = DBPagingView(frame: CGRect(x: 0, y: 0, width: KscreenWidth, height: KscreenHeight), titles: titles, controllersArray: controllers, superController: self, headerView: header)
        self.view.addSubview(pagingView)
        
        //样式调整
        pagingView.textColor = .blue
        pagingView.selectedTextColor = .red
        pagingView.font = 15
        pagingView.selectedFont = 18
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

