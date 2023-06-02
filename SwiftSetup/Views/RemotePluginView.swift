//
//  RemotePluginView.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/24/23.
//

import PluginEngine
import PluginInterface
import SwiftUI
import SwiftUIKit

extension Version {
    func isValid() -> Bool {
        return major >= 0 && minor >= 0 && patch >= 0
    }
}

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
    @State var userSelection: VersionSource = .fromDropdown

    @EnvironmentObject var pluginEngine: PluginEngine
    @EnvironmentObject var store: PluginStore
    @EnvironmentObject var sheetContext: SheetContext
    @EnvironmentObject var uiModel: UIViewModel
    @EnvironmentObject var nsPanel: NSPanelUtils

    init() {
        self.isEditing = false
        self.bundleId = nil
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
            SourceRadioButtons(userSelection: $userSelection)
            if userSelection == .fromDropdown {
                VersionPicker(versions: versions, selectedVersion: $version)
            }
            
            if userSelection == .fromTextfield {
                TextField("Version", text: $version)
                    .onSubmit {
                        validateUserVersion()
                    }
            }
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

    /**
     Fetch all valid versions
     */
    func fetchVersions() async {
        do {
            guard let repoURL = URL(string: repository) else {
                return
            }
            let versions = try await pluginEngine.remotePluginLoader.versions(from: repoURL)
            self.versions = versions.filter { version in
                version.isValid()
            }
        } catch {}
    }
    
    func validateUserVersion() {
        let userVersion: Version = .init(stringLiteral: version)
        if !userVersion.isValid() {
            nsPanel.alert(title: "Your version is invalid", subtitle: version)
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
