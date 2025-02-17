//
//  APIEndpoints.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/17/25.
//

import Foundation
import ProtonTodoDevTest

enum APIEndpoints {
    static var fetchTodoFeed: APIEndpoint {
        .init(
            path: "https://images.ctfassets.net"
        )
    }
    
    static var fetchTodoImages: APIEndpoint {
        .init(
            path: "/f7l5sefbt57k/5qtjdCxnDwJ1drPVMkwBpf/410b1e7193b8f488d0d3fe2e5b65a0ce/Default_A_pair_of_hands_their_fingers_dancing_skillfully_acro_1.jpg"
        )
    }
}
