//
//  File.swift
//  TILSwift
//
//  Created by Oleksandr Bilous on 28.09.2024.
//

import Foundation

typealias TopicResource = String

enum Topic: String, CaseIterable, Identifiable {
    case memoryManagement = "MemoryManagement"
    case concurrency = "Concurrency"
    case generalSwift = "General Swift"
    case userInterface = "User Interface"

    var name: String {
        rawValue.capitalized
    }

    var id: String {
        rawValue
    }
}
