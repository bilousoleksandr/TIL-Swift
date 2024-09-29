//
//  SidebarView.swift
//  TILSwift
//
//  Created by Oleksandr Bilous on 28.09.2024.
//

import Foundation
import SwiftUI

struct SidebarView: View {
    @Binding
    var topic: Topic

    var body: some View {
        ScrollView {
            VStack {
                ForEach(Topic.allCases) { currentTopic in
                    Button {
                        topic = currentTopic
                    } label: {
                        HStack {
                            // Change images
                            Image(systemName: "circle")
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(currentTopic.name)
                                .font(.title2)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        .padding(4)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(topic == currentTopic ? Color.accentColor : .clear)
                                .opacity(0.1)
                        }
                    }.buttonStyle(.plain)
                }
            }.padding(8)
        }.frame(minWidth: 240)
    }
}
