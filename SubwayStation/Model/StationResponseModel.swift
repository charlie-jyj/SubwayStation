//
//  StationResponseModel.swift
//  SubwayStation
//
//  Created by UAPMobile on 2022/02/09.
//

import Foundation

struct StationResponseModel: Decodable {
    // getter
    var stations: [Station] {
        searchInfo.row
    }
    
    private let searchInfo: SearchInfoBySubwayNameServiceModel
    enum CodingKeys: String, CodingKey {
        case searchInfo = "SearchInfoBySubwayNameService"
    }
    struct SearchInfoBySubwayNameServiceModel: Decodable {
        var row: [Station] = []
    }
}

struct Station: Decodable {
    let stationName: String
    let lineNumber: String
    
    enum CodingKeys: String, CodingKey {
        case stationName = "STATION_NM"
        case lineNumber = "LINE_NUM"
    }
}

