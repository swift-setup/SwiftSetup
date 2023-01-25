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
    @StateObject var swiftSetupPluginViewModel = PluginStore()
    @StateObject var uiViewModel = UIViewModel()
    @StateObject var fileUtils = FileUtils()
    @StateObject var nsPanel = NSPanelUtils()
    
    var body: some Scene {
        WindowGroup {
            HomePage()
                .environmentObject(pluginEngine)
                .environmentObject(sheetContext)
                .environmentObject(swiftSetupPluginViewModel)
                .environmentObject(uiViewModel)
                .environmentObject(fileUtils)
                .environmentObject(nsPanel)
        }.commands {
            OpenPluginCommand(pluginEngine: pluginEngine, sheetContext: sheetContext, store: swiftSetupPluginViewModel, uiModel: uiViewModel)
            PluginCommand(pluginEngine: pluginEngine, sheetContext: sheetContext)
        }
    }
}
