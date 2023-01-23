//
//  PluginRepo.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import Foundation
import PluginInterface
import RealmSwift
import PluginEngine

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
    
    @Persisted var _version: String

    var keywords: [String] {
        get {
            return _keywords.map { $0 }
        }

        set {
            _keywords.removeAll()
            _keywords.append(objectsIn: newValue)
        }
    }
    
    var version: Version {
        get {
            return Version(stringLiteral: _version)
        }
    }

    convenience init(bundleIdentifier: String, displayName: String, author: String, shortDescription: String, repository: String, keywords: [String], readme: String?, localPosition: String, version: Version) {
        self.init()
        self.bundleIdentifier = bundleIdentifier
        self.displayName = displayName
        self.author = author
        self.shortDescription = shortDescription
        self.repository = repository
        self.keywords = keywords
        self.readme = readme
        self.localPosition = localPosition
        self._version = "\(version.major).\(version.minor).\(version.patch)"
    }
}
