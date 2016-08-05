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
private var refreshObj = LCRefreshObject.Header
private var lastRefreshObj = LCRefreshObject.Header

extension UIScrollView{
    //MARK: /** Header 相关 */
    /** 添加下拉刷新 */
    func addRefreshHeaderWithBlock(refreshBlock:()->Void){
        /** 添加header */
        weak var weakSelf = self

        header = LCRefreshHeader.instanceFromNibBundle() as? LCRefreshHeader
        guard header != nil else{
            print("Header加载失败")
            return
        }
        header!.center = LCRefreshHeaderCenter

        let headerView = UIView.init(frame: CGRectMake(LCRefreshHeaderX, LCRefreshHeaderY, LCRefreshScreenWidth, LCRefreshHeaderHeight))
        headerView.backgroundColor = UIColor.clearColor()
        headerView.addSubview(header!)
        weakSelf!.addSubview(headerView)
        
        /** 设置代理信息 */
        weakSelf!.delegate = weakSelf
        weakSelf!.panGestureRecognizer.addTarget(weakSelf!, action: #selector(UIScrollView.scrollViewDragging(_:)))
        
        lcHeaderBlock = refreshBlock
    }
    /** header 刷新状态 */
    func isHeaderRefreshing() -> Bool {
        guard header != nil else{
            return false
        }
        
        return header!.refreshStatus == LCRefreshHeaderStatus.Refreshing ? true: false
    }
    
    /** header 结束刷新 */
    func endHeaderRefreshing() {
        weak var weakSelf = self

        guard header != nil else{
            return
        }
        if lastRefreshObj == LCRefreshObject.Header {
            weakSelf!.setContentOffset(CGPointMake(0, 0), animated: true)
        }
        header!.setStatus(LCRefreshHeaderStatus.Normal)

        lastRefreshObj = LCRefreshObject.Header
    }
}

extension UIScrollView{
    //MARK: /** Footer 相关 */
    /** 添加下拉刷新 */
    func addRefreshFooterWithBlock(refreshBlock:()->Void){
        /** 添加header */
        weak var weakSelf = self
        footer = LCRefreshFooter.instanceFromNibBundle() as? LCRefreshFooter
        guard footer != nil else{
            print("Footer加载失败")
            return
        }
        footer!.center = LCRefreshFooterCenter
        
        footerView = UIView.init(frame: CGRectMake(LCRefreshFooterX, weakSelf!.contentSize.height, LCRefreshScreenWidth, LCRefreshFooterHeight))
        footerView!.backgroundColor = UIColor.clearColor()

        footerView!.addSubview(footer!)
        footerView!.hidden = true
        weakSelf!.addSubview(footerView!)
        
        /** 设置代理信息 */
        weakSelf!.delegate = weakSelf
        weakSelf!.panGestureRecognizer.addTarget(weakSelf!, action: #selector(UIScrollView.scrollViewDragging(_:)))
        
        lcFooterBlock = refreshBlock
    }
    /** footer 刷新状态 */
    func isFooterRefreshing() -> Bool {
        guard footer != nil else{
            return false
        }
        
        return footer!.refreshStatus == LCRefreshFooterStatus.Refreshing ? true: false
    }
    
    /** footer 结束刷新 */
    func endFooterRefreshing() {
        weak var weakSelf = self
        guard footer != nil else{
            return
        }
        let size = weakSelf!.contentSize
        weakSelf!.contentSize = CGSizeMake(size.width, size.height - LCRefreshFooterHeight)
        
        /** 1、数据没有充满屏幕
            2、数据已经填充满屏幕 **/
 
        if size.height < weakSelf!.bounds.size.height {
            weakSelf!.setContentOffset(CGPointMake(0, 0), animated: true)
        }else{
            let offSet = weakSelf!.contentSize.height-weakSelf!.bounds.size.height
            weakSelf!.setContentOffset(CGPointMake(0, offSet), animated: true)
        }
        footer!.setStatus(LCRefreshFooterStatus.Normal)
        footerView!.hidden = true
        
        lastRefreshObj = LCRefreshObject.Footer
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
        footerView!.hidden = false
        footerView!.frame = CGRectMake(LCRefreshFooterX, size.height, LCRefreshScreenWidth, LCRefreshFooterHeight)
        
        weakSelf!.contentSize = CGSizeMake(size.width, size.height + LCRefreshFooterHeight)
        footer!.setStatus(LCRefreshFooterStatus.Loadover)
    }
    
    /** 初始化状态 **/
    func resetDataLoad() {
        guard footer != nil else{
            return
        }
        footerView!.hidden = true
        footer!.setStatus(LCRefreshFooterStatus.Normal)
    }
}

extension UIScrollView: UIScrollViewDelegate{
    //MARK: 滑动监测
    /** 滑动相关 */
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let offSet = scrollView.contentOffset.y
        let scrollHeight = scrollView.bounds.size.height
        let inset = scrollView.contentInset
        var currentOffset = offSet + scrollHeight - inset.bottom
        let maximumOffset = scrollView.contentSize.height
        
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
            refreshObj = LCRefreshObject.Header
        }else if currentOffset - maximumOffset > 0 {
            /** 上拉刷新 */
            
            guard footer != nil else{
                return
            }
            guard footer!.refreshStatus != LCRefreshFooterStatus.Loadover else {
                return
            }

            scrollFooter(currentOffset - maximumOffset)
            refreshObj = LCRefreshObject.Footer
            
        }else{
            /** 无刷新对象 */
            refreshObj = LCRefreshObject.None
        }
    }
    
