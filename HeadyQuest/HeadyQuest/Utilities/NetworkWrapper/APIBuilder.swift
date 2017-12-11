//
//  APIBuilder.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
class APIBuilder {
    //MARK:- Movie Search API
    static func buildMovieSearchAPI(query: String, language: String? = nil, page: UInt64? = nil, includeAdult: Bool? = nil, region: String? = nil, year: UInt? = nil, primaryReleaseYear: UInt? = nil)->(MovieSearchAPI, [String:Any]?) {
        let apiObject = MovieSearchAPI(query: query, language: language, page: page, includeAdult: includeAdult, region: region, year: year, primaryReleaseYear: primaryReleaseYear)
        var params:[String:Any]? {
            do {
                let temp = try apiObject.buildAPIParameter()
                return temp
            } catch {
                print("Error building MovieSearchAPI PARAMS")
                return nil
            }
        }
        return (apiObject, params)
    }
}
