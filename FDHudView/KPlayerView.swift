//
//  KPlayerView.swift
//  FDHudView
//
//  Created by Fillinse on 2022/3/2.
//

import SwiftUI

struct KPlayerView: View {
   @State var numbers:[Int] = [23,45,76,54,76,3465,24,423]
   @State var state: Bool = false
   var body: some View {
      VStack {
         ForEach(self.numbers, id: \.self){ number in
            VStack(alignment: .leading){
               Text("\(number)")
               Divider()
            }
         }
      }
   }
   func generateRandomNumbers() -> [Int] {
      var sequence = [Int]()
      for _ in 0...30 {
         sequence.append(Int.random(in: 0 ..< 100))
      }
      return sequence
   }
}

struct KPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        KPlayerView()
    }
}
