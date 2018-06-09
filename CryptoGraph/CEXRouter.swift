//
//  CEXRouter.swift
//  CryptoGraph
//
//  Created by Антон Куперман on 29.05.18.
//  Copyright © 2018 Антон Куперман. All rights reserved.
//

import Foundation
import Alamofire

enum CEXRouter: URLRequestConvertible {
    static var baseURL: String = "https://cex.io/api/ticker/"
    
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
            return "BTC/USD/"
        case .ethusd:
            return "ETH/USD/"
        case .btceur:
            return "BTC/EUR/"
        case .etheur:
            return "ETH/EUR/"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = Foundation.URL(string: CEXRouter.baseURL)!
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


