//
//  String+HTML.swift
//  Actito Go
//
//  Created by João Ferreira on 09/12/2025.
//

import Foundation

extension String {
    func stripHtml() -> String {
        guard let data = self.data(using: .utf8) else {
            return self
        }

        if let attributedString = try? NSAttributedString(
            data: data,
            options: [
                .documentType: NSAttributedString.DocumentType.html,
                .characterEncoding: String.Encoding.utf8.rawValue
            ],
            documentAttributes: nil
        ) {
            return attributedString.string
        } else {
            return self
        }
    }
}
