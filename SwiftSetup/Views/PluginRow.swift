//
//  PluginRow.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/29/23.
//

import SwiftUI

struct PluginRow: View {
    let displayName: String
    let version: String
    
    var body: some View {
        HStack {
            Text(displayName)
            Text(version)
                .foregroundColor(Color.gray)
            Spacer()
        }
    }
}

struct PluginRow_Previews: PreviewProvider {
    static var previews: some View {
        PluginRow(displayName: "Hello", version: "1.0.0")
    }
}
