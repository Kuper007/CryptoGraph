//
//  BitstampListing.swift
//  CryptoGraph
//
//  Created by Антон Куперман on 24.05.18.
//  Copyright © 2018 Антон Куперман. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BitstampListingItem {
    let high: String
    let last: String
    let timestamp : String
    let bid : String
    let vwap : String
    let volume : String
    let low : String
    let ask : String
    let open : String
    
    init(with json: JSON) {
        self.open = json["open"].stringValue
        self.bid = json["bid"].stringValue
        self.ask = json["ask"].stringValue
        self.last = json["last"].stringValue
        self.low = json["low"].stringValue
        self.high = json["high"].stringValue
        self.volume = json["volume"].stringValue
        self.timestamp = json["timestamp"].stringValue
        self.vwap = json["vwap"].stringValue
    }
}
