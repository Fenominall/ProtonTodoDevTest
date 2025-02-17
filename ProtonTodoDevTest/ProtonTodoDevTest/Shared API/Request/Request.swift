//
//  Request.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/16/25.
//

import Foundation

struct Request {
    static func buildURLRequest(from endpoint: Endpoint, withConfig configuration: HTTPConfiguration) -> URLRequest? {
        let host = endpoint.baseURL?.host ?? configuration.baseURL?.host
        guard let host = host else { return nil }

        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = host
        components.path = endpoint.path
        if let urlQueries = endpoint.params {
            let queryItems: [URLQueryItem] = urlQueries.map { (key, value) in
                URLQueryItem(name: key, value: value)
            }
            components.queryItems = queryItems
        }
        
        guard let url = components.url else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        let ednpointHeaders = endpoint.header ?? [:]
        let mergedHeaders = configuration.baseHeaders.merging(ednpointHeaders) { (_, new) in new }
        request.allHTTPHeaderFields = mergedHeaders
        
        switch endpoint.body {
        case let .data(data):
            request.httpBody = data
        case let .dictionary(dict, options):
            let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: options)
            request.httpBody = jsonData
        case let .encodable(object, encoder):
            let data = try? encoder.encode(object)
            request.httpBody = data
        default:
            break
        }
        
        return request
    }
}
