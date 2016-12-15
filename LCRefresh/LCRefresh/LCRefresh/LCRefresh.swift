//
//  LCRefresh.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/2.
//  Copyright © 2016年 West. All rights reserved.
//

import UIKit

private var lcHeaderBlock: (()->Void)?
private var lcFooterBlock: (()->Void)?
private var header: LCRefreshHeader?
private var footer: LCRefreshFooter?
private var footerView: UIView?
private var refreshObj = LCRefreshObject.header
private var lastRefreshObj = LCRefreshObject.header
private var isHaveObserver = false

extension UIScrollView{
    //MARK: /** Header 相关 */
    /** 添加下拉刷新 */
    func addRefreshHeaderWithBlock(_ refreshBlock:@escaping ()->Void){
        /** 添加header */
        weak var weakSelf = self

        header = LCRefreshHeader.instanceFromNibBundle() as? LCRefreshHeader
        guard header != nil else{
            print("Header加载失败")
            return
        }
        header!.center = LCRefreshHeaderCenter

        let headerView = UIView.init(frame: CGRect(x: LCRefreshHeaderX, y: LCRefreshHeaderY, width: LCRefreshScreenWidth, height: LCRefreshHeaderHeight))
        headerView.backgroundColor = UIColor.clear
        headerView.addSubview(header!)
        weakSelf!.addSubview(headerView)
        
        //添加滑动监测
        addOffsetObserver()

        weakSelf!.panGestureRecognizer.addTarget(weakSelf!, action: #selector(UIScrollView.scrollViewDragging(_:)))
        
        lcHeaderBlock = refreshBlock
    }
    /** header 刷新状态 */
    func isHeaderRefreshing() -> Bool {
        guard header != nil else{
            return false
        }
        
        return header!.refreshStatus == LCRefreshHeaderStatus.refreshing ? true: false
    }
    
    /** header 结束刷新 */
    func endHeaderRefreshing() {
        weak var weakSelf = self

        guard header != nil else{
            return
        }
        if lastRefreshObj == LCRefreshObject.header {
            weakSelf!.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        header!.setStatus(LCRefreshHeaderStatus.normal)

        lastRefreshObj = LCRefreshObject.header
    }
    
    func addOffsetObserver() {
        if(!isHaveObserver){
            self.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.new, context: nil)
            isHaveObserver = true;
        }
        
    }
}

extension UIScrollView{
    //MARK: /** Footer 相关 */
    /** 添加下拉刷新 */
    func addRefreshFooterWithBlock(_ refreshBlock:@escaping ()->Void){
        /** 添加header */
        weak var weakSelf = self
        footer = LCRefreshFooter.instanceFromNibBundle() as? LCRefreshFooter
        guard footer != nil else{
            print("Footer加载失败")
            return
        }
        footer!.center = LCRefreshFooterCenter
        
        footerView = UIView.init(frame: CGRect(x: LCRefreshFooterX, y: weakSelf!.contentSize.height, width: LCRefreshScreenWidth, height: LCRefreshFooterHeight))
        footerView!.backgroundColor = UIColor.clear

        footerView!.addSubview(footer!)
        footerView!.isHidden = true
        weakSelf!.addSubview(footerView!)
        
        //添加滑动监测
        addOffsetObserver()
        weakSelf!.panGestureRecognizer.addTarget(weakSelf!, action: #selector(UIScrollView.scrollViewDragging(_:)))
        
        lcFooterBlock = refreshBlock
    }
    /** footer 刷新状态 */
    func isFooterRefreshing() -> Bool {
        guard footer != nil else{
            return false
        }
        
        return footer!.refreshStatus == LCRefreshFooterStatus.refreshing ? true: false
    }
    
    /** footer 结束刷新 */
    func endFooterRefreshing() {
        weak var weakSelf = self
        guard footer != nil else{
            return
        }
        let size = weakSelf!.contentSize
        weakSelf!.contentSize = CGSize(width: size.width, height: size.height - LCRefreshFooterHeight)
        
        /** 1、数据没有充满屏幕
            2、数据已经填充满屏幕 **/
 
        if size.height < weakSelf!.bounds.size.height {
            weakSelf!.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else{
            let offSet = weakSelf!.contentSize.height-weakSelf!.bounds.size.height
            weakSelf!.setContentOffset(CGPoint(x: 0, y: offSet), animated: true)
        }
        footer!.setStatus(LCRefreshFooterStatus.normal)
        footerView!.isHidden = true
        
        lastRefreshObj = LCRefreshObject.footer
    }
}

extension UIScrollView{
    //MARK: /** 数据加载完毕状态 **/
    func setDataLoadover() {
        weak var weakSelf = self
        guard footer != nil else{
            return
        }
        let size = weakSelf!.contentSize
        footerView!.isHidden = false
        footerView!.frame = CGRect(x: LCRefreshFooterX, y: size.height, width: LCRefreshScreenWidth, height: LCRefreshFooterHeight)
        
        weakSelf!.contentSize = CGSize(width: size.width, height: size.height + LCRefreshFooterHeight)
        footer!.setStatus(LCRefreshFooterStatus.loadover)
    }
    
    /** 初始化状态 **/
    func resetDataLoad() {
        guard footer != nil else{
            return
        }
        footerView!.isHidden = true
        footer!.setStatus(LCRefreshFooterStatus.normal)
    }
}

extension UIScrollView{
    //MARK: 滑动监测
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let offSet = self.contentOffset.y
            let scrollHeight = self.bounds.size.height
            let inset = self.contentInset
            var currentOffset = offSet + scrollHeight - inset.bottom
            let maximumOffset = self.contentSize.height
            
            /** 数据未充满屏幕的情况 **/
            if maximumOffset < scrollHeight {
                currentOffset = offSet + maximumOffset - inset.bottom
            }
            
            if offSet < 0 {
                /** 下拉刷新 */
                guard header != nil else{
                    return
                }
                scrollHeader(offSet)
                refreshObj = LCRefreshObject.header
            }else if currentOffset - maximumOffset > 0 {
                /** 上拉刷新 */
                
                guard footer != nil else{
                    return
                }
                guard footer!.refreshStatus != LCRefreshFooterStatus.loadover else {
                    return
                }
                
                scrollFooter(currentOffset - maximumOffset)
                refreshObj = LCRefreshObject.footer
                
            }else{
                /** 无刷新对象 */
                refreshObj = LCRefreshObject.none
            }

        }
    }
    
