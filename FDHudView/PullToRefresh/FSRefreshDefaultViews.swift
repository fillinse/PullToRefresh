//
//  FSRefreshDefaultViews.swift
//  FSPullToRefresh
//
//  Created by Fillinse on 2022/3/7.
//

import SwiftUI

class FSListState: ObservableObject {
    @Published private(set) var noMore: Bool
    
    init() {
        noMore = false
    }
    
    func setNoMore(_ newNoMore: Bool) {
        noMore = newNoMore
    }
}

struct FSRefreshDefaultHeader: View {
    
    @Environment(\.headerRefreshData) private var headerRefreshData
    
    var body: some View {
        let state = headerRefreshData.refreshState
       ZStack{
           if state == .stopped {
                 VStack(spacing: 0){
                    Text("下拉可以刷新")
                       .font(.system(size: 12))
                       .padding()
                       .frame(height: 20)
                    Spacer().frame(height: 5)
                    Text("最后更新：\(headerRefreshData.lastDate.dateString("yyyy-MM-dd HH:mm:ss"))") // 已经到底了
                       .font(.system(size: 12))
                       .padding()
                       .frame(height: 20)
                 }
              }
           if state == .triggered {
              VStack(spacing: 0){
                 Text("松开立即刷新")
                    .font(.system(size: 12))
                    .padding()
                    .frame(height: 20)
                 Spacer().frame(height: 5)
                 Text("最后更新：\(headerRefreshData.lastDate.dateString("yyyy-MM-dd HH:mm:ss"))") // 已经到底了
                    .font(.system(size: 12))
                    .padding()
                    .frame(height: 20)
              }
           }
          if state == .loading {
             VStack {
                Text("正在刷新数据中...")
                   .font(.system(size: 12))
                   .padding()
                   .frame(height: 20)
                Spacer().frame(height: 5)
                Text("最后更新：\(headerRefreshData.lastDate.dateString("yyyy-MM-dd HH:mm:ss"))") // 已经到底了
                   .font(.system(size: 12))
                   .padding()
                   .frame(height: 20)
             }
          }
           if state == .invalid {
               Spacer()
                   .padding()
                   .frame(height: 45)
           }
       }
    }
}

struct FSRefreshDefaultFooter: View {
    
    @Environment(\.footerRefreshData) private var footerRefreshData

    var body: some View {
        let state = footerRefreshData.refreshState
       ZStack {
          if state == .stopped {
             VStack(spacing: 0){
                Text("上拉加载更多") // 已经到底了
                   .font(.system(size: 12))
                   .padding()
                   .frame(height: 20)
                Spacer().frame(height: 5)
                Text("最后更新：\(footerRefreshData.lastDate.dateString("yyyy-MM-dd HH:mm:ss"))") // 已经到底了
                   .font(.system(size: 12))
                   .padding()
                   .frame(height: 20)
             }
          }
          if state == .triggered {
             VStack(spacing: 0){
                Text("松开立即刷新") // 已经到底了
                   .font(.system(size: 12))
                   .padding()
                   .frame(height: 20)
                Spacer().frame(height: 5)
                Text("最后更新：\(footerRefreshData.lastDate.dateString("yyyy-MM-dd HH:mm:ss"))") // 已经到底了
                   .font(.system(size: 12))
                   .padding()
                   .frame(height: 20)
             }
          }
          if state == .loading {
             VStack {
                Text("正在刷新数据中...")
                   .font(.system(size: 12))
                   .padding()
                   .frame(height: 20)
                Spacer().frame(height: 5)
                Text("最后更新：\(footerRefreshData.lastDate.dateString("yyyy-MM-dd HH:mm:ss"))") // 已经到底了
                   .font(.system(size: 12))
                   .padding()
                   .frame(height: 20)
             }
          }
          if state == .invalid {
             Spacer()
                .padding()
                .frame(height: 45)
          }
       }
       .background(Color.blue)
    }
    
    private func printLog(_ state: RefreshState) -> some View {
        print("\(state)")
        return EmptyView()
    }
}
