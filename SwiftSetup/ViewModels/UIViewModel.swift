//
//  UIViewModel.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import Foundation
import AppKit
import PluginInterface
import PluginEngine

class UIViewModel: ObservableObject {
    @Published private(set) var isLoading = false
    @Published private(set) var title: String? = nil
    @Published private(set) var subtitle: String? = nil
    
    private let panelUtils = NSPanelUtils()
    
    @MainActor
    func setLoading(title: String? = nil, subtitle: String? = nil, isLoading: Bool) {
        self.isLoading = isLoading
        if !isLoading {
            self.title = nil
            self.subtitle = nil
        } else {
            self.title = title
            self.subtitle = subtitle
        }
    }
}
