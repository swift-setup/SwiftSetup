//
//  RemotePluginView.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/24/23.
//

import SwiftUI
import PluginEngine
import SwiftUIKit
import PluginInterface

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
    let isEditing: Bool
    let bundleId: String?
    
    @State var repository: String = ""
    @State var version: String = ""
    @State var token: String = ""
    @State var versions: [Version] = []

    
    @EnvironmentObject var pluginEngine: PluginEngine
    @EnvironmentObject var store: PluginStore
    @EnvironmentObject var sheetContext: SheetContext
    @EnvironmentObject var uiModel: UIViewModel
    @EnvironmentObject var nsPanel: NSPanelUtils
    
    init() {
        isEditing = false
        bundleId = nil
    }
    
    init(bundleId: String, version: String, repository: String) {
        self._version = .init(initialValue: version)
        self._repository = .init(initialValue: repository)
        self.isEditing = true
        self.bundleId = bundleId
    }
    
    var body: some View {
        Form {
            TextField("Repository", text: $repository).onSubmit {
                Task {
                    await fetchVersions()
                }
            }
            .disabled(isEditing)
            VersionPicker(versions: versions, selectedVersion: $version)
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
                            nsPanel.alert(title: "Cannot add remote plugin", subtitle: error.localizedDescription, alertStyle: .critical)
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
        .task {
            if isEditing {
                await fetchVersions()
            }
        }
        .padding()
        .frame(width: 600)
    }
    
    
    func fetchVersions() async {
        do {
            guard let repoURL = URL(string: repository) else {
                return
            }
            let versions = try await pluginEngine.remotePluginLoader.versions(from: repoURL)
            self.versions = versions
        } catch {
            
        }
    }
    
    func submit() async throws {
        guard let repoURL = URL(string: repository) else {
            throw RemoteError.invalidRepository
        }
        
        let version = Version(stringLiteral: version)
        
        if isEditing {
            let (repo, plugin) = try await pluginEngine.update(bundleId: bundleId!, url: repoURL.absoluteString, version: version)
            guard let plugin = plugin else {
                return
            }
            try store.updatePlugin(plugin: plugin, repo: repo)
            pluginEngine.addPlugin(plugin: plugin)
        } else {
            let (repo, plugin) = try await pluginEngine.load(url: repoURL.absoluteString, version: version)
            guard let plugin = plugin else {
                return
            }
            try store.addPlugin(plugin: plugin, repo: repo)
            pluginEngine.addPlugin(plugin: plugin)
        }
        sheetContext.dismiss()
    }
}

struct RemotePluginView_Previews: PreviewProvider {
    static var previews: some View {
        RemotePluginView()
            .environmentObject(PluginEngine())
    }
}
