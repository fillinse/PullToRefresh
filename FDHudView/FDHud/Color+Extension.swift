//
//  Color+Extension.swift
//  FDHudView
//
//  Created by Fillinse on 2022/3/2.
//

import SwiftUI

extension Color {
   static func hex(_ hex: Int) -> Color {
      return Color(UIColor.init(hex: hex)!)
   }
   static func hex(_ hex: Int,_ alpha: Float) -> Color {
      return Color(UIColor.init(hex: hex, transparency: CGFloat(alpha))!)
   }
}
extension UIColor{
   convenience init?(hex: Int, transparency: CGFloat = 1) {
      var trans = transparency
      if trans < 0 { trans = 0 }
      if trans > 1 { trans = 1 }

      let red = (hex >> 16) & 0xff
      let green = (hex >> 8) & 0xff
      let blue = hex & 0xff
      self.init(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: trans)
   }
   convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
      guard red >= 0 && red <= 255 else { return nil }
      guard green >= 0 && green <= 255 else { return nil }
      guard blue >= 0 && blue <= 255 else { return nil }

      var trans = transparency
      if trans < 0 { trans = 0 }
      if trans > 1 { trans = 1 }

      self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
   }
   class func hex(_ hex: Int) -> UIColor {
      return UIColor.init(hex: hex)!
   }
   class func hex(_ hex: Int,_ alpha: Float) -> UIColor {
      return UIColor.init(hex: hex, transparency: CGFloat(alpha))!
   }
}

extension Color {
   static var titleColor: Color {
      Color.hex(0x313A5D)
   }
   static var titleBlack: Color {
      Color.hex(0x121212)
   }
   static var subTitleColor: Color {
      Color.hex(0x60646E)
   }
   static var detailColor: Color {
      Color.hex(0x868686)
   }
   static var grayColor: Color {
      Color.hex(0xB4B4B4)
   }
   static var mainBlue: Color {
      Color.hex(0x0081FF)
   }
   static var littleBlue: Color {
      Color.hex(0xCDE5FF)
   }
   static var lineGray: Color {
      Color.hex(0xf0f0f0)
   }
   static var orangeBack: Color {
      Color.hex(0xFFF2E6)
   }
   static var orangeStatus: Color {
      Color.hex(0xFDA141)
   }
   static var redBack: Color {
      Color.hex(0xFE4D4F)
   }
   static var matchGreen: Color {
      Color.hex(0x53CCDA)
   }
   /// DCC5A0
   static var littleGold: Color {
      Color.hex(0xDCC5A0)
   }
}
