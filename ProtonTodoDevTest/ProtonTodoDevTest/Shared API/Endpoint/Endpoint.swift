//
//  Endpoint.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/16/25.
//

import Foundation

public typealias Header = [String: String]

public enum BodyParameter {
    case data(Data)
    case dictionary([String: Any], options: JSONSerialization.WritingOptions = [])
    case encodable(Encodable, encoder: JSONEncoder = .init())
}

public protocol Endpoint {
    var method: RequestMethod { get }
    var header: Header? { get }
    var scheme: Scheme { get }
    var host: String { get }
    var path: String { get }
    var body: BodyParameter? { get }
    var params: [String: String]? { get }
}

public extension Endpoint {
    var scheme: Scheme {
        .https
    }
}
