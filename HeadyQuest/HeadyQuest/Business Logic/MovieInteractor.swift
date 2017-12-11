//
//  MovieInteractor.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

protocol MovieSearchProtocol: class {
    func didReceiveSearchedMovieData(_ movies: [Movie])
    func didFailToReceiveSearchedMovieData(errorState:ErrorState)
}

class MovieInteractor {
    weak var delegate: MovieSearchProtocol?
    fileprivate let apiManager = APIManager.sharedInstance
    var currentPage:UInt64?
    var totalPages:UInt64?
    
    func getMovieViaSearch(query:String) {
        apiManager.getDataFromMovieSearchAPI(query: query, page:currentPage
            , onSuccess: { (dict) in
                print(dict)
                let json = JSON(dict)
                self.currentPage = json["page"].uInt64Value
                self.totalPages = json["total_pages"].uInt64Value
                let dataArray = json["results"].arrayObject
                if let movieList = Mapper<Movie>().mapArray(JSONObject: dataArray) {
                    self.delegate?.didReceiveSearchedMovieData(movieList)
                    return
                }
                self.delegate?.didFailToReceiveSearchedMovieData(errorState: .emptyState)
                
        }) { errorState in
            self.delegate?.didFailToReceiveSearchedMovieData(errorState: errorState)
        }
    }
}
