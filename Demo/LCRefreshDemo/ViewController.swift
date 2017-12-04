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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        title = "下拉刷新"
        
        table.refreshHeader = LCRefreshHeader.init(refreshBlock: {[unowned self] in
            print("header")
            self.perform(#selector(ViewController.headerRefresh), with: nil, afterDelay: 2)
        })

        table.refreshFooter = LCRefreshFooter.init(refreshBlock: {[unowned self] in
            print("footer")
            self.perform(#selector(ViewController.footerRefresh), with: nil, afterDelay: 2)
        })
        
        table.tableFooterView = UIView.init(frame: CGRect(x: 0, y: 0, width: 300, height: 5))
    }
    
    deinit {
        
    }
    
    @objc func headerRefresh() {
        
        if table.isHeaderRefreshing() {
            table.endHeaderRefreshing()
        }
        
        numRows = 5
        table.reloadData()
        
        table.resetDataLoad()
    }
    
    @objc func footerRefresh() {
        
        if table.isFooterRefreshing() {
            table.endFooterRefreshing()
        }
        numRows += 5
        table.reloadData()
        
        if numRows > 20 {
            table.setDataLoadover()
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
        return 20;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stor = UIStoryboard.init(name: "Main", bundle: nil)
        let ctr = stor.instantiateViewController(withIdentifier: "ScrollViewController")
        navigationController?.pushViewController(ctr, animated: true)
    }
}

