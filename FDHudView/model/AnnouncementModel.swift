//
//  AnnouncementModel.swift
//  FDHudView
//
//  Created by BRSX-LIUFANG on 2022/3/14.
//

import SwiftUI

class DCAnnouncementViewModel: ObservableObject {
   @Published var list = [DCAnnouncementItem]()

   func startLoadData(_ end:@escaping () -> ()) {
      list.removeAll()
      loadMore(end)
   }
   func loadMore(_ end:@escaping () -> ()) {
      FDHud.showLoading()
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {[weak self] in
         FDHud.hideHud()
         var addList = [DCAnnouncementItem]()
         for i in 0..<5{
            addList.append(DCAnnouncementItem(key: "标题\(i)", value: "内容", id: i + 1, gmtCreate: Int64(Date().timeIntervalSince1970) + Int64(i * 10000)))
         }
         self?.list.append(contentsOf: addList)
         end()
      }
   }
}

struct DCAnnouncementItem: Hashable {
   var key = ""
   var value = ""
   var id = 0
   var gmtCreate: Int64 = 0
}
