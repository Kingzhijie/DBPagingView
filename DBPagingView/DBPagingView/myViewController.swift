//
//  myViewController.swift
//  DBPagingView
//
//  Created by mbApple on 2017/11/14.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit
import MJRefresh
class myViewController: ContentViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {[weak self] in
           self?.refreshingData()
        })

        // Do any additional setup after loading the view.
    }
    
    func refreshingData() {
        self.tableView.mj_header.endRefreshing()
    }
    
    // MARK: - UITableView Method
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = segTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(0.01 + TabbarSafeBottomMargin)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
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
