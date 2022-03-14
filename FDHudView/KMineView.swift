//
//  KMineView.swift
//  FDHudView
//
//  Created by Fillinse on 2022/3/2.
//

import SwiftUI

struct KMineView: View {
   @State var selectedIndex:Int = 0
   @State var bounds:[CGRect] = Array<CGRect>(repeating: CGRect(), count: 12)

    var body: some View {
       ZStack (alignment: .topLeading){
          RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 3.0).foregroundColor(Color.green)
             .frame(width: bounds[selectedIndex].size.width, height: bounds[selectedIndex].size.height)
             .offset(x: bounds[selectedIndex].minX, y: bounds[selectedIndex].minY)
             .animation(.easeInOut(duration: 1.0))
          VStack() {
             Spacer()
             HStack {
                MonthView(title: "January",index: 0,selectIndex: $selectedIndex)
                MonthView(title: "February",index: 1,selectIndex: $selectedIndex)
                MonthView(title: "March",index: 2,selectIndex: $selectedIndex)
                MonthView(title: "April",index: 3,selectIndex: $selectedIndex)
             }
             Spacer()
             HStack {
                MonthView(title: "May",index: 4,selectIndex: $selectedIndex)
                MonthView(title: "June",index: 5,selectIndex: $selectedIndex)
                MonthView(title: "July",index: 6,selectIndex: $selectedIndex)
                MonthView(title: "August",index: 7,selectIndex: $selectedIndex)
             }
             Spacer()
             HStack {
                MonthView(title: "September",index: 8,selectIndex: $selectedIndex)
                MonthView(title: "October",index: 9,selectIndex: $selectedIndex)
                MonthView(title: "November",index: 10,selectIndex: $selectedIndex)
                MonthView(title: "December",index: 11,selectIndex: $selectedIndex)
             }
             Spacer()
          }
          .onPreferenceChange(MonthPrefrenceKey.self) { value in
             for p in value {
                self.bounds[p.index] = p.rect
             }
          }
       }
       .coordinateSpace(name: "myStack")
    }
}

struct MonthView: View {
   var title: String
   var index: Int
   @Binding var selectIndex: Int

   var body: some View {
      Text(title)
         .font(.system(size: 16))
         .padding()
         .background(MonthBoard(index: index))
         .onTapGesture {
            selectIndex = index
         }
   }
}

struct MonthBoard: View {
   let index: Int
   var body: some View {
      GeometryReader { gery in
         RoundedRectangle(cornerRadius: 4)
            .foregroundColor(.clear)
            .preference(key: MonthPrefrenceKey.self, value: [MonthPreferenceData(index: index, rect: gery.frame(in: .named("myStack")))])
      }
   }
}

struct MonthPreferenceData: Equatable {
   let index: Int
   let rect: CGRect
}
struct MonthPrefrenceKey: PreferenceKey {
   static var defaultValue: [MonthPreferenceData] = []

   typealias Value = [MonthPreferenceData]

   static func reduce(value: inout [MonthPreferenceData], nextValue: () -> [MonthPreferenceData]) {
      value.append(contentsOf: nextValue())
   }
}
