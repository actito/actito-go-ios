//
//  zzz.swift
//  Actito Go
//
//  Created by Helder Pinhal on 12/04/2022.
//

import Foundation
import ActitoKit
import OSLog

private let allowedConfigurationHostnames = [
    "go-demo.ntc.re",
    "go-demo-test.test.ntc.re",
]

func extractCodeParameter(from url: URL) -> String? {
    guard url.scheme == "https" else {
        Logger.main.debug("Scheme mismatch.")
        return nil
    }
    
    guard let host = url.host, allowedConfigurationHostnames.contains(host) else {
        Logger.main.debug("Host mismatch.")
        return nil
    }
    
    guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
          let queryItems = components.queryItems,
          let referrer = queryItems.first(where: { $0.name == "referrer" })?.value
    else {
        Logger.main.debug("Missing referrer parameter.")
        return nil
    }
    
    return referrer
}

func determineEnvironment(for url: URL) -> AppConfiguration.Environment {
    if url.host?.hasSuffix(".test.ntc.re") == true {
        return .test
    }

    return .production
}

func loadRemoteConfig() async {
    do {
        let assets = try await Actito.shared.assets().fetch(group: "config")
        
        if let config = assets.first, let storeEnabled = config.extra["storeEnabled"] as? Bool, storeEnabled {
            Preferences.standard.storeEnabled = true
            return
        }
    } catch {
        if case let ActitoNetworkError.validationError(response, _, _) = error, response.statusCode == 404 {
            // The config asset group is not available. The store can be enabled.
            Preferences.standard.storeEnabled = true
            return
        }
        
        Logger.main.error("Failed to fetch the remote config. \(error.localizedDescription)")
    }
    
    Preferences.standard.storeEnabled = false
}

@MainActor
func configure(with configuration: AppConfiguration) {
    let servicesInfo: ActitoServicesInfo

    switch configuration.environment {
    case .production:
        servicesInfo = ActitoServicesInfo(
            applicationKey: configuration.applicationKey,
            applicationSecret: configuration.applicationSecret
        )
    case .test:
        servicesInfo = ActitoServicesInfo(
            applicationKey: configuration.applicationKey,
            applicationSecret: configuration.applicationSecret,
            hosts: ActitoServicesInfo.Hosts(
                restApi: "https://push-test.notifica.re",
                appLinks: "applinks.test.notifica.re",
                shortLinks: "test.ntc.re"
            )
        )
    }

    Actito.shared.configure(servicesInfo: servicesInfo)
}
