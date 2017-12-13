//
//  MovieSearchAPI.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation

struct MovieSearchAPI {
    //Keys
    private let queryKey = "query"
    private let apiKey = "api_key"
    private let languageKey = "language"
    private let pageKey = "page"
    private var includeAdultKey = "includeAdult"
    private let regionKey = "region"
    private let yearKey = "year"
    private let primaryReleaseYearKey = "primary_release_year"
    
    //Variables
    private var query:String?
    private var api = GlobalConstants.API_KEY.rawValue
    private var language:String? = "en-US"
    private var page:UInt64? = 1
    private var includeAdult:Bool? = false
    private var region:String?
    private var year:UInt?
    private var primaryReleaseYear:UInt?
    private let method = "GET"
    
    //MARK:- Initialization
    init(query: String, language: String? = nil, page: UInt64? = nil, includeAdult: Bool? = nil, region:String? = nil, year:UInt? = nil, primaryReleaseYear:UInt? = nil) {
        self.query = query
        self.language = language
        self.page = page
        self.includeAdult = includeAdult
        self.region = region
        self.year = year
        self.primaryReleaseYear = primaryReleaseYear
    }
    
    //MARK:- Get Url
    func getUrl() -> String {
        return URLList.MOVIE_SEARCH.rawValue
    }
    
    //MARK:- Get method
    func getMethod() -> String {
        return method
    }
    
    //MARK:- API Building
    func buildAPIParameter() throws -> [String: Any]? {
        var params: [String:Any] = [:]
        
        params[queryKey] = query
        params[apiKey] = api
        params[languageKey] = language
        params[pageKey] = page
        params[includeAdultKey] = includeAdult
        params[regionKey] = region
        params[yearKey] = year
        params[primaryReleaseYearKey] = primaryReleaseYear
        
        return params
    }
}
