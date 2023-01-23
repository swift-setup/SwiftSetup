//
//  PluginList.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import SwiftUI
import PluginEngine
import RealmSwift
import PluginInterface
import SwiftUIKit

struct PluginList: View {
    @EnvironmentObject var pluginEngine: PluginEngine
    @EnvironmentObject var store: PluginStore
    @EnvironmentObject var uiModel: UIViewModel
    @EnvironmentObject var sheeContext: SheetContext
    
    @ObservedResults(PluginManifest.self) var projects
    
    @Binding var selection: UUID?
    
    var body: some View {
        List(pluginEngine.plugins, id: \.id, selection: $selection) { plugin in
            NavigationLink(plugin.manifest.displayName, value: plugin.id)
                .contextMenu {
                    Button("Delete plugin") {
                        delete(plugin: plugin)
                    }
                }
        }
        .contextMenu {
            Button("Add plugin") {
                add()
            }
        }
    }
    
    func add() {
        sheeContext.present(RemotePluginView())
    }
    
    func delete(plugin: any PluginInterfaceProtocol) {
        do {
            let confirmed = uiModel.confirm(title: "Delete plugin \(plugin.manifest.bundleIdentifier)", subtitle: "This operation cannot be revert", confirmButtonText: "OK", cancelButtonText: "Cancel", alertStyle: .informational)
            
            if !confirmed {
                return
            }
            
            try store.deletePlugin(by: plugin.manifest.bundleIdentifier)
            pluginEngine.removePlugin(plugin: plugin)
        } catch {
            uiModel.alert(title: "Cannot delete plugin", subtitle: error.localizedDescription)
        }
    }
}
