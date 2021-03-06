//
//  FSPullToRefreshModifier.swift
//  FSPullToRefresh
//
//  Created by Fillinse on 2022/3/7.
//

import SwiftUI

extension View {
    func addPullToRefresh(isHeaderRefreshing: Binding<Bool>?, onHeaderRefresh: (() -> Void)?,_ autoLoad: Bool = false) -> some View {
        addPullToRefresh(isHeaderRefreshing: isHeaderRefreshing, onHeaderRefresh: onHeaderRefresh, isFooterRefreshing: nil, onFooterRefresh: nil,autoLoad)
    }
    
    func addPullToRefresh(isFooterRefreshing: Binding<Bool>?, onFooterRefresh: (() -> Void)?,_ autoLoad: Bool = false) -> some View {
        addPullToRefresh(isHeaderRefreshing: nil, onHeaderRefresh: nil, isFooterRefreshing: isFooterRefreshing, onFooterRefresh: onFooterRefresh,autoLoad)
    }
    
    func addPullToRefresh(isHeaderRefreshing: Binding<Bool>?, onHeaderRefresh: (() -> Void)?, isFooterRefreshing: Binding<Bool>?, onFooterRefresh: (() -> Void)?,_ autoLoad: Bool = false) -> some View {
        modifier(FSPullToRefreshModifier(isHeaderRefreshing: isHeaderRefreshing, isFooterRefreshing: isFooterRefreshing, onHeaderRefresh: onHeaderRefresh, onFooterRefresh: onFooterRefresh,autoLoad))
    }
}


struct FSPullToRefreshModifier: ViewModifier {
   @Binding var isHeaderRefreshing: Bool {
      didSet {
         if isHeaderRefreshing == true {
            onHeaderRefresh?()
            withAnimation(.easeInOut(duration: 1)) {
               headerRefreshData.refreshState = .loading
            }
         }
      }
   }
   @Binding var isFooterRefreshing: Bool {
      didSet {
         if isFooterRefreshing == true {
            onFooterRefresh?()
            withAnimation(.easeInOut(duration: 1)) {
               footerRefreshData.refreshState = .loading
            }
         }
      }
   }
   private var autoLoad = false
    
   private let onHeaderRefresh: (() -> Void)?
   private let onFooterRefresh: (() -> Void)?
    
   init(isHeaderRefreshing: Binding<Bool>?, isFooterRefreshing: Binding<Bool>?, onHeaderRefresh: (() -> Void)?, onFooterRefresh: (() -> Void)?,_ autoLoad: Bool = false) {
        self._isHeaderRefreshing = isHeaderRefreshing ?? .constant(false)
        self._isFooterRefreshing = isFooterRefreshing ?? .constant(false)
        self.onHeaderRefresh = onHeaderRefresh
        self.onFooterRefresh = onFooterRefresh
        self.autoLoad = autoLoad
    }
    
    @State private var headerRefreshData = RefreshData()
    @State private var footerRefreshData = RefreshData()
    
    func body(content: Content) -> some View {
        GeometryReader { proxy in
            content
                .environment(\.headerRefreshData, headerRefreshData)
                .environment(\.footerRefreshData, footerRefreshData)
                .onChange(of: isHeaderRefreshing, perform: { value in
                    if !value {
//                       withAnimation(.easeInOut(duration: 1)) {
                          self.headerRefreshData.refreshState = .stopped
//                       }
                    }
                })
                .onChange(of: isFooterRefreshing, perform: { value in
                    if !value {
                       withAnimation(.easeInOut(duration: 1)) {
                          self.footerRefreshData.refreshState = .stopped
                       }
                    }
                })
                .backgroundPreferenceValue(HeaderBoundsPreferenceKey.self) { value -> Color in
                    DispatchQueue.main.async {
                        calculateHeaderRefreshState(proxy, value: value)
                    }
                    return Color.clear // ????????????????????????????????????????????????????????????????????????calculateHeaderRefreshState??????
                }
                .backgroundPreferenceValue(FooterBoundsPreferenceKey.self) { value -> Color in
                    // ????????????FooterBoundsPreferenceKey?????????Preference????????????value=[content.bounds, footer.bounds]
                    DispatchQueue.main.async {
                        calculateFooterRefreshState(proxy, value: value)
                    }
                    return Color.clear
                }
        }
        .onAppear {
           if autoLoad {
              isHeaderRefreshing = true
           }
        }
    }
}

extension FSPullToRefreshModifier {
    private func calculateHeaderRefreshState(_ proxy: GeometryProxy, value: [HeaderBoundsPreferenceKey.Item]) {
        guard let bounds = value.first?.bounds else {
            return
        }
        
        // caculate state
       guard headerRefreshData.refreshState != .loading else {
            return
        }
        let headerFrame = proxy[bounds] // we need geometry proxy to get real frame
        
        let y = headerFrame.minY
        let threshold = headerFrame.height
        let topDistance: CGFloat = 30.0
        if threshold != headerRefreshData.thresold {
            headerRefreshData.thresold = threshold
        }
       if -y == headerRefreshData.thresold && headerFrame.width == proxy.size.width  {
            headerRefreshData.refreshState = .stopped
           headerRefreshData.isLoad = false
        }
        
        var contentOffset = y + threshold
        guard contentOffset > topDistance else {
            return
        }
        
       contentOffset -= topDistance
       headerRefreshData.isBack = contentOffset < headerRefreshData.lastY
       headerRefreshData.lastY = contentOffset
        
        if contentOffset > threshold && headerRefreshData.refreshState == .stopped{
           if !headerRefreshData.isLoad {
              withAnimation(.easeInOut(duration: 1)) {
                 headerRefreshData.refreshState = .triggered
              }
           }
        }
        
       if contentOffset <= threshold && headerRefreshData.refreshState == .triggered {
          if !headerRefreshData.isLoad && headerRefreshData.isBack {
             headerRefreshData.isLoad = true
             isHeaderRefreshing = true
          }
        }
    }
    
    private func calculateFooterRefreshState(_ proxy: GeometryProxy, value: [FooterBoundsPreferenceKey.Item]) {
        // value = [content.bounds, footer.bounds]
        guard let bounds = value.last?.bounds else {
            return
        }
        guard let contentBounds = value.first?.bounds else {
            return
        }
                
        guard footerRefreshData.refreshState != .loading else {
            return
        }
        
        let footerFrame = proxy[bounds]
        let contentFrame = proxy[contentBounds]
        
//        let contentTop = contentFrame.minY // ???????????????0?????????????????????
        let y = footerFrame.minY
        let threshold = footerFrame.height
        let bottomDistance: CGFloat = 20.0
        
        let scrollViewHeight = min(proxy.size.height, contentFrame.height) // ????????????????????????????????????????????????????????????????????????????????????
        
        if threshold != footerRefreshData.thresold {
            footerRefreshData.thresold = threshold
        }
        
        if y >= footerRefreshData.thresold && footerFrame.width == proxy.size.width && footerRefreshData.refreshState == .invalid {
            footerRefreshData.refreshState = .stopped
        }
        
        var contentOffset = scrollViewHeight - y
        
        guard contentOffset > bottomDistance else {
            return
        }
        
        contentOffset -= bottomDistance
       print("contentOffset--\(contentOffset)----threshold--\(threshold)------y--\(y)-------proxy--\(proxy.size)")
        if contentOffset > threshold && footerRefreshData.refreshState == .stopped{
            // ?????????????????????????????????
            // 1. ???????????????????????????threshold(=footer?????????)
            // 2. ????????????????????????????????????
            // 3. ?????????????????????==.stopped???
           withAnimation {
              footerRefreshData.refreshState = .triggered
           }
        }
        
        if contentOffset <= threshold && footerRefreshData.refreshState == .triggered{
            // ???????????????????????????
            // 1. ??????????????????????????????==.triggered???
            // 2. ???????????????????????????threshold(=footer?????????)/??????????????????????????????????????????list?????????????????????
            isFooterRefreshing = true
        }
    }
}
