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

//MARK:- Movie Search Protocol
protocol MovieSearchProtocol: class {
    func didReceiveSearchedMovieData(_ movies: [Movie])
    func didFailToReceiveSearchedMovieData(errorState:ErrorState)
}

//MARK:- Movie Interactor
class MovieInteractor {
    //Variables
    weak var delegate: MovieSearchProtocol?
    fileprivate let apiManager = APIManager.sharedInstance
    var currentPage:UInt64?
    var totalPages:UInt64?
    var selectedSortingOption:Sorting?
    
    //MARK:- Get movie via search
    func getMovieViaSearch(query:String, currentPage:UInt64? = 1) {
        apiManager.getDataFromMovieSearchAPI(query: query, page:currentPage
            , onSuccess: { (dict) in
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
    
    //MARK:- Get configuration for getting image
    func getConfiguration() {
        apiManager.getDataFromConfigurationAPI(onSuccess: { (dict) in
            let json = JSON(dict)
            imageBaseURL = json["images"]["base_url"].stringValue
            if let posterSizeArray = json["images"]["poster_sizes"].arrayObject {
                if posterSizeArray.count > 3 {//for fitting on imageview
                    posterSize = posterSizeArray[3] as? String
                } else if !posterSizeArray.isEmpty {
                    posterSize = posterSizeArray.last as? String
                }
            }
            if let logoSizeArray = json["images"]["logo_sizes"].arrayObject {
                if !logoSizeArray.isEmpty {
                    logoSize = logoSizeArray.last as? String
                }
            }
            
        }) { errorState in
            print(errorState.getErrorMessage())
        }
    }
    
    //MARK:- Sorting functionality
    func setSorting(sorting:Sorting) {
        self.selectedSortingOption = sorting
    }
    
    func sorting(movieData:[Movie]) ->[Movie] {
        var sortedMovieList = movieData
        if let sortingOption = self.selectedSortingOption {
            if sortingOption == .mostPopular {//apply sorting as most popular
                sortedMovieList.sort(by: { (movie1, movie2) -> Bool in
                    return movie1.popularity ?? 0 > movie2.popularity ?? 0
                })
            } else if sortingOption == .highestRated {//apply sorting as highest rated
                sortedMovieList.sort(by: { (movie1, movie2) -> Bool in
                    return movie1.voteCount ?? 0 > movie2.voteCount ?? 0
                })
            }
        }
        return sortedMovieList
    }
}
