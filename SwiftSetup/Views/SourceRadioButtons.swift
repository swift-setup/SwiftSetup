//
//  SourceRadioButtons.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 6/2/23.
//

import SwiftUI

enum VersionSource: String, CaseIterable {
    case fromDropdown = "From Dropdown"
    case fromTextfield = "From TextField"
}

struct SourceRadioButtons: View {
    @Binding var userSelection: VersionSource

    var body: some View {
        Picker(selection: $userSelection, label: Text("Pick a version source")) {
            ForEach(VersionSource.allCases, id: \.self) { versionSource in
                Text(versionSource.rawValue).tag(versionSource)
            }
        }.pickerStyle(RadioGroupPickerStyle())
    }
}

struct SourceRadioButtons_Previews: PreviewProvider {
    static var previews: some View {
        SourceRadioButtons(userSelection: .constant(.fromDropdown))
    }
}
