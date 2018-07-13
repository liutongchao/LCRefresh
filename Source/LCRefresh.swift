//
//  LCRefresh.swift
//  LCRefresh
//
//  Created by 刘通超 on 16/8/2.
//  Copyright © 2016年 West. All rights reserved.
//

import UIKit

//MARK: - /** 动态绑定属性 **/
extension UIScrollView{
    /** 当前刷新 header of footer **/
    var refreshObj: LCRefreshObject {
        get{
            let result = getAssociated(key: LCRefresh.Object.current)
            guard result != nil else {
                return .none
            }
            return result as! LCRefreshObject
        }
        set{
            setAssociated(key: LCRefresh.Object.current, object: newValue)
        }
        
    }
    /** 上次刷新对象 **/
    var lastRefreshObj: LCRefreshObject {
        get{
            let result = getAssociated(key: LCRefresh.Object.last)
            guard result != nil else {
                return .none
            }
            return result as! LCRefreshObject
        }
        set{
            setAssociated(key: LCRefresh.Object.last, object: newValue)
        }
        
    }
    
    /** header **/
    public var refreshHeader: LCBaseRefreshHeader? {
        get{
            let result = getAssociated(key: LCRefresh.Object.header) as? LCBaseRefreshHeader

            return result
        }
        set{
            guard newValue != nil else { return }
            setAssociated(key: LCRefresh.Object.header, object: newValue!)
            
            guard let header = getAssociated(key: LCRefresh.Object.header) as? LCBaseRefreshHeader else { return }
            self.addSubview(header)
            
            //添加滑动监测
            self.panGestureRecognizer.addTarget(self, action: #selector(UIScrollView.scrollViewDragging(_:)))
        }
        
    }
    /** footer **/
    public var refreshFooter: LCRefreshFooter? {
        get{
            let result = getAssociated(key: LCRefresh.Object.footer) as? LCRefreshFooter
            return result
        }
        set{
            guard newValue != nil else { return }
            setAssociated(key: LCRefresh.Object.footer, object: newValue!)

            guard let footer = getAssociated(key: LCRefresh.Object.footer) as? LCRefreshFooter else { return }
            footer.isHidden = true
            self.addSubview(footer)
            
            //添加滑动监测
           self.panGestureRecognizer.addTarget(self, action: #selector(UIScrollView.scrollViewDragging(_:)))
        }
        
    }
}
//MARK: - /** 动态绑定相关 **/
extension UIScrollView{
    /** 动态绑定相关 **/
    fileprivate func getAssociated(key:String) -> Any?{
        let assKey = UnsafeRawPointer.init(bitPattern: key.hashValue)
        let result = objc_getAssociatedObject(self, assKey!)
        return result
    }
    
    fileprivate func setAssociated(key:String, object:Any){
        let assKey = UnsafeRawPointer.init(bitPattern: key.hashValue)
        objc_setAssociatedObject(self, assKey!, object, .OBJC_ASSOCIATION_RETAIN)
    }
}

//MARK: - /** Header 相关 */
extension UIScrollView{
    //MARK: /** Header 相关 */
    /** header 刷新状态 */
    public func isHeaderRefreshing() -> Bool {
        guard let header = self.refreshHeader else {
            return false
        }
        
        return header.refreshStatus == .refreshing ? true: false
    }
    
    /** header 结束刷新 */
    public func endHeaderRefreshing() {
        guard let header = self.refreshHeader else { return }
        
        //在nav下会产生top偏移
        var insetTop = self.contentInset.top
        if #available(iOS 11.0, *) {//适配iOS 11
            insetTop = self.adjustedContentInset.top
        }
        if self.lastRefreshObj == .header || self.lastRefreshObj == .none{
            //这里没有使用  setContentOffset()
            //是因为首次刷新的时候会造成table 的上移
            UIView.animate(withDuration: 0.3) {
                self.contentOffset = CGPoint(x: 0, y: -insetTop)
            }
        }
        header.setRefreshStatus(status: .end)

        lastRefreshObj = .header
    }
}

//MARK: - /** Footer 相关 */
extension UIScrollView{
    //MARK: /** Footer 相关 */
    /** footer 刷新状态 */
    public func isFooterRefreshing() -> Bool {
        guard let footer = self.refreshFooter else {
            return false
        }
        
        return footer.refreshStatus == .refreshing ? true: false
    }

    /** footer 结束刷新 */
    public func endFooterRefreshing() {
        guard let footer = self.refreshFooter else { return }
        let size = self.contentSize
        self.contentSize = CGSize(width: size.width, height: size.height - LCRefresh.Const.Footer.height)
        
        /** 1、数据没有充满屏幕
            2、数据已经填充满屏幕 **/
 
        if size.height < self.bounds.size.height {
            self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }else{
            let offSet = self.contentSize.height - self.bounds.size.height
            self.setContentOffset(CGPoint(x: 0, y: offSet), animated: true)
        }
        footer.isHidden = true
        footer.setStatus(LCRefreshFooterStatus.normal)
        
        lastRefreshObj = .footer
    }
}

//MARK: - /** 数据加载完毕状态 **/
extension UIScrollView{
    //MARK: /** 数据加载完毕状态 **/
    public func setDataLoadover() {
        guard let footer = self.refreshFooter else {
            return
        }
        
        let size = self.contentSize
        footer.frame = CGRect(x: LCRefresh.Const.Footer.X, y: size.height, width: LCRefresh.Const.Common.screenWidth, height: LCRefresh.Const.Footer.height)
        footer.setStatus(.loadover)
        
        if size.height < self.bounds.size.height {
            //未充满屏幕则隐藏
            footer.isHidden = true
        }else{
            footer.isHidden = false
        }
        
    }
    
