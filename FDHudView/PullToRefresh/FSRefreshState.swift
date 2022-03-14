//
//  FSRefreshState.swift
//  FSPullToRefresh
//
//  Created by Fillinse on 2022/3/7.
//

import SwiftUI

// MARK: - Preferences

struct HeaderBoundsPreferenceKey: PreferenceKey {
    struct Item {
        let bounds: Anchor<CGRect>
    }
    static var defaultValue: [Item] = []
    
    // 每次有新的init(bounds)就加入value数组
    static func reduce(value: inout [Item], nextValue: () -> [Item]) {
        value.append(contentsOf: nextValue())
    }
}

struct FooterBoundsPreferenceKey: PreferenceKey {
    struct Item {
        let bounds: Anchor<CGRect>
    }
    static var defaultValue: [Item] = []
    
    static func reduce(value: inout [Item], nextValue: () -> [Item]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - Environment

struct HeaderRefreshDataKey: EnvironmentKey {
    static var defaultValue: RefreshData = .init()
}

struct FooterRefreshDataKey: EnvironmentKey {
    static var defaultValue: RefreshData = .init()
}

extension EnvironmentValues {
    var headerRefreshData: RefreshData {
        get { self[HeaderRefreshDataKey.self] }
        set { self[HeaderRefreshDataKey.self] = newValue }
    }
    
    var footerRefreshData: RefreshData {
        get { self[FooterRefreshDataKey.self] }
        set { self[FooterRefreshDataKey.self] = newValue }
    }
}

// MARK: - Refresh State Data

enum RefreshState: Int {
    case invalid // 初始化
    case stopped // 停止
    case triggered // 拖动等待刷新
    case loading // 加载中
}

struct RefreshData {
    var thresold: CGFloat = 0
    var lastDate:Date = Date()
    var refreshState: RefreshState = .invalid
    ///一次拖动过程中只加载一次
    var isLoad = false
    ///回弹过程中到达触发点才进行加载
    var lastY: CGFloat = 0
    var isBack = false
}
