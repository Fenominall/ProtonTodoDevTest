//
//  MockEndPoint.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/17/25.
//

import Foundation
import ProtonTodoDevTest

struct MockEndpoint: Endpoint {
    let url: URL
    
    var method: RequestMethod = .get
    var header: Header? = nil
    var scheme: Scheme = .https
    var host: String { url.host! }
    var path: String { url.path }
    var body: BodyParameter? = nil
    var params: [String: String]? = nil
}
