//
//  DB_SegmentView.swift
//  DBProject
//
//  Created by panda誌 on 2017/8/30.
//  Copyright © 2017年 杭州稻本信息技术有限公司. All rights reserved.
//

import UIKit
typealias mathSelect = ()->Void
class DB_SegmentView: UIView {
    //选中标签的下标
    public var selectedIndex = 0{
        didSet{
            selectChangeButtonStyle()
        }
    }
    public var selectBlock:mathSelect? //闭包传值
    //样式修改
    public var textColor:UIColor = .lightGray{ //默认字体颜色
        didSet{
            selectChangeButtonStyle()
        }
    }
    public var selectedTextColor:UIColor = .black{//默认选中颜色
        didSet{
            selectChangeButtonStyle()
        }
    }
    public var font = 15.0{ //默认字体大小
        didSet{
            selectChangeButtonStyle()
        }
    }
    public var selectedFont = 16.0{//选中字体大小
        didSet{
            selectChangeButtonStyle()
        }
    }
    
    private var numberOfSegments = 0  //标签的总个数
    private var buttonArray = [UIButton]() //标签数组
    //初始化方法,  titles 标签数组
    init(frame: CGRect,titles:[String]) {
        super.init(frame: frame)
        self.backgroundColor = .white
        numberOfSegments = titles.count
        
        let lineView = UIView(frame: CGRect(x: 0, y: frame.size.height - 0.5, width: frame.size.width, height: 0.5))
        lineView.backgroundColor = .lightGray
        self.addSubview(lineView)
        
        let confWidth = frame.size.width / CGFloat(numberOfSegments)
        for index:Int in 0..<numberOfSegments {
            let scale = CGFloat(index) / CGFloat(numberOfSegments)
            let shuView = UIView(frame: CGRect(x: scale * UIScreen.main.bounds.size.width, y: 14, width: 0.5, height: frame.size.height - 28))
            shuView.backgroundColor = .lightGray
            let button = configureLabels(name: titles[index])
            button.tag = 1000 + index
            button.frame = CGRect(x: CGFloat(index) * confWidth, y: 0, width: confWidth, height: frame.size.height)
            if index == 0 {
                changeButtonStyle(button: button)
            }
            self.addSubview(button)
            if index > 0 {
                self.addSubview(shuView)
            }
            buttonArray.append(button)
        }

    }
    
    private func configureLabels(name:String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(name, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(font))
        button.addTarget(self, action: #selector(selectIndexButtonAction(button:)), for: .touchUpInside)
        return button
    }
    
    
    @objc private func selectIndexButtonAction(button:UIButton) {
        selectedIndex = button.tag - 1000
        if selectBlock != nil {
            self.selectBlock!()
        }
        changeButtonStyle(button: button)
    }
    
    
    private func selectChangeButtonStyle() {
        let button = self.viewWithTag(selectedIndex + 1000)
        changeButtonStyle(button: button as? UIButton ?? UIButton())
    }
    
    private func changeButtonStyle(button:UIButton) {
        button.setTitleColor(selectedTextColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(selectedFont))
        for btn:UIButton in buttonArray {
            if btn.tag != button.tag {
                btn.setTitleColor(textColor, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(font))
            }
        }
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
