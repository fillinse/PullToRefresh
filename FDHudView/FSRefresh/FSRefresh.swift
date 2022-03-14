//
//  FSRefresh.swift
//  FDHudView
//
//  Created by BRSX-LIUFANG on 2022/3/3.
//

enum FSRefreshState {
   case normal
   case pull
   case refreshing
}
import SwiftUI

final class FSRefresh: ObservableObject {
   var lastRefreshTime: Date?
}
