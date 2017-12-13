//
//  ConfigurationAPI.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 12/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
struct ConfigurationAPI {
    //Key & Variables
    private let apiKey = "api_key"
    private var api = GlobalConstants.API_KEY.rawValue
    private let method = "GET"
    
    //MARK:- Get Url
    func getUrl() -> String {
        return URLList.CONFIGURATION.rawValue
    }
    
    //MARK:- Get method
    func getMethod() -> String {
        return method
    }
    
    //MARK:- API Building
    func buildAPIParameter() throws -> [String: String]? {
        var params: [String:String] = [:]
        params[apiKey] = api
        return params
    }
}
