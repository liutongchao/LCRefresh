//
//  ScrollViewController.swift
//  LCRefreshDemo
//
//  Created by 刘通超 on 2017/6/19.
//  Copyright © 2017年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "scroll"
        // Do any additional setup after loading the view.
        configScroll()
        addRefresh()

    }
    
    deinit {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    func configScroll() {
        let green = UIView.init(frame: UIScreen.main.bounds)
        green.backgroundColor = UIColor.green
        scrollView.addSubview(green)
        
        scrollView.contentSize = CGSize.init(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

    }
    
    func addRefresh() {
        scrollView.refreshHeader = LCRefreshHeader.init(refreshBlock: {[unowned self] in
            print("header")
            self.perform(#selector(ScrollViewController.headerRefresh), with: nil, afterDelay: 2)
        })
        
        scrollView.refreshFooter = LCRefreshFooter.init(refreshBlock: {[unowned self] in
            print("footer")
            self.perform(#selector(ScrollViewController.footerRefresh), with: nil, afterDelay: 2)
        })
    }

    @objc func headerRefresh() {
        
        if scrollView.isHeaderRefreshing() {
            scrollView.endHeaderRefreshing()
        }
        
        scrollView.resetDataLoad()
    }
    
    @objc func footerRefresh() {
        
        if scrollView.isFooterRefreshing() {
            scrollView.endFooterRefreshing()
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
