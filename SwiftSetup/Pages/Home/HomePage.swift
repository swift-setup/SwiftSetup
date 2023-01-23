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
    @EnvironmentObject var swiftSetupPluginViewmodel: SwiftSetupPluginViewModel
    @EnvironmentObject var uiViewModel: UIViewModel
    
    @State var selectedId: UUID? = nil
    
    
    var body: some View {
        NavigationSplitView {
            PluginList(selection: $selectedId)
        } detail: {
            if let _ = pluginEngine.currentPlugin {
                pluginEngine.render()
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
                uiViewModel.alert(title: "Cannot load plugin", subtitle: error.localizedDescription)
            }
        }
    }
    
    func load() {
        uiViewModel.setLoading(title: "Loading plugins", isLoading: true)
        let storedPlugins = swiftSetupPluginViewmodel.setupPlugins()
        storedPlugins.forEach { plugin in
            pluginEngine.load(path: plugin.localPosition)
        }
        uiViewModel.setLoading(isLoading: false)
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
    }
}
