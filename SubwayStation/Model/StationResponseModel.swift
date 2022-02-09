//
//  StationResponseModel.swift
//  SubwayStation
//
//  Created by UAPMobile on 2022/02/09.
//

import Foundation

struct StationResponseModel: Decodable {
    struct SearchInfoBySubwayNameServiceModel: Decodable {
        var row: [Station] = []
    }
}

struct Station: Decodable {
    
}

