//
//  ConfigurationAPI.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 12/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
struct ConfigurationAPI {
    private let apiKey = "api_key"
    private var api = GlobalVariables.API_KEY.rawValue
    private let method = "GET"
    
    func getUrl() -> String {
        return URLList.CONFIGURATION.rawValue
    }
    
    func getMethod() -> String {
        return method
    }
    
    func buildAPIParameter() throws -> [String: String]? {
        var params: [String:String] = [:]
        params[apiKey] = api
        return params
    }
}
