# DBPagingView
	***使用方法***
	下载demo, 直接导入DBPagingView文件即可
	使用方法可以参考 demo 中的示例
	**1**
	let header = UIView(frame: CGRect(x: 0, y: 0, width: KscreenWidth, height: 200))  //设置头部试图
        header.backgroundColor = .blue
        
        let titles = ["第一个","第二个","第三个"]  //标签title数组
        var controllers = [myViewController]()  //对应controllers数组
        for _ in titles {
            let myVC = myViewController()  //myViewController 内容控制器. 必须继承ContentViewController 父控制器
            self.addChildViewController(myVC)
            controllers.append(myVC)
        }

        ###两种初始化方法###

        1. 设置带有头部的pageView
        let pagingView = DBPagingView(frame: CGRect(x: 0, y: 0, width: KscreenWidth, height: KscreenHeight), titles: titles, controllersArray: controllers,headerView: header)

        2. 设置没有头部的pageView
        let pagingView = DBPagingView(frame: CGRect(x: 0, y: 0, width: KscreenWidth, height: KscreenHeight), titles: titles, controllersArray: controllers)

        self.view.addSubview(pagingView)

        设置默认选中index下标
        pagingView.selectIndex = 1
        
        //样式调整
        pagingView.textColor = .blue
        pagingView.selectedTextColor = .red
        pagingView.font = 15
        pagingView.selectedFont = 18
