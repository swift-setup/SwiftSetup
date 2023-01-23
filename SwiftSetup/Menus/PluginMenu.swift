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


struct PluginCommand: Commands {
    let pluginEngine: PluginEngine
    let sheetContext: SheetContext
    
    var body: some Commands {
        CommandMenu("Plugins") {
            Button("Open A") {
             
            }
        }
    }
}
