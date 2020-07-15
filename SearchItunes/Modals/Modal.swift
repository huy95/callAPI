//
//  Model.swift
//  SearchItunes
//
//  Created by Taof on 5/21/20.
//  Copyright © 2020 taoquynh. All rights reserved.
//

import Foundation
import SwiftyJSON

class ItuneObject {
    var resultCount: Int?
    var results: [Itune]?
    
    required public init?(json: JSON) {
        resultCount = json["resultCount"].intValue
        results = json["results"].arrayValue.map { Itune(json: $0)! }
    }
}

class Itune {
    var trackName: String?
    var artistName: String?
    var trackPrice: Float?
    var country: String?
    var artworkUrl100: String?
    var type: String?
    var previewUrl: String?
    var primaryGenreName: String?
    
    required public init?(json: JSON) {
        trackName = json["trackName"].stringValue
        artistName = json["artistName"].stringValue
        trackPrice = json["trackPrice"].floatValue
        country = json["country"].stringValue
        artworkUrl100 = json["artworkUrl100"].stringValue
        type = json["type"].stringValue
        previewUrl = json["previewUrl"].stringValue
        primaryGenreName = json["primaryGenreName"].stringValue
    }
}
