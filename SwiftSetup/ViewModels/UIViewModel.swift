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

class UIViewModel: ObservableObject, NSPanelUtilsProtocol {
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
    
    func confirm(title: String, subtitle: String, confirmButtonText: String?, cancelButtonText: String?, alertStyle: NSAlert.Style?) -> Bool {
        panelUtils.confirm(title: title, subtitle: subtitle, confirmButtonText: confirmButtonText, cancelButtonText: cancelButtonText, alertStyle: alertStyle)
    }
    
    func alert(title: String, subtitle: String, okButtonText: String? = "OK", alertStyle: NSAlert.Style? = .critical) {
        panelUtils.alert(title: title, subtitle: subtitle, okButtonText: okButtonText, alertStyle: alertStyle)
    }
}