    fileprivate func scrollHeader(_ offSet: CGFloat) {//参数为负数
        guard header != nil else{
            print("Header加载失败")
            return
        }
        guard header!.refreshStatus != LCRefreshHeaderStatus.refreshing else{
            return
        }
        if offSet < -LCRefreshHeaderHeight {
            header!.setStatus(LCRefreshHeaderStatus.waitRefresh)
        }else{
            header!.setStatus(LCRefreshHeaderStatus.normal)
        }

    }
    
    fileprivate func scrollFooter(_ offSet: CGFloat) {
        weak var weakSelf = self
        guard footer != nil else{
            print("Footer加载失败")
            return
        }
        guard footer!.refreshStatus != LCRefreshFooterStatus.refreshing else{
            return
        }
        
        footerView!.isHidden = false
        footerView!.frame = CGRect(x: LCRefreshFooterX, y: weakSelf!.contentSize.height, width: LCRefreshScreenWidth, height: LCRefreshFooterHeight)
        
        if offSet > LCRefreshFooterHeight {
            footer!.setStatus(LCRefreshFooterStatus.waitRefresh)
        }else{
            footer!.setStatus(LCRefreshFooterStatus.normal)
        }

    }
    
    /** 拖拽相关 */
    func scrollViewDragging(_ pan: UIPanGestureRecognizer){
        if pan.state == .ended{
            if refreshObj == LCRefreshObject.header {
                draggHeader()

            }else if refreshObj == LCRefreshObject.footer{
                draggFooter()
            }
        }
    }
    
    fileprivate func draggHeader(){
        weak var weakSelf = self
        guard header != nil else{
            print("Header加载失败")
            return
        }
        if header!.refreshStatus == LCRefreshHeaderStatus.waitRefresh {
            weakSelf!.setContentOffset(CGPoint(x: 0, y: -LCRefreshHeaderHeight), animated: true)
            header!.setStatus(LCRefreshHeaderStatus.refreshing)
            if lcHeaderBlock != nil {
                lcHeaderBlock!()
            }
        }else if header!.refreshStatus == LCRefreshHeaderStatus.refreshing{
            weakSelf!.setContentOffset(CGPoint(x: 0, y: -LCRefreshHeaderHeight), animated: true)
            
        }
    }
    
    fileprivate func draggFooter() {
        weak var weakSelf = self
        guard footer != nil else{
            print("Footer加载失败")
            return
        }
        if footer!.refreshStatus == LCRefreshFooterStatus.waitRefresh {
            /** 设置scroll的contentsize 以及滑动offset **/
            let size = weakSelf!.contentSize
            weakSelf!.contentSize = CGSize(width: size.width, height: size.height + LCRefreshFooterHeight)
            /** 1、数据没有充满屏幕
             2、数据已经填充满屏幕
             **/
            if size.height < weakSelf!.bounds.size.height {
                weakSelf!.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }else{
                let offSet = weakSelf!.contentSize.height-weakSelf!.bounds.size.height
                weakSelf!.setContentOffset(CGPoint(x: 0, y: offSet), animated: true)
            }
            /** 切换状态 **/
            footer!.setStatus(LCRefreshFooterStatus.refreshing)
            if lcFooterBlock != nil {
                lcFooterBlock!()
            }
        }
    }
    
    
}


extension UIView{
    //MARK: NIB加载工具
    
    class func instanceFromNibBundle() -> UIView? {
        
        let nib = UINib.init(nibName: String(describing: self), bundle: nil)
        let views = nib.instantiate(withOwner: nil, options: nil)
        
        for view in views {
            if (view as AnyObject).isMember(of: self) {
                return view as? UIView
            }
        }
        
        assert(false, "Exepect file:\(String(describing: self)).xib")
        return nil
    }

}
