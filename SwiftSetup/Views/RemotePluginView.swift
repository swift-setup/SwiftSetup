//
//  RemotePluginView.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/24/23.
//

import SwiftUI
import PluginEngine
import SwiftUIKit

enum RemoteError: LocalizedError {
    case invalidRepository
    
    var errorDescription: String? {
        switch self {
            case .invalidRepository:
                return "Invalid repository url format"
        }
    }
}

struct RemotePluginView: View {
    @State var repository: String = ""
    @State var version: String = ""
    
    @EnvironmentObject var pluginEngine: PluginEngine
    @EnvironmentObject var store: PluginStore
    @EnvironmentObject var sheetContext: SheetContext
    @EnvironmentObject var uiModel: UIViewModel
    
    var body: some View {
        Form {
            TextField("Repository", text: $repository)
            TextField("Version", text: $version)
            HStack {
                Spacer()
                Button("Close") {
                    sheetContext.dismiss()
                }
                
                Button {
                    Task {
                        do {
                            try await submit()
                        } catch {
                            uiModel.alert(title: "Cannot add remote plugin", subtitle: error.localizedDescription, alertStyle: .critical)
                        }
                    }
                } label: {
                    if pluginEngine.isLoadingRemote {
                        ProgressView()
                    } else {
                        Text("Submit")
                    }
                }

            }
        }
        .padding()
        .frame(width: 600)
    }
    
    func submit() async throws {
        guard let repoURL = URL(string: repository) else {
            throw RemoteError.invalidRepository
        }
        
        let version = Version(stringLiteral: self.version)
        let (repo, plugin) = try await pluginEngine.load(url: repoURL.absoluteString, version: version)
        guard let plugin = plugin else {
            return
        }
        try store.addPlugin(plugin: plugin, repo: repo)
        pluginEngine.addPlugin(plugin: plugin)
        sheetContext.dismiss()
    }
}

struct RemotePluginView_Previews: PreviewProvider {
    static var previews: some View {
        RemotePluginView()
    }
}