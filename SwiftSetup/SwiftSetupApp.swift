//
//  SwiftSetupApp.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import SwiftUI
import PluginEngine
import SwiftUIKit

@main
struct SwiftSetupApp: App {
    @StateObject var pluginEngine = PluginEngine()
    @StateObject var sheetContext = SheetContext()
    @StateObject var swiftSetupPluginViewModel = SwiftSetupPluginViewModel()
    @StateObject var uiViewModel = UIViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomePage()
                .environmentObject(pluginEngine)
                .environmentObject(sheetContext)
                .environmentObject(swiftSetupPluginViewModel)
                .environmentObject(uiViewModel)
        }.commands {
            OpenPluginCommand(pluginEngine: pluginEngine, sheetContext: sheetContext)
            PluginCommand(pluginEngine: pluginEngine, sheetContext: sheetContext)
        }
    }
}