    private func scrollHeader(offSet: CGFloat) {//参数为负数
        guard header != nil else{
            print("Header加载失败")
            return
        }
        guard header!.refreshStatus != LCRefreshHeaderStatus.Refreshing else{
            return
        }
        if offSet < -LCRefreshHeaderHeight {
            header!.setStatus(LCRefreshHeaderStatus.WaitRefresh)
        }else{
            header!.setStatus(LCRefreshHeaderStatus.Normal)
        }

    }
    private func scrollFooter(offSet: CGFloat) {
        weak var weakSelf = self
        guard footer != nil else{
            print("Footer加载失败")
            return
        }
        guard footer!.refreshStatus != LCRefreshFooterStatus.Refreshing else{
            return
        }
        
        footerView!.hidden = false
        footerView!.frame = CGRectMake(LCRefreshFooterX, weakSelf!.contentSize.height, LCRefreshScreenWidth, LCRefreshFooterHeight)
        
        if offSet > LCRefreshFooterHeight {
            footer!.setStatus(LCRefreshFooterStatus.WaitRefresh)
        }else{
            footer!.setStatus(LCRefreshFooterStatus.Normal)
        }

    }
    
    /** 拖拽相关 */
    func scrollViewDragging(pan: UIPanGestureRecognizer){
        if pan.state == .Ended{
            if refreshObj == LCRefreshObject.Header {
                draggHeader()

            }else if refreshObj == LCRefreshObject.Footer{
                draggFooter()
            }
        }
    }
    
    private func draggHeader(){
        weak var weakSelf = self
        guard header != nil else{
            print("Header加载失败")
            return
        }
        if header!.refreshStatus == LCRefreshHeaderStatus.WaitRefresh {
            weakSelf!.setContentOffset(CGPointMake(0, -LCRefreshHeaderHeight), animated: true)
            header!.setStatus(LCRefreshHeaderStatus.Refreshing)
            if lcHeaderBlock != nil {
                lcHeaderBlock!()
            }
        }else if header!.refreshStatus == LCRefreshHeaderStatus.Refreshing{
            weakSelf!.setContentOffset(CGPointMake(0, -LCRefreshHeaderHeight), animated: true)
            
        }
    }
    
    private func draggFooter() {
        weak var weakSelf = self
        guard footer != nil else{
            print("Footer加载失败")
            return
        }
        if footer!.refreshStatus == LCRefreshFooterStatus.WaitRefresh {
            /** 设置scroll的contentsize 以及滑动offset **/
            let size = weakSelf!.contentSize
            weakSelf!.contentSize = CGSizeMake(size.width, size.height + LCRefreshFooterHeight)
            /** 1、数据没有充满屏幕
             2、数据已经填充满屏幕
             **/
            if size.height < weakSelf!.bounds.size.height {
                weakSelf!.setContentOffset(CGPointMake(0, 0), animated: true)
            }else{
                let offSet = weakSelf!.contentSize.height-weakSelf!.bounds.size.height
                weakSelf!.setContentOffset(CGPointMake(0, offSet), animated: true)
            }
            /** 切换状态 **/
            footer!.setStatus(LCRefreshFooterStatus.Refreshing)
            if lcFooterBlock != nil {
                lcFooterBlock!()
            }
        }
    }
    
    
}


extension UIView{
    //MARK: NIB加载工具
    
    class func instanceFromNibBundle() -> UIView? {
        
        let nib = UINib.init(nibName: String(self), bundle: nil)
        let views = nib.instantiateWithOwner(nil, options: nil)
        
        for view in views {
            if view.isMemberOfClass(self) {
                return view as? UIView
            }
        }
        
        assert(false, "Exepect file:\(String(self)).xib")
        return nil
    }

}