//
//  FSPullToRefresh.swift
//  FSPullToRefresh
//
//  Created by Fillinse on 2022/3/7.
//

import SwiftUI

struct FSPullToRefreshView<Header, Content, Footer> {
    private let header: Header
    private let footer: Footer
    
    private let content: () -> Content
    
    @Environment(\.headerRefreshData) private var headerRefreshData
    @Environment(\.footerRefreshData) private var footerRefreshData
}

extension FSPullToRefreshView: View where Header: View, Content: View, Footer: View {
    
    init(header: Header, footer: Footer, @ViewBuilder content: @escaping () -> Content) {
        self.header = header
        self.footer = footer
        self.content = content
    }
    
    var body: some View {
       ZStack(alignment: .top) {
          ScrollView{
             VStack(spacing: 0) {
                header
                   .opacity(dynamicHeaderOpacity)
                   .frame(maxWidth: .infinity)
                   .anchorPreference(key: HeaderBoundsPreferenceKey.self, value: .bounds, transform: {
                      [.init(bounds: $0)]
                   }) // 把header的bounds加入已HeaderBoundsPreferenceKey标记的Preference中
                VStack(spacing:0) {
                   content()
                }
                   .anchorPreference(key: FooterBoundsPreferenceKey.self, value: .bounds, transform: {
                      [.init(bounds: $0)]
                   }) // 把content的bounds加入已FooterBoundsPreferenceKey标记的Preference中
                footer
                   .opacity(dynamicFooterOpacity)
                   .frame(maxWidth: .infinity)
                   .anchorPreference(key: FooterBoundsPreferenceKey.self, value: .bounds, transform: {
                      [.init(bounds: $0)]
                   }) // 把footer的frame加入已FooterBoundsPreferenceKey标记的Preference中
                // 上面content和footer的bounds都加入了FooterBoundsPreferenceKey，此时FooterBoundsPreferenceKey的value是一个有两个元素的数组：[content.bounds, footer.bounds]
             }
          }
          .padding(.top, dynamicHeaderPadding)
          .padding(.bottom, dynamicFooterPadding)
       }
    }
    
    var dynamicHeaderOpacity: Double {
        if headerRefreshData.refreshState == .invalid {
            return 0.0
        }
        if headerRefreshData.refreshState == .stopped {
            return 1
        }
        return 1.0
    }
    
    var dynamicFooterOpacity: Double {
        if footerRefreshData.refreshState == .invalid {
//            return 0.0
        }
        if footerRefreshData.refreshState == .stopped {
            // progresss = 0: 还没开始拉；progress -> 1 越接近松手加载位置progress越接近1
//            return footerRefreshData.progress == 0 ? 1.0 : footerRefreshData.progress
        }
        return 0
    }
    
    var dynamicHeaderPadding: CGFloat {
        return  -headerRefreshData.thresold
//       return (headerRefreshData.refreshState == .loading) ? 0.0 : -headerRefreshData.thresold
    }
    
    var dynamicFooterPadding: CGFloat {
        return -footerRefreshData.thresold
//       return (footerRefreshData.refreshState == .loading) ? 0.0 : -footerRefreshData.thresold
    }
}

extension FSPullToRefreshView where Header: View, Content: View, Footer == EmptyView {
    init(header: Header, @ViewBuilder content: @escaping () -> Content) {
        self.init(header: header, footer: EmptyView(), content: content)
    }
}

extension FSPullToRefreshView where Header == EmptyView, Content: View, Footer: View {
    init(footer: Footer, @ViewBuilder content: @escaping () -> Content) {
        self.init(header: EmptyView(), footer: footer, content: content)
    }
}

extension FSPullToRefreshView where Header == FSRefreshDefaultHeader, Content: View, Footer == FSRefreshDefaultFooter {
    init(@ViewBuilder content: @escaping () -> Content) {
        self.init(header: FSRefreshDefaultHeader(), footer: FSRefreshDefaultFooter(), content: content)
    }
}
