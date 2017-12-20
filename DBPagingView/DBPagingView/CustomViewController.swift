//
//  CustomViewController.swift
//  DBPagingView
//
//  Created by mbApple on 2017/12/16.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .red
        view.addSubview(btn)
        btn.addTarget(self, action: #selector(pushview), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 200, width: 100, height: 60)

        // Do any additional setup after loading the view.
    }
    @objc func pushview() {
        let VC = ViewController()
        navigationController?.pushViewController(VC, animated: true)
        
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
