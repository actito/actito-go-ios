//
//  Bundle+URLScheme.swift
//  Actito Go
//
//  Created by João Ferreira on 31/10/2025.
//

import Foundation

internal extension Bundle {
    func validateScheme(scheme: String) -> Bool {
        let urlSchemes = Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]]
        let schemes = urlSchemes?.first?["CFBundleURLSchemes"] as? [String]

        return schemes?.contains(scheme) ?? false
    }
}
