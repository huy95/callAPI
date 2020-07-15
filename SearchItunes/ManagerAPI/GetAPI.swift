//
//  GetAPI.swift
//  SearchItunes
//
//  Created by Taof on 5/21/20.
//  Copyright © 2020 taoquynh. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

func getItunes(_ searchText: String, success: @escaping (([Itune]?) -> Void), failure: @escaping ((String) -> Void)){
    let url = String(format: "https://itunes.apple.com/search?term=%@&limit=20", searchText)
    guard let urlString = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
    let urlRequest = URL(string: urlString) else {
        return
    }
    
    AF.request(urlRequest, method: .get, encoding: URLEncoding.default).responseJSON { (response) in
        switch response.result {
        case .success(let value):
            if let data = ItuneObject(json: JSON(value)) {
                if data.resultCount! > 0 {
                    success(data.results)
                }else{
                    failure("Not found result")
                }
            }
            
        case .failure(let error):
            failure(error.localizedDescription)
        }
    }
}
