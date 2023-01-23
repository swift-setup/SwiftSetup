//
//  DetailView.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import SwiftUI
import PluginEngine
import RealmSwift
import PluginInterface

struct DetailPage: View {
    let plugin: any PluginInterfaceProtocol
    
    @EnvironmentObject var pluginEngine: PluginEngine
    @ObservedResults(PluginManifest.self) var plugins
    
    
    
    var body: some View {
        if let filteredPlugin = plugins.where({ $0.bundleIdentifier == plugin.manifest.bundleIdentifier }).first {
            pluginEngine.render()
                .navigationTitle(plugin.manifest.displayName)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        PopoverView {
                            Image(systemName: "info.circle.fill")
                        } popover: {
                            PluginDetailView(pluginManifest: filteredPlugin)
                        }
                    }
                }
        }
    }
}
