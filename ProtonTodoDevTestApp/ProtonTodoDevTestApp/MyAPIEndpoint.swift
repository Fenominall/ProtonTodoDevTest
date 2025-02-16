//
//  MyAPIEndpoint.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/16/25.
//

import Foundation
import ProtonTodoDevTest

struct MyAPIEndpoint: Endpoint {
    var method: RequestMethod = .get
    var header: Header? = [:]
    var scheme: Scheme = .https
    var host: String = "api.example.com"
    var path: String = ""
    var body: BodyParameter? = nil
    var params: [String: String]? = [:]
}
