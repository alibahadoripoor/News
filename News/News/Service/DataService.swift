//
//  DataService.swift
//  News
//
//  Created by Ali Bahadori on 07.08.20.
//  Copyright © 2020 Ali Bahadori. All rights reserved.
//

import Foundation

enum HTTPError: Error {
    case invalidResponse, noData, failedRequest, invalidData
}

typealias fetchDataCompletion = (Data?, HTTPError?) -> ()
typealias cancelCompletion = () -> ()

protocol DataServiceProtocol {
    func fetchData(for url: URL, completion: @escaping (Data?, HTTPError?) -> ())
    func cancel()
}

final class DataService: DataServiceProtocol{
    private var task: URLSessionDataTask!
   
    func fetchData(for url: URL, completion: @escaping (Data?, HTTPError?) -> ()){
        let session: URLSession = .shared
        task = session.dataTask(with: url) { (data, response, error) in
                    
            DispatchQueue.main.async {
                
                guard error == nil else {
                    debugPrint("The request is failed: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    debugPrint("Unable to process response")
                    completion(nil, .invalidResponse)
                    return
                }
                
                guard response.statusCode == 200 else {
                    debugPrint("Failure response: \(response.statusCode)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    debugPrint("No data returned")
                    completion(nil, .noData)
                    return
                }
                
                completion(data, nil)
                
            }
            
        }
        
        task.resume()
    }
    
    func cancel(){
        task?.cancel()
    }
    
}
