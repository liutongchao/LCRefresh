//
//  ViewController.swift
//  LCRefreshDemo
//
//  Created by 刘通超 on 2016/12/29.
//  Copyright © 2016年 北京京师乐学教育科技有限公司. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var numRows = 5
    var PERSON_ID_NUMBER_PROPERTY = UnsafeRawPointer.init(bitPattern: "Instance".hashValue)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "下拉刷新"
        weak var weakSelf = self
        
        table.refreshHeader = LCRefreshHeader.init(refreshBlock: {
            print("header")
            weakSelf!.perform(#selector(ViewController.headerRefresh), with: nil, afterDelay: 2)
        })

        table.refreshFooter = LCRefreshFooter.init(refreshBlock: {
            print("footer")
            weakSelf!.perform(#selector(ViewController.footerRefresh), with: nil, afterDelay: 2)
        })
        
        table.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 5))
        
    }
    
    func headerRefresh() {
        
        weak var weakSelf = self
        
        if weakSelf!.table.isHeaderRefreshing() {
            weakSelf!.table.endHeaderRefreshing()
        }
        
        weakSelf!.numRows = 5
        weakSelf!.table.reloadData()
        
        weakSelf!.table.resetDataLoad()
    }
    
    func footerRefresh() {
        weak var weakSelf = self
        
        if weakSelf!.table.isFooterRefreshing() {
            weakSelf!.table.endFooterRefreshing()
        }
        weakSelf!.numRows += 5
        weakSelf!.table.reloadData()
        
        if numRows > 20 {
            weakSelf!.table.setDataLoadover()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = "label\(indexPath.row)"
        
        return cell
    }
    
}

extension ViewController:UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let vi = UIView.init()
        vi.backgroundColor = UIColor.lightGray
        return vi
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30;
    }
}

