//
//  PopoverView.swift
//  SwiftSetup
//
//  Created by Qiwei Li on 1/23/23.
//

import SwiftUI

struct PopoverView<Content: View, Popover: View>: View {
    @ViewBuilder var content: Content
    @ViewBuilder var popover: Popover
    
    @State private var showPopup = false
    
    var body: some View {
        content
            .padding()
            .popover(isPresented: $showPopup, content: {
                popover
                    .padding()
            })
            .onTapGesture {
                showPopup = true
            }
            .onHover { v in
                showPopup = v
            }
    }
}

struct PopoverView_Previews: PreviewProvider {
    static var previews: some View {
        PopoverView {
            Text("Text")
                .padding()
        } popover: {
            Text("Popover")
        }

    }
}
