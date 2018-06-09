//
//  API.swift
//  CryptoGraph
//
//  Created by Антон Куперман on 24.05.18.
//  Copyright © 2018 Антон Куперман. All rights reserved.
//

import Foundation
import Alamofire

struct API {
    static func Bitfinex_BTC_USD() -> DataRequest {
        return Alamofire.request(BitfinexRouter.btcusd)
    }
    static func Bitfinex_ETH_USD() -> DataRequest {
        return Alamofire.request(BitfinexRouter.ethusd)
    }
    static func Bitfinex_EOS_USD() -> DataRequest {
        return Alamofire.request(BitfinexRouter.eosusd)
    }
    static func Bitfinex_BTC_EUR() -> DataRequest {
        return Alamofire.request(BitfinexRouter.btceur)
    }
    static func Bitfinex_ETH_EUR() -> DataRequest {
        return Alamofire.request(BitfinexRouter.etheur)
    }
    static func Bitfinex_EOS_EUR() -> DataRequest {
        return Alamofire.request(BitfinexRouter.eoseur)
    }
    static func Bitstamp_BTC_USD() -> DataRequest {
        return Alamofire.request(BitstampRouter.btcusd)
    }
    static func Bitstamp_ETH_USD() -> DataRequest {
        return Alamofire.request(BitstampRouter.ethusd)
    }
    static func Bitstamp_BTC_EUR() -> DataRequest {
        return Alamofire.request(BitstampRouter.btceur)
    }
    static func Bitstamp_ETH_EUR() -> DataRequest {
        return Alamofire.request(BitstampRouter.etheur)
    }
    static func CEX_BTC_USD() -> DataRequest {
        return Alamofire.request(CEXRouter.btcusd)
    }
    static func CEX_ETH_USD() -> DataRequest {
        return Alamofire.request(CEXRouter.ethusd)
    }
    static func CEX_BTC_EUR() -> DataRequest {
        return Alamofire.request(CEXRouter.btceur)
    }
    static func CEX_ETH_EUR() -> DataRequest {
        return Alamofire.request(CEXRouter.etheur)
    }
}
