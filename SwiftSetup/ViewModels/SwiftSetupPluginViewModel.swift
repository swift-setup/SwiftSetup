//
//  SwiftSetupPluginViewModel.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import Foundation
import RealmSwift

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
class SwiftSetupPluginViewModel: ObservableObject {
    let realm: Realm

    /**
     Initializes the Realm object
     */
    init() {
        realm = try! Realm()
    }

    /**
     Reads the plugin manifests from the database and returns them as an array of PluginManifest objects
     - Returns: An array of PluginManifest objects
     */
    func setupPlugins() -> [PluginManifest] {
        let plugins = realm.objects(PluginManifest.self)
        return Array(plugins)
    }
}
