//
//  PluginRepo.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import Foundation
import PluginInterface
import RealmSwift

/**
    A `PluginManifest` represents a plugin's manifest file.
 */
class PluginManifest: Object, Identifiable, ProjectManifestProtocol {
    @Persisted var displayName: String

    @Persisted(primaryKey: true) var bundleIdentifier: String

    @Persisted var author: String

    @Persisted var shortDescription: String

    @Persisted var repository: String

    @Persisted var _keywords = List<String>()

    @Persisted var readme: String?

    @Persisted var localPosition: String

    var keywords: [String] {
        get {
            return _keywords.map { $0 }
        }

        set {
            _keywords.removeAll()
            _keywords.append(objectsIn: newValue)
        }
    }

    convenience init(bundleIdentifier: String, displayName: String, author: String, shortDescription: String, repository: String, keywords: [String], readme: String?, localPosition: String) {
        self.init()
        self.bundleIdentifier = bundleIdentifier
        self.displayName = displayName
        self.author = author
        self.shortDescription = shortDescription
        self.repository = repository
        self.keywords = keywords
        self.readme = readme
        self.localPosition = localPosition
    }
}
