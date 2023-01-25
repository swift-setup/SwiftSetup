//
//  PluginDetailView.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import SwiftUI
import MarkdownUI

struct PluginDetailView: View {
    @Environment(\.openURL) var open
    
    let pluginManifest: PluginManifest
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Section("Basic info") {
                    Row(title: "Display Name", subtitle: pluginManifest.displayName)
                    Row(title: "Bundle Identifier", subtitle: pluginManifest.bundleIdentifier)
                    //TODO: add version
                    Row(title: "Version", subtitle: pluginManifest.version.toString())
                    Row(title: "Author", subtitle: pluginManifest.author)
                    Row(title: "Keywords", subtitle: "\(pluginManifest.keywords)")
                }
                
                Divider()
                
                Section("Short Description") {
                    Text(pluginManifest.shortDescription)
                }
                
                Divider()
                if let readme = pluginManifest.readme {
                    Section("Long Description") {
                        Markdown(readme)
                    }
                    Divider()
                }
                
                if let url = URL(string: pluginManifest.repository) {
                    HStack {
                        Button("Open the repository") {
                            open(url)
                        }
                    }
                }
                Spacer()
            }
            .frame(minHeight: 300, maxHeight: 600)
        }
    }
}


struct Row: View {
    let title: String
    let subtitle: String
    
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(Color.gray)
            Spacer()
            Text(subtitle)
        }
    }
}

struct PluginDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PluginDetailView(
            pluginManifest: PluginManifest(bundleIdentifier: "test", displayName: "hello", author: "hello", shortDescription: "hello", repository: "https://google.com", keywords: ["keyword"], readme: "Heallo", localPosition: "a", version: "1.0.0")
        )
        .padding()
    }
}
