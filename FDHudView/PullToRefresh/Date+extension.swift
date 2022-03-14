//
//  Date+extension.swift
//  FSPullToRefresh
//
//  Created by Fillinse on 2022/3/7.
//

import Foundation
extension Date {
   func dateString(_ style:String) -> String{
      let formatter = DateFormatter()
      formatter.dateFormat = style
      return formatter.string(from: self)
   }
   static func dateFromTime(_ time:TimeInterval) -> Date{
      let date = Date.init(timeIntervalSince1970: TimeInterval(time/1000))
      return date
   }
   func yearMonthDay() -> String{
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter.string(from: self)
   }
}
