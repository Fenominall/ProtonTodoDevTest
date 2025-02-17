//
//  MyAPIEndpoint.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/16/25.
//

import Foundation
import ProtonTodoDevTest

struct APIEndpoint: Endpoint {
    var baseURL: URL?
    var method: RequestMethod
    var header: Header?
    var scheme: Scheme
    var path: String
    var body: BodyParameter?
    var params: [String: String]?
    
    init(
        baseURL: URL? = nil,
        method: RequestMethod = .get,
        header: Header? = nil,
        scheme: Scheme = .https,
        path: String = "",
        body: BodyParameter? = nil,
        params: [String : String]? = nil
    ) {
        self.baseURL = baseURL
        self.method = method
        self.header = header
        self.scheme = scheme
        self.path = path
        self.body = body
        self.params = params
    }
}
