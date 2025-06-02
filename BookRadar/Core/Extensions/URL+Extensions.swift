//
//  URL+Extensions.swift
//  BookRadar
//
//  Created by Agata Przykaza on 02/06/2025.
//
import Foundation

extension URL {
    var httpsURL: URL {
        if scheme == "http" {
            var components = URLComponents(url: self, resolvingAgainstBaseURL: false)
            components?.scheme = "https"
            return components?.url ?? self
        }
        return self
    }
}
