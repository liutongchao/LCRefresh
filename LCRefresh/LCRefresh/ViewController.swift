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
            weakSelf!.perform(#selector(ViewController.headerRefresh), with: nil, afterDelay: 2)
        }
        
        table.addRefreshFooterWithBlock {
            print("footer 刷新")
            weakSelf!.perform(#selector(ViewController.footerRefresh), with: nil, afterDelay: 2)
        }
        
        
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

