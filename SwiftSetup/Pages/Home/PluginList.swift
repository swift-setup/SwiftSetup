//
//  PluginList.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import SwiftUI
import PluginEngine
import RealmSwift

struct PluginList: View {
    @EnvironmentObject var pluginEngine: PluginEngine
    @ObservedResults(PluginManifest.self) var projects
    
    @Binding var selection: UUID?
    
    var body: some View {
        List(pluginEngine.plugins, id: \.id, selection: $selection) { plugin in
            NavigationLink(plugin.manifest.displayName, value: plugin.id)
        }
    }
}
