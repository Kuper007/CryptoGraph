//
//  BitstampRouter.swift
//  CryptoGraph
//
//  Created by Антон Куперман on 24.05.18.
//  Copyright © 2018 Антон Куперман. All rights reserved.
//

import Foundation
import Alamofire

enum BitstampRouter: URLRequestConvertible {
    static var baseURL: String = "https://www.bitstamp.net/api/v2/ticker/"
    
    case btcusd
    case ethusd
    case btceur
    case etheur
    
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .btcusd:
            return "btcusd/"
        case .ethusd:
            return "ethusd/"
        case .btceur:
            return "btceur/"
        case .etheur:
            return "etheur/"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = Foundation.URL(string: BitstampRouter.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        let urlEncoder = URLEncoding.default
        
        switch self {
        case .btcusd,
             .ethusd,
             .btceur,
             .etheur:
            return try urlEncoder.encode(urlRequest, with: nil)
        }
    }
}

