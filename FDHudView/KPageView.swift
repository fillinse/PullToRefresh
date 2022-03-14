//
//  KPageView.swift
//  FDHudView
//
//  Created by BRSX-LIUFANG on 2022/3/9.
//

import SwiftUI

struct KPageView: View {
   @State var selectedIndex = 0
    var body: some View {
       FSPageView(names: ["推广","服务","公交车","电视行业","都"], selectedIndex: $selectedIndex, color: .gray, selectedColor: .red, font: .system(size: 12), selectedFont: .system(size: 16), background: .white) {
          ForEach(0..<5){ i in
             KPageContentView(index: i)
                .background(Color.blue)
                .tag(i)
          }
       }
    }
}

struct KPageView_Previews: PreviewProvider {
    static var previews: some View {
        KPageView()
    }
}
