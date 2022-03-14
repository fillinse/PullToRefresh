//
//  KPageContentView.swift
//  FDHudView
//
//  Created by BRSX-LIUFANG on 2022/3/9.
//

import SwiftUI

struct KPageContentView: View {
   var index: Int
    var body: some View {
       VStack {
          Text("翻页详情\(index)")
          Spacer()
          Text("边上的拿大龙")
       }
    }
}
