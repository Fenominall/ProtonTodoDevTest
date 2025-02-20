//
//  URLProtocolStub.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/17/25.
//

import Foundation

final class URLProtocolStub: URLProtocol {
    private struct Stub {
        let data: Data?
        let response: URLResponse?
        let error: Error?
        let requestObserver: ((URLRequest) -> Void)?
    }
    
    private static var _stub: Stub?
    private static var stub: Stub? {
        get { return queue.sync { _stub } }
        set { queue.async(flags: .barrier) { _stub = newValue } }
    }
    
    private static let queue = DispatchQueue(label: "swift.urLprotocolstub.queue.com", attributes: .concurrent)
    
    static func stub(data: Data?, response: URLResponse?, error: Error?) async {
        stub = Stub(data: data, response: response, error: error, requestObserver: nil)
    }
    
    static func observeRequests(observer: @escaping (URLRequest) -> Void) async {
        stub = Stub(data: nil, response: nil, error: nil, requestObserver: observer)
    }
    
    static func removeStub() async {
        stub = nil
    }
    
    // Required methods
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let stub = URLProtocolStub.stub else {
            return
        }

        if stub.response == nil {
            client?.urlProtocol(self, didFailWithError: URLError(.unknown))
        }

        if let response = stub.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }

        if let data = stub.data {
            client?.urlProtocol(self, didLoad: data)
        }

        if let error = stub.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            client?.urlProtocolDidFinishLoading(self)
        }
        
        stub.requestObserver?(request)

    }
    
    override func stopLoading() {}
}
