//
//  ViewController.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/2.
//  Copyright © 2016年 West. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var table: UITableView!
    var numRows = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        weak var weakSelf = self
        table.addRefreshHeaderWithBlock {
            print("header 刷新")
            weakSelf!.performSelector(#selector(ViewController.headerRefresh), withObject: nil, afterDelay: 5)
        }
        
        table.addRefreshFooterWithBlock { 
            print("header 刷新")
            weakSelf!.performSelector(#selector(ViewController.footerRefresh), withObject: nil, afterDelay: 5)
        }
        
        
        table.tableFooterView = UIView.init(frame: CGRectMake(0, 0, 300, 5))
        
        
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
        
        if numRows > 200 {
            weakSelf!.table.setDataLoadover()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController:UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = "label\(indexPath.row)"
        
        return cell
    }
}

