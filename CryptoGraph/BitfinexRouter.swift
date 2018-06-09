//
//  BitfinexRouter.swift
//  CryptoGraph
//
//  Created by Антон Куперман on 23.05.18.
//  Copyright © 2018 Антон Куперман. All rights reserved.
//

import Foundation
import Alamofire

enum BitfinexRouter: URLRequestConvertible {
    static var baseURL: String = "https://api.bitfinex.com/v1/pubticker/"
    
    case btcusd
    case ethusd
    case eosusd
    case btceur
    case etheur
    case eoseur
    
    var method: Alamofire.HTTPMethod {
        return .get
    }
    
    var path: String {
        switch self {
        case .btcusd:
            return "btcusd/"
        case .ethusd:
            return "ethusd/"
        case .eosusd:
            return "eosusd/"
        case .btceur:
            return "btceur/"
        case .etheur:
            return "etheur/"
        case .eoseur:
            return "eoseur/"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = Foundation.URL(string: BitfinexRouter.baseURL)!
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        
        let urlEncoder = URLEncoding.default
        
        switch self {
        case .btcusd,
             .ethusd,
             .eosusd,
             .btceur,
             .etheur,
             .eoseur:
            return try urlEncoder.encode(urlRequest, with: nil)
        }
    }
}
