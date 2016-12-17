//
//  Nihongo.swift
//  Nihongo
//
//  Created by Toto Tvalavadze on 2016/12/17.
//  Copyright © 2016 Toto Tvalavadze. All rights reserved.
//

import Foundation

public class Nihongo {
    
    public typealias AnalyzerRequestCallback = ([Word]) -> ()
    
    init(yahooJapanAppId appId: String) {
        service = .yahooJapan(appId: appId)
    }
    
    func analyze(sentence: String, completion: @escaping AnalyzerRequestCallback) {
        guard case .yahooJapan(let appId) = service else {
            fatalError("Only Yahoo Japan's Morphological Analysis service is currently supported.")
        }
        guard let url = URL(string: "http://jlp.yahooapis.jp/MAService/V1/parse") else { return }
        
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let parameterizedUrl = queryParameters(for: url, parameters: [
            "appid": appId,
            "results": "ma",
            "sentence": sentence,
            "response": "surface,reading,pos,baseform"
            ]
        )
        
        var request = URLRequest(url: parameterizedUrl)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request, completionHandler: {
            (data: Data?, response: URLResponse?, error: Error?) in
            if (error == nil) {
                let statusCode = (response as! HTTPURLResponse).statusCode
                if let data = data, statusCode == 200 {
                    let parser = YahooMAServiceResponseParser(data: data, completion: completion)
                    parser.parse()
                } else {
                    // TODO: add error handling
                }
            } else {
                // Failure
                // TODO: proper error handling
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
    
    // MARK: Private stuff
    
    /// Services that can provide morphological analysis for Japanese language.
    /// - note: This is point for expansion. Only Yahoo.co.jp MA is supported for now.
    private enum Service {
        case yahooJapan(appId: String)
    }
    
    private let service: Service
    
    private func queryParameters(for url: URL, parameters: [String: String]) -> URL {
        var parts: [String] = []
        for (key, value) in parameters {
            let encodedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            let part = "\(encodedKey)=\(encodedValue)"
            parts.append(part)
        }
        let params = parts.joined(separator: "&")
        let fullUrl = "\(url)?\(params)"
        return URL(string: fullUrl)!
    }
    
}
