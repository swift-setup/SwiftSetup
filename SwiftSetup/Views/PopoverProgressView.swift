//
//  PopupProgressView.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import SwiftUI

struct PopoverProgressView: View {
    let title: String?
    let subtitle: String?
    
    var body: some View {
        PopoverView {
            ProgressView()
        } popover: {
            VStack(alignment: .leading) {
                if let title = title {
                    Text(title)
                        .fontWeight(.bold)
                }
                
                if let subtitle = subtitle {
                    Text(subtitle)
                }
            }
        }

    }
}

struct PopupProgressView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverProgressView(title: "Hello", subtitle: "World")
    }
}
