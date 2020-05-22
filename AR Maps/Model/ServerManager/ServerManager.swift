//
//  ServerManager.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 19/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import Foundation
import Alamofire

public enum ServerErrorCodes: Int{
    case notFound = 404
    case validationError = 422
    case internalServerError = 500
    
}


public enum ServerErrorMessages: String{
    case notFound = "Not Found"
    case validationError = "Validation Error"
    case internalServerError = "Internal Server Error"
}


public enum ServerError: Error{
    case systemError(Error)
    case customError(String)
    
    public var details:(code:Int ,message:String){
        switch self {
            
        case .customError(let errorMsg):
            switch errorMsg {
            case "Not Found":
                return (ServerErrorCodes.notFound.rawValue,ServerErrorMessages.notFound.rawValue)
            case "Validation Error":
                return (ServerErrorCodes.validationError.rawValue,ServerErrorMessages.validationError.rawValue)
            case "Internal Server Error":
                 return (ServerErrorCodes.internalServerError.rawValue,ServerErrorMessages.internalServerError.rawValue)
            default:
                return (ServerErrorCodes.internalServerError.rawValue,ServerErrorMessages.internalServerError.rawValue)
            }
            
        case .systemError(let errorCode):
            return (errorCode._code,errorCode.localizedDescription)
        }
    }
}

public struct ServerManager{
    static let sharedInstance = ServerManager()
    
    func getPath(origin:String,destination:String,sensor:Bool,_ handler: @escaping (String?,ServerError?,TravelDetail?) -> Void){
        
        Alamofire.request(ServerRequestRouter.getPath(origin, destination, sensor)).validate().responseJSON
                {(response) in
                
                switch response.result {
            
                case .success:
                    if let json = response.result.value as? [String: Any]{
                        let preRoutes = json["routes"] as! NSArray
                        if preRoutes.count > 0 {
                            let routes = preRoutes[0] as! NSDictionary
                            let travelDetailFromRoute = routes.value(forKey: "legs") as? [[String:Any]]
                            var travelDetail = TravelDetail()
                            
                            for item in travelDetailFromRoute!{
                                 travelDetail = TravelDetail(JSON: item)
                            }
                        
                            let routeOverviewPolyline:NSDictionary = routes.value(forKey: "overview_polyline") as! NSDictionary
                            let polyString = routeOverviewPolyline.object(forKey: "points") as! String
                            handler(polyString,nil,travelDetail)
                        }else{
                            handler(nil,ServerError.customError("404"),nil)
                        }
                       
                    }else{
                        handler(nil,ServerError.customError("404"),nil)
                    }
                        
                    
                case .failure(let error):

                    print(error)
                    if error.localizedDescription .contains("404"){
                        handler(nil,ServerError.customError("Not Found"),nil)
                    } else if error.localizedDescription.contains("422") {
                        handler(nil,ServerError.customError("Validation Error"),nil)
                    } else if error.localizedDescription.contains("500"){
                        handler(nil,ServerError.customError("Internal Server Error"),nil)
                    }
                    else{
                        handler(nil,ServerError.systemError(error),nil)
                    }
                }
            }
    }
    
    
    
    
}
