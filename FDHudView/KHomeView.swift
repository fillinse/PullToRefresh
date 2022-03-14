//
//  KHomeView.swift
//  FDHudView
//
//  Created by Fillinse on 2022/3/2.
//

import SwiftUI

struct KHomeView: View {

   @ObservedObject var viewModel = DCAnnouncementViewModel()

   @State var index = 1
   @State var isHeaderRefresh: Bool = false
   @State var isFooterRefresh = false

   var body: some View {
      WRNavigationBar {
         FSPullToRefreshView.init(header: FSRefreshDefaultHeader(), footer: FSRefreshDefaultFooter()) {
            ForEach(viewModel.list,id: \.self) { item in
               DCMineAnnouncementItemView(title: item.key, time: Date(timeIntervalSince1970: TimeInterval(item.gmtCreate)).yearMonthDay())
                  .listRowBackground(Color.clear)
                  .padding([.leading,.trailing],15)
                  .padding(.top,10)
            }
         }
         .background(Color.gray)
         .addPullToRefresh(isHeaderRefreshing: $isHeaderRefresh, onHeaderRefresh: loadData,isFooterRefreshing: $isFooterRefresh,onFooterRefresh: loadMore,true)
         .padding(.bottom,83)
      }
      .title("首页")
      .background(Color.white)
      .backButtonHidden(true)
   }
   func showHud() {
      FDHud.show("请求中。。。")
   }
   func loadData() {
      viewModel.startLoadData {
         isHeaderRefresh = false
      }
   }
   func loadMore() {
      viewModel.loadMore {
         isFooterRefresh = false
      }
   }
}
struct DCMineAnnouncementItemView: View {
   var title: String
   var time: String
   var body: some View {
      Group {
         ZStack {
            RoundedRectangle(cornerRadius: 6)
               .fill(Color.white)
            HStack(alignment:.top) {
               Text(title)
                  .lineLimit(2)
                  .padding(.leading, 0)
                  .alignmentGuide(.top) { d in
                     return 40
                  }
                  .font(.system(size: 14))
                  .foregroundColor(.titleColor)
               Spacer()
               Text(time)
                  .alignmentGuide(.top) { d in
                     return 40
                  }
                  .font(.system(size: 12))
                  .foregroundColor(.detailColor)
            }
            .background(Color.clear)
            .frame(height:50)
            .padding([.leading,.trailing],10)
            .padding(.top,10)
         }
         .background(Color.clear)
      }
      .background(Color.clear)
   }
}
