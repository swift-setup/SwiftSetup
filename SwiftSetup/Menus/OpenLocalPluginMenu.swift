//
//  OpenTextFileCommand.swift
//  TextToSpeech
//
//  Created by Qiwei Li on 12/26/22.
//

import Foundation
import SwiftUI
import PluginEngine
import SwiftUIKit

enum OpenFileError {
    case fileCannotBeRead
}

extension OpenFileError: LocalizedError {
    var errorDescription: String? {
        switch (self) {
            case .fileCannotBeRead:
                return "File cannot be read"
        }
    }
}

struct OpenPluginCommand: Commands {
    let pluginEngine: PluginEngine
    let sheetContext: SheetContext
    let store: PluginStore
    let uiModel: UIViewModel
    
    var body: some Commands {
        CommandGroup(replacing: .newItem) {
            Button("Open local plugin") {
               openLocalPlugin()
            }
            
            Button("Open remote plugin") {
                openRemotePlugin()
            }
        }
    }
    
    func openLocalPlugin() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.allowedContentTypes = [.unixExecutable]
        panel.canChooseDirectories = false
        if panel.runModal() == .OK {
            if let url = panel.url {
                let path = url.absoluteString.replacingOccurrences(of: "file:///", with: "")
                let plugin = pluginEngine.load(path: path)
                guard let plugin = plugin else {
                    return
                }
                let repo = PluginRepo(localPosition: path, readme: "", version: .init(1, 0, 0))
                try! store.addPlugin(plugin: plugin, repo: repo)
            }
        }
    }
    
    func openRemotePlugin() {
        sheetContext.present(
            RemotePluginView()
                .environmentObject(store)
                .environmentObject(pluginEngine)
                .environmentObject(sheetContext)
                .environmentObject(uiModel)
        )
    }
}
