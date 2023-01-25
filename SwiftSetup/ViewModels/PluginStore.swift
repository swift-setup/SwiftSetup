//
//  SwiftSetupPluginViewModel.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import Foundation
import PluginEngine
import PluginInterface
import RealmSwift

enum PluginStoreError: LocalizedError {
    case duplicatePlugin(String)
    case notFound(String)

    var errorDescription: String? {
        switch self {
        case let .duplicatePlugin(bundleId):
            return "Duplicated plugin found: \(bundleId)"
        case let .notFound(bundleId):
            return "Unable to find plugin: \(bundleId)"
        }
    }
}

/**
 * This model is used for managing plugin manifests. It uses a Realm object to store, modify, and delete the plugin manifests.
 *
 * - Properties:
 *   - realm: A Realm object that is used to interact with the database
 *
 * - Methods:
 *   - init(): Initializes the Realm object
 *   - setupPlugins(): Reads the plugin manifests from the database and returns them as an array of PluginManifest objects
 *
 * - Usage:
 *   1. Create an instance of the class:
 *      let viewModel = SwiftSetupPluginViewModel()
 *   2. Use the `setupPlugins()` method to retrieve the plugin manifests:
 *      let plugins = viewModel.setupPlugins()
 *   3. Use the returned array of PluginManifest objects as needed
 */
class PluginStore: ObservableObject {
    let realm: Realm

    /**
     Initializes the Realm object
     */
    init() {
        let config = Realm.Configuration(schemaVersion: 2)
        realm = try! Realm(configuration: config)
    }

    /**
     Reads the plugin manifests from the database and returns them as an array of PluginManifest objects
     - Returns: An array of PluginManifest objects
     */
    func setupPlugins() -> [PluginManifest] {
        let plugins = realm.objects(PluginManifest.self)
        return Array(plugins)
    }

    /**
     * This method is used to add a new plugin to the database.
     *
     * - Parameters:
     *   - plugin: An object that conforms to the `PluginInterfaceProtocol` protocol. It contains the plugin's manifest information.
     *   - repo: A `PluginRepo` object that contains the plugin's readme and local position information
     *
     * - Throws:
     *    - An error if there is an issue when adding the plugin to the database
     *
     * - Usage:
     *   1. Create a new instance of the plugin and the repo
     *   2. call the addPlugin method on the viewModel
     *      try viewModel.addPlugin(plugin: newPlugin, repo: newRepo)
     */
    func addPlugin(plugin: any PluginInterfaceProtocol, repo: PluginRepo) throws {
        if let prevPlugin = realm.objects(PluginManifest.self).filter({ $0.bundleIdentifier == plugin.manifest.bundleIdentifier }).first {
            throw PluginStoreError.duplicatePlugin(prevPlugin.bundleIdentifier)
        }

        let manifest = plugin.manifest
        let pluginManifest = PluginManifest(bundleIdentifier: manifest.bundleIdentifier, displayName: manifest.displayName, author: manifest.author, shortDescription: manifest.shortDescription, repository: manifest.repository, keywords: manifest.keywords, readme: repo.readme, localPosition: repo.localPosition, version: repo.version)
        try realm.write {
            realm.add(pluginManifest)
        }
    }

    func updatePlugin(plugin: any PluginInterfaceProtocol, repo: PluginRepo) throws {
        guard let prevPlugin = realm.objects(PluginManifest.self).filter({ $0.bundleIdentifier == plugin.manifest.bundleIdentifier }).first else {
            throw PluginStoreError.notFound(plugin.manifest.bundleIdentifier)
        }

        let manifest = plugin.manifest
        try realm.write {
            prevPlugin._version = repo.version.toString()
            prevPlugin.readme = repo.readme
            prevPlugin.localPosition = repo.localPosition
            prevPlugin.displayName = manifest.displayName
            prevPlugin.author = manifest.author
            prevPlugin.shortDescription = manifest.shortDescription
            prevPlugin.repository = manifest.repository
            prevPlugin.keywords = manifest.keywords
        }
    }

    func deletePlugin(by bundleId: String) throws {
        guard let prevPlugin = realm.objects(PluginManifest.self).filter({ $0.bundleIdentifier == bundleId }).first else {
            throw PluginStoreError.notFound(bundleId)
        }

        try realm.write {
            realm.delete(prevPlugin)
        }
    }

    func findPlugin(by bundleId: String) throws -> PluginManifest {
        guard let plugin = realm.objects(PluginManifest.self).filter({ $0.bundleIdentifier == bundleId }).first else {
            throw PluginStoreError.notFound(bundleId)
        }
        return plugin
    }
}
