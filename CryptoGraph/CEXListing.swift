//
//  CEXListing.swift
//  CryptoGraph
//
//  Created by Антон Куперман on 29.05.18.
//  Copyright © 2018 Антон Куперман. All rights reserved.
//

import Foundation
import SwiftyJSON

struct CEXListingItem {
    let high: String
    let last: String
    let timestamp : String
    let bid : Double
    let volume30d : String
    let volume : String
    let low : String
    let ask : Double
    
    init(with json: JSON) {
        self.bid = json["bid"].doubleValue
        self.ask = json["ask"].doubleValue
        self.last = json["last"].stringValue
        self.low = json["low"].stringValue
        self.high = json["high"].stringValue
        self.volume = json["volume"].stringValue
        self.timestamp = json["timestamp"].stringValue
        self.volume30d = json["volume30d"].stringValue
    }
}
