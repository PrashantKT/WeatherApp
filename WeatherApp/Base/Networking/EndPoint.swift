//
//  ApiURLBuilder.swift
//  WeatherApp
//
//  Created by Prashant Tukadiya on 02/05/24.
//

import Foundation

extension Dictionary<String,String> {
    
    func createURLQueryString() -> [URLQueryItem] {
        
        self.map{URLQueryItem(name: $0.key, value: $0.value)}
    }
    
}


protocol EndPoint {
    
    var baseURL:String {get}
    var apiVersion:String {get}
    var path:String {get}
    var queryPara:[String:String] {get}
}


extension EndPoint {
    func prepareURL() -> URL {
        var url = URL.init(string: baseURL)!
        url.append(path: apiVersion)
        url.append(path: path)
        
        url.append(queryItems: queryPara.createURLQueryString())
        return url
        
    }
}
