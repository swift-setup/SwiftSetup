//
//  ContentView.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import SwiftUI
import PluginEngine
import SwiftUIKit

struct HomePage: View {
    @EnvironmentObject var pluginEngine: PluginEngine
    @EnvironmentObject var sheetContext: SheetContext
    @EnvironmentObject var swiftSetupPluginViewmodel: PluginStore
    @EnvironmentObject var uiViewModel: UIViewModel
    @EnvironmentObject var fileUtils: FileUtils
    @EnvironmentObject var nsPanel: NSPanelUtils
    
    @State var selectedId: UUID? = nil
    
    
    var body: some View {
        NavigationSplitView {
            PluginList(selection: $selectedId)
        } detail: {
            if let plugin = pluginEngine.currentPlugin {
                DetailPage(plugin: plugin)
            }
        }
        .toolbar {
            if uiViewModel.isLoading {
                ToolbarItem(placement: .primaryAction) {
                    PopoverProgressView(title: uiViewModel.title, subtitle: uiViewModel.subtitle)
                }
            }
        }
        .task {
            load()
            
        }
        .sheet(sheetContext)
        .onChange(of: pluginEngine.isLoadingRemote, perform: { loading in
            uiViewModel.setLoading(title: "Loading remote plugin...", isLoading: loading)
        })
        .onChange(of: selectedId) { id in
            guard let id = id else {
                return
            }
            do {
                try pluginEngine.use(id: id)
            } catch {
                nsPanel.alert(title: "Cannot load plugin", subtitle: error.localizedDescription)
            }
        }
    }
    
    func load() {
        uiViewModel.setLoading(title: "Loading plugins", isLoading: true)
        pluginEngine.setup(fileUtils: fileUtils, nsPanelUtils: nsPanel)
        let storedPlugins = swiftSetupPluginViewmodel.setupPlugins()
        storedPlugins.forEach { plugin in
            _ = pluginEngine.load(path: plugin.localPosition, autoConfirm: true)
        }
        uiViewModel.setLoading(isLoading: false)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
