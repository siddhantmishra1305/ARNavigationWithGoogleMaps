//
//  ServerRequestHandler.swift
//  AR Maps
//
//  Created by Siddhant Mishra on 19/04/20.
//  Copyright © 2020 Siddhant Mishra. All rights reserved.
//

import Foundation
import Alamofire

internal enum ServerRequestRouter: URLRequestConvertible{
    
    case getPath(String,String,Bool)
   
    

    var httpMethod:Alamofire.HTTPMethod {
        switch self {
            case .getPath:
                return .get
        }
    }
    
    var path: String {
        
        switch self {

        case .getPath:
            return "https://maps.googleapis.com/maps/api/directions/json"
        }
        
    }
    
    func asURLRequest() throws -> URLRequest {
        let URL = Foundation.URL(string: path)!
        var mutableURLRequest = URLRequest(url: URL)
        mutableURLRequest.httpMethod = httpMethod.rawValue
        mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        switch  self {
        
        case .getPath(let origin,let destination,let sensor):
              do{
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    let mapKey = appDelegate.googleMapsKey
                
                    var params = [String:Any]()
                    params["origin"] = origin
                    params["destination"] = destination
                    params["sensor"] = sensor
                    params["key"] = mapKey
                
                           
                    let encoding = URLEncoding(destination: URLEncoding.Destination.queryString)
                    return try encoding.encode(mutableURLRequest, with: params)
              } catch {
                    return mutableURLRequest
              }
        }
    }
}
