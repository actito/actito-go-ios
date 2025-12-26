//
//  AppConfiguration.swift
//  Actito Go
//
//  Created by Helder Pinhal on 25/03/2022.
//

import Foundation

struct AppConfiguration: Codable {
    let applicationKey: String
    let applicationSecret: String
    let loyaltyProgramId: String?
    let environment: Environment

    enum Environment: String, Codable {
        case production
        case test

        var baseUrl: URL {
            switch self {
            case .production:
                return URL(string: "https://push.notifica.re")!
            case .test:
                return URL(string: "https://push-test.notifica.re")!
            }
        }
    }
}

extension AppConfiguration {
    enum CodingKeys: String, CodingKey {
        case applicationKey
        case applicationSecret
        case loyaltyProgramId
        case environment
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        applicationKey = try container.decode(String.self, forKey: .applicationKey)
        applicationSecret = try container.decode(String.self, forKey: .applicationSecret)
        loyaltyProgramId = try container.decodeIfPresent(String.self, forKey: .loyaltyProgramId)
        environment = try container.decodeIfPresent(Environment.self, forKey: .environment) ?? .production
    }
}
