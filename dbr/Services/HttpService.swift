//
//  HttpService.swift
//  dbr
//
//  Created by Ray Krow on 9/27/18.
//  Copyright © 2018 Kirk. All rights reserved.
//

import RxSwift
import Alamofire
import Foundation

struct HttpService {
    
    private static func sendPost(_ endpoint: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, encoding: ParameterEncoding = JSONEncoding.default) -> Observable<Result<Any>> {
        return Observable.create { (observer) -> Disposable in
            let req = Alamofire.request(endpoint, method: .post, parameters: parameters, encoding: encoding, headers: headers).responseJSON { response in
                guard response.result.isSuccess else {
                    debugPrint(response)
                    return observer.onError(DBRError(data: response.data, message: "Request failed"))
                }
                guard let _ = response.result.value else {
                    debugPrint(response)
                    return observer.onError(DBRError(data: response.data, message: "Response is empty"))
                }
                observer.onNext(response.result)
                observer.onCompleted()
            }
            return Disposables.create {
                req.cancel()
            }
        }
        
    }
    
    private static func sendGet(_ endpoint: String, parameters: Parameters? = nil, headers: HTTPHeaders? = nil) -> Observable<Result<Any>> {
        return Observable.create { (observer) -> Disposable in
            let req = Alamofire.request(endpoint, method: .get, parameters: parameters, headers: headers).responseJSON { response in
                
                guard response.result.isSuccess else {
                    debugPrint(response)
                    return observer.onError(DBRError(data: response.data, message: "Request failed"))
                }
                guard let _ = response.result.value else {
                    debugPrint(response)
                    return observer.onError(DBRError(data: response.data, message: "Response is empty"))
                }
                observer.onNext(response.result)
                observer.onCompleted()
                
            }
            
            return Disposables.create {
                req.cancel()
            }
            
        }
        
    }
}

extension HttpService {
    
    // POST
    public static func post(_ endpoint: String) -> Observable<Result<Any>> {
        return HttpService.sendPost(endpoint)
    }
    public static func post(_ endpoint: String, headers: HTTPHeaders?) -> Observable<Result<Any>> {
        return HttpService.sendPost(endpoint, headers: headers)
    }
    public static func post(_ endpoint: String, json: Codable?, headers: HTTPHeaders?) -> Observable<Result<Any>> {
        return HttpService.sendPost(endpoint, parameters: json?.dictionary, headers: headers)
    }
    public static func post(_ endpoint: String, json: Codable?) -> Observable<Result<Any>> {
        return HttpService.sendPost(endpoint, parameters: json?.dictionary)
    }
    public static func post(_ endpoint: String, parameters: Parameters?) -> Observable<Result<Any>> {
        return HttpService.sendPost(endpoint, parameters: parameters, encoding: URLEncoding.default)
    }
    public static func post(_ endpoint: String, parameters: Parameters?, headers: HTTPHeaders?) -> Observable<Result<Any>> {
        return HttpService.sendPost(endpoint, parameters: parameters, headers: headers, encoding: URLEncoding.default)
    }
    
    // GET
    public static func get(_ endpoint: String, headers: HTTPHeaders?) -> Observable<Result<Any>> {
        return HttpService.sendGet(endpoint, headers: headers)
    }
    public static func get(_ endpoint: String, parameters: Parameters?) -> Observable<Result<Any>> {
        return HttpService.sendGet(endpoint, parameters: parameters)
    }
    public static func get(_ endpoint: String) -> Observable<Result<Any>> {
        return HttpService.sendGet(endpoint)
    }
    public static func get(_ endpoint: String, parameters: Parameters?, headers: HTTPHeaders?) -> Observable<Result<Any>> {
        return HttpService.sendGet(endpoint, parameters: parameters, headers: headers)
    }
}


// curl -v -H "Accept-Language: en;q=1.0" -H "Authorization: Token c8e9443e501ba6ca417f14d0407f2d7459a22a0f" -H "User-Agent: dbr/1.0 (com.kirk.dbr; build:1; iOS 11.4.0) Alamofire/4.7.3" -H "Accept-Encoding: gzip;q=1.0, compress;q=0.5" https://api.esv.org/v3/passage/text?q=Isaiah%2022-23
