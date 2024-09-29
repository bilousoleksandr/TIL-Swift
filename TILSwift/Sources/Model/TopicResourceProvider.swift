//
//  TopicResourceProvider.swift
//  TILSwift
//
//  Created by Oleksandr Bilous on 28.09.2024.
//

import Foundation

enum TopicResourceProvider {
    enum Failure: Error {
        case invalidURL
        case missingContent
    }

    static func resources(for topic: Topic) async throws -> [TopicResource] {
        guard let contentURL = Bundle.main.resourceURL?.appendingPathComponent("Content").appendingPathComponent(topic.name) else {
            throw Failure.invalidURL
        }

        return try FileManager.default.contentsOfDirectory(atPath: contentURL.path)
    }

    static func content(topic: Topic, resource: TopicResource) throws -> String {
        let contentURL = Bundle.main.resourceURL?.appendingPathComponent("Content")

        guard let contentURL = contentURL?.appendingPathComponent(topic.name).appendingPathComponent(resource).appendingPathExtension("swift") else {
            throw Failure.invalidURL
        }

        return try String(contentsOf: contentURL, encoding: .utf8)
    }
}
