//
//  NetworkManager.swift
//  HeadyQuest
//
//  Created by SunilMaurya on 11/12/17.
//  Copyright © 2017 SunilMaurya. All rights reserved.
//

import Foundation
import Alamofire

private let _sharedInstance = APIManager()

/// This class is going to be the interface for the RestClient and will contain the customizable data
class APIManager {
    
    fileprivate init(){}
    
    static var sharedInstance: APIManager {
        return _sharedInstance
    }
    
    let restClient = RestClient()
    
    //MARK: - Movie search
    func getDataFromMovieSearchAPI(query: String, language: String? = nil, page: UInt64? = nil, includeAdult: Bool? = nil, region: String? = nil, year: UInt? = nil, primaryReleaseYear: UInt? = nil, onSuccess:@escaping (NSDictionary)->(), onFailure:@escaping (ErrorState)->()){
        let (apiBuilder,params) = APIBuilder.buildMovieSearchAPI(query: query, language: language, page: page, includeAdult: includeAdult, region: region, year: year, primaryReleaseYear: primaryReleaseYear)
        restClient.request(apiBuilder.getMethod(), urlString: apiBuilder.getUrl(),parameters: params as [String : AnyObject]?, shouldTrackForModification:true, onSuccess: onSuccess, onFailure: onFailure)
    }
    //MARK: - Configuration
    func getDataFromConfigurationAPI(onSuccess:@escaping (NSDictionary)->(), onFailure:@escaping (ErrorState)->()){
        let (apiBuilder,params) = APIBuilder.buildConfigurationAPI()
        restClient.request(apiBuilder.getMethod(), urlString: apiBuilder.getUrl(),parameters: params as [String : AnyObject]?, onSuccess: onSuccess, onFailure: onFailure)
    }
}

class RestClient {
    
    private var universalSearchRequestLogger : DataRequest? = nil
    private var sessionManager : [Alamofire.SessionManager] = []
    
    func request(_ methodStr:String, urlString:String, parameters params:[String : AnyObject]? = nil, headers:[String:String]? = nil, timeoutInterval: TimeInterval = 60, shouldTrackForModification:Bool = false, encodingOption: ParameterEncoding? = nil, onSuccess: @escaping (NSDictionary) -> (), onFailure: @escaping (ErrorState) -> ()){
        
        guard let alamoMethod = HTTPMethod(rawValue: methodStr.uppercased()) else {
            onFailure(ErrorState.failure)
            return
        }
        let encoding = encodingOption ?? URLEncoding(destination: .methodDependent)
        
        if shouldTrackForModification {
            if universalSearchRequestLogger != nil {
                universalSearchRequestLogger?.cancel()
                universalSearchRequestLogger = nil
            }
        }
        
        let parameterFormat:Dictionary<String, Any>? = params
        
        // Request completion block
        let completionBlock = { [weak self] (response: DataResponse<Any>) in
            
            guard let self_ = self else {
                return
            }
            
            if shouldTrackForModification && self_.universalSearchRequestLogger != nil {
                self_.universalSearchRequestLogger = nil
            }
            
            switch response.result {
            case .success:
                if let json = response.result.value {
                    if response.response?.statusCode == 200 {
                        if JSONSerialization.isValidJSONObject(json) {
                            if let jsonOutput = json as? NSDictionary {
                                onSuccess(jsonOutput)
                            } else if let jsonOutput = json as? NSArray {
                                onSuccess(NSDictionary(dictionary: ["Success": jsonOutput]))
                            }
                        }
                    }
                } else {
                    onFailure(ErrorState.failure)
                }
            case .failure(_):
                if NetworkReachabilityManager()?.isReachable ?? true {
                    onFailure(ErrorState.failure)
                } else  {
                    onFailure(ErrorState.noNetwork)
                }
            }
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval
        let manager = Alamofire.SessionManager(configuration: configuration)
        let alamoRequest = manager.request(urlString, method: alamoMethod, parameters: parameterFormat, encoding: encoding, headers: headers).validate().responseJSON { (response) in
            completionBlock(response)
            if let index = self.sessionManager.index(where: { (mgr) -> Bool in
                return mgr === manager
            }){
                self.sessionManager.remove(at: index)
            }
        }
        
        sessionManager.append(manager)
        if shouldTrackForModification {
            universalSearchRequestLogger = alamoRequest
        }
    }
}
