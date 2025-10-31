//
//  Bundle+URLScheme.swift
//  Actito Go
//
//  Created by João Ferreira on 31/10/2025.
//

import Foundation

internal extension Bundle {
    func hasValidScheme(_ scheme: String) -> Bool {
        guard
            let urlTypes = object(forInfoDictionaryKey: "CFBundleURLTypes") as? [[String: Any]],
            let schemes = urlTypes.first?["CFBundleURLSchemes"] as? [String]
        else {
            return false
        }

        return schemes.contains(scheme)
    }
}
