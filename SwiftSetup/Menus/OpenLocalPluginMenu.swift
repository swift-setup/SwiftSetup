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
                pluginEngine.load(path: url.absoluteString.replacingOccurrences(of: "file:///", with: ""))
            }
        }
    }
    
    func openRemotePlugin() {
        sheetContext.present(Text("Hello world"))
    }
}