    /** 初始化状态 **/
    public func resetDataLoad() {
        guard let footer = self.refreshFooter else {
            return
        }
        footer.isHidden = true
        footer.setStatus(.normal)
    }
}

//MARK: - 滑动监测
extension UIScrollView{
    //MARK: 滑动监测
    func scrollHeader(_ offSet: CGFloat) {//参数为负数
        guard let header = self.refreshHeader, header.refreshStatus != .refreshing else{
            return
        }
        
        //在nav下会产生top偏移
        var insetTop = self.contentInset.top
        if #available(iOS 11.0, *) {//适配iOS 11
            insetTop = self.adjustedContentInset.top
        }
        if offSet + insetTop < -LCRefresh.Const.Header.height {
            
            header.setRefreshStatus(status: .waitRefresh)
            
        }else if offSet + insetTop == 0 {
            
            header.setRefreshStatus(status: .normal)

        }else {
            guard header.refreshStatus != .end else{
                return
            }
            header.setRefreshStatus(status: .normal)
        }

    }
    
    func scrollFooter(_ offSet: CGFloat) {
        guard let footer = self.refreshFooter, footer.refreshStatus != .refreshing || footer.refreshStatus != .loadover else{
            return
        }
        footer.isHidden = false
        footer.frame = CGRect(x: LCRefresh.Const.Footer.X, y: self.contentSize.height, width: LCRefresh.Const.Common.screenWidth, height: LCRefresh.Const.Footer.height)
        
        if offSet > LCRefresh.Const.Footer.height {
            footer.setStatus(.waitRefresh)
        }else{
            footer.setStatus(.normal)
        }
    }
    
    /** 拖拽相关 */
    @objc func scrollViewDragging(_ pan: UIPanGestureRecognizer){
        switch pan.state {
        case .changed:
            draggChanged()
        case .ended:
            if self.refreshObj == .header {
                draggHeader()
                
            }else if self.refreshObj == .footer{
                draggFooter()
            }
        default:
            break
        }
    }
    
    func draggChanged() {
        let offSet = self.contentOffset.y
        let scrollHeight = self.bounds.size.height
        var inset = self.contentInset
        if #available(iOS 11.0, *) {//适配iOS 11
            inset = self.adjustedContentInset
        }
        
        var currentOffset = offSet + scrollHeight - inset.bottom
        let maximumOffset = self.contentSize.height
        
        /** 数据未充满屏幕的情况 **/
        if maximumOffset < scrollHeight {
            currentOffset = offSet + maximumOffset - inset.bottom
        }
        
        if offSet < 0 {
            /** 下拉刷新 */
            guard self.refreshHeader != nil else{
                return
            }
            scrollHeader(offSet)
            self.refreshObj = LCRefreshObject.header
    
        }else if currentOffset - maximumOffset > 0 {
            /** 上拉刷新 */
            guard let footer = self.refreshFooter,  footer.refreshStatus != .loadover else {
                return
            }
            
            scrollFooter(currentOffset - maximumOffset)
            self.refreshObj = .footer
            
        }else{
            /** 无刷新对象 */
            self.refreshObj = .none
        }
    }
    
    func draggHeader(){
        guard let header = self.refreshHeader else{ return }
        //在nav下会产生top偏移
        var insetTop = self.contentInset.top
        if #available(iOS 11.0, *) {//适配iOS 11
            insetTop = self.adjustedContentInset.top
        }
        
        if header.refreshStatus == .waitRefresh {
            self.setContentOffset(CGPoint(x: 0, y: -(LCRefresh.Const.Header.height+insetTop)), animated: true)
            header.setRefreshStatus(status: .refreshing)
            if header.refreshBlock != nil{
                header.refreshBlock!()
            }
        }
    }
    
    func draggFooter() {
        guard let footer = self.refreshFooter else{ return }
        if footer.refreshStatus == .waitRefresh {
            /** 设置scroll的contentsize 以及滑动offset **/
            let size = self.contentSize
            self.contentSize = CGSize(width: size.width, height: size.height + LCRefresh.Const.Footer.height)
            
            /** 1、数据没有充满屏幕
             2、数据已经填充满屏幕
             **/
            if size.height < self.bounds.size.height {
                self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }else{
                let offSet = self.contentSize.height - self.bounds.size.height
                self.setContentOffset(CGPoint(x: 0, y: offSet), animated: true)
            }
            /** 切换状态 **/
            footer.setStatus(.refreshing)
            
            if footer.refreshBlock != nil {
                footer.refreshBlock!()
            }
        }
    }
    
}

