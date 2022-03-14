//
//  FSPageView.swift
//  FDHudView
//
//  Created by BRSX-LIUFANG on 2022/3/9.
//

import SwiftUI


struct FSPageView<Content> {

   private let content: () -> Content
   private let names: [String]
   private let color: Color
   private let selectedColor: Color
   private let font: Font
   private let selectedFont: Font
   private let background: Color
   @Binding var selectedIndex:Int
   @State var bounds:[CGRect] = Array<CGRect>(repeating: CGRect(), count: 12)

}
extension FSPageView: View where Content: View {

   init(names: [String],selectedIndex: Binding<Int>,color: Color = .gray,selectedColor: Color = .blue,font: Font = .system(size: 16),selectedFont: Font = .system(size: 16),background: Color = .white,@ViewBuilder content:@escaping () -> Content) {
      self.content = content
      self.names = names
      self._selectedIndex = selectedIndex
      self.color = color
      self.selectedColor = selectedColor
      self.font = font
      self.selectedFont = selectedFont
      self.background = background
   }
   var body: some View {
      VStack(spacing:0) {
         ZStack {
            GeometryReader { reader in
               HStack(alignment: .center,spacing:0) {
                  ForEach(0..<names.count) { i in
                     GeometryReader { geo in
                        Button {
//                           withAnimation {
                              selectedIndex = i
//                           }
                        } label: {
                           VStack(alignment: .center) {
                              Text("\(names[i])")
                                 .foregroundColor(selectedIndex == i ? color : selectedColor)
                                 .font(selectedIndex == i ? font : selectedFont)
                                 .frame(height:40)
                           }
                        }
                        .frame(width: reader.size.width * ( 1.0 / CGFloat(names.count)))
                        .preference(key: FSPageViewPrefrenceKey.self, value: [FSPageViewPreferenceData(index:i,rect: geo.frame(in: .named("FSHStack")))])
                     }
                  }
               }
               .background(background)
            }
            Rectangle()
               .fill(Color.blue)
               .frame(width: bounds[selectedIndex].size.width, height: 2)
               .position(x: bounds[selectedIndex].midX, y: bounds[selectedIndex].maxY - 2)
               .animation(.easeInOut(duration: 1))
         }
         .coordinateSpace(name: "FSHStack")
         .onPreferenceChange(FSPageViewPrefrenceKey.self) { value in
            for p in value {
               self.bounds[p.index] = p.rect
            }
         }
         .frame(height:40)
         TabView(selection: $selectedIndex){
            content()
         }
         .tabViewStyle(.page(indexDisplayMode: .never))
      }
      .onAppear {
         selectedIndex = 0
      }
   }
}
struct FSPageViewPreferenceData: Equatable {
   let index: Int
   let rect: CGRect
}
struct FSPageViewPrefrenceKey: PreferenceKey {
   static var defaultValue: [FSPageViewPreferenceData] = []

   typealias Value = [FSPageViewPreferenceData]

   static func reduce(value: inout [FSPageViewPreferenceData], nextValue: () -> [FSPageViewPreferenceData]) {
      value.append(contentsOf: nextValue())
   }
}
