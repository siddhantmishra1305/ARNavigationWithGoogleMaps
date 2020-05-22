//
//  Directions.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 20/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import Foundation
import ObjectMapper

typealias Directions = [Direction]

struct Direction: Mappable {
    
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
    
    public var endlat : Double?
    public var endlon : Double?
    
    public var endAddress:[String:Any]?{
        didSet{
            endlat = endAddress?["lat"] as? Double
            endlon = endAddress?["lng"] as? Double
        }
    }
    
    public var startlat : Double?
    public var startlon : Double?
    
    public var startAddress:[String:Any]?{
        didSet{
            startlat = startAddress?["lat"] as? Double
            startlon = startAddress?["lng"] as? Double
        }
    }
    
    public var instruction: String?
    public var maneuver: String?
    
    
    init?(map: Map) {
        
    }
    
    init?() {
        
    }
    
    mutating func mapping(map: Map) {
        distanceObj <- map["distance"]
        durationObj <- map["duration"]
        instruction <- map["instruction"]
        maneuver <- map["maneuver"]
        startAddress <- map["start_location"]
        endAddress <- map["end_location"]
    }
    
}



