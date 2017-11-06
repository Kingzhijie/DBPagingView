//
//  DB_ContentTableView.swift
//  DBProject
//
//  Created by panda誌 on 2017/8/31.
//  Copyright © 2017年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit

class DB_ContentTableView: UITableView,UIGestureRecognizerDelegate {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    func gestureRecognizer(_ gestureRecognizer:UIGestureRecognizer,shouldRecognizeSimultaneouslyWith shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
        return true
    }


}
