//
//  GlobalVariables.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation

enum GlobalConstants:String {
    case API_KEY = "0c85cffe9104df9ee2c115152189c41f" //from link: https://www.themoviedb.org/documentation/api
}

enum Sorting:Int {
    case mostPopular = 0, highestRated
    static func count() -> Int {
        return self.highestRated.rawValue + 1
    }
}

var imageBaseURL:String?
var posterSize:String?
var logoSize:String?
