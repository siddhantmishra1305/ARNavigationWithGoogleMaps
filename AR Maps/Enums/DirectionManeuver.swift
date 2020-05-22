//
//  DirectionManeuver.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 20/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import Foundation
import UIKit

enum DirectionManuever:String{
    case  ferry = "ferry"
    case  ferryTrain = "ferry-train"
    case  forkLeft = "fork-left"
    case  forkRight = "fork-right"
    case  keepLeft = "keep-left"
    case  keepRight = "keep-right"
    case  merge = "merge"
    case  rampLeft = "ramp-left"
    case  rampRight = "ramp-right"
    case  roundaboutLeft = "roundabout-left"
    case  roundaboutRight = "roundabout-rigt"
    case  straight = "straight"
    case  turnLeft = "turn-left"
    case  turnRight = "turn-right"
    case  turnSharpLeft = "turn-sharp-left"
    case  turnSharpRight = "turn-sharp-right"
    case  turnSlightLeft = "turn-slight-left"
    case  turnSlightRight = "turn-slight-right"
    case  uturnLeft = "uturn-left"
    case  uturnRight = "uturn-right"
    
    var icon:UIImage{
        switch self {
            
        case .ferry:
            return #imageLiteral(resourceName: " DefaultMarker")
            
        case .ferryTrain:
            return #imageLiteral(resourceName: " DefaultMarker")
            
        case .forkLeft:
            return UIImage(named: "direction_fork_left.png")!
            
        case .forkRight:
            return UIImage(named: "direction_fork_right.png")!
            
        case .keepLeft:
            return UIImage(named: "direction_continue_left.png")!
            
        case .keepRight:
            return UIImage(named: "direction_continue_right.png")!
            
        case .merge:
            return UIImage(named: "direction_merge_straight.png")!
            
        case .rampLeft:
            return UIImage(named: "direction_off_ramp_left.png")!
            
        case .rampRight:
            return UIImage(named: "direction_off_ramp_right.png")!
            
        case .roundaboutLeft:
            return UIImage(named: "direction_roundabout_left.png")!
            
        case .roundaboutRight:
            return UIImage(named: "direction_roundabout_right.png")!
            
        case .straight:
            return UIImage(named: "direction_turn_straight.png")!
            
        case .turnLeft:
            return UIImage(named: "direction_turn_left.png")!
            
        case .turnRight:
            return UIImage(named: "direction_turn_right.png")!
            
        case .turnSharpLeft:
            return UIImage(named: "direction_turn_sharp_left.png")!
            
        case .turnSharpRight:
            return UIImage(named: "direction_turn_sharp_right.png")!
            
        case .turnSlightLeft:
            return UIImage(named: "direction_turn_slight_left.png")!
            
        case .turnSlightRight:
            return UIImage(named: "direction_turn_slight_right.png")!
            
        case .uturnLeft:
            return UIImage(named: "direction_continue_uturn.png")!
            
        case .uturnRight:
            return UIImage(named: "direction_continue_uturn¯ß.png")!
        }
    }
}
