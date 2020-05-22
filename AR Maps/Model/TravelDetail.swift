//
//  Directions.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 20/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import Foundation
import ObjectMapper

struct TravelDetail: Mappable {

    public var distance:String?
    
    public var distanceObj: [String:Any]?{
        didSet{
            distance = distanceObj?["text"] as? String
        }
    }
    
    public var duration:String?
    
    public var durationObj: [String:Any]?{
        didSet{
            duration = durationObj?["text"] as? String
        }
    }
    
    public var destination: String?
    public var source: String?
    public var directions: Directions?

    init?(map: Map) {

    }

    init?() {

    }

    mutating func mapping(map: Map) {
        
        distanceObj <- map["distance"]
        durationObj <- map["duration"]
        destination <- map["end_address"]
        source <- map["start_address"]
        directions <- map["steps"]
    }

}

