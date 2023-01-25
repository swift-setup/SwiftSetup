//
//  VersionPicker.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/25/23.
//

import SwiftUI
import PluginEngine


struct VersionPicker: View {
    let versions: [Version]
    @Binding var selectedVersion: String
    
    var body: some View {
        Picker("Version", selection: $selectedVersion) {
            ForEach(versions.map { $0.toString() }, id: \.hashValue) { version in
                Text(version).tag(version)
            }
        }
    }
}

struct VersionPicker_Previews: PreviewProvider {
    static var previews: some View {
        VersionPicker(versions: ["1.0.0", "1.0.1"], selectedVersion: .constant("1.0.0"))
    }
}
