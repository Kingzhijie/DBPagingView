//
//  ContentViewCell.swift
//  DBPagingView
//
//  Created by mbApple on 2017/11/3.
//  Copyright © 2017年 panda誌. All rights reserved.
//

import UIKit

class ContentViewCell: UITableViewCell {
    public var viewControllers = [ContentViewController]()
    public var pageView:DB_PageContentView?
    public var cellCanScroll:Bool?{
        didSet{
            for viewController:ContentViewController in viewControllers {
                viewController.vcCanScroll = cellCanScroll ?? false
                if !(cellCanScroll ?? false) {
                    viewController.tableView.contentOffset = CGPoint.zero
                }
            }
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
