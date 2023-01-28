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
    @EnvironmentObject var nsPanel: NSPanelUtils
    
    @ObservedResults(PluginManifest.self) var projects
    
    @Binding var selection: UUID?
    
    var body: some View {
        List(pluginEngine.plugins, id: \.id, selection: $selection) { plugin in
            NavigationLink(value: plugin.id){
                let pluginRepo = try? store.findPlugin(by: plugin.manifest.bundleIdentifier)
                PluginRow(displayName: plugin.manifest.displayName, version: pluginRepo?.version.toString() ?? "undefined")
            }
            .contextMenu {
                Button("Edit plugin") {
                    if let manifest = try? store.findPlugin(by: plugin.manifest.bundleIdentifier) {
                        sheeContext.present(RemotePluginView(bundleId: plugin.manifest.bundleIdentifier, version: manifest.version.toString(), repository: manifest.repository))
                    }
                }
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
            let confirmed = nsPanel.confirm(title: "Delete plugin \(plugin.manifest.bundleIdentifier)", subtitle: "This operation cannot be revert", confirmButtonText: "OK", cancelButtonText: "Cancel", alertStyle: .informational)
            
            if !confirmed {
                return
            }
            
            try store.deletePlugin(by: plugin.manifest.bundleIdentifier)
            pluginEngine.removePlugin(plugin: plugin)
        } catch {
            nsPanel.alert(title: "Cannot delete plugin", subtitle: error.localizedDescription)
        }
    }
}
