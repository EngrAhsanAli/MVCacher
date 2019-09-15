//
//  AANetworking.swift
//  AANetworking
//
//  Created by Muhammad Ahsan Ali on 08/03/2019.
//

import Moya

extension AANetwork_Provider {
    
    @discardableResult
    open func aa_request<T: Codable>(_ target: AANetwork_TargetType,
                                  type: T.Type, completion: AANetwork_CompletionResponse?,
                                  onError: AANetwork_CompletionError? = nil) -> AANetwork_Cancellable {
        
        target.onRequest()
        
        return request(target as! Target) { (result) in
            
            var statusCode: Int
            var responseData: Any
            
            switch result {
            case let .success(response):
                statusCode = response.statusCode
                do {
                    switch target.responseType {
                    case .object:
                        responseData = try response.map(T.self, failsOnEmptyData: false)
                    case .objectPath(let path):
                        responseData = try response.map(T.self, atKeyPath: path, failsOnEmptyData: false)
                    case .array:
                        responseData = try response.map([T].self, failsOnEmptyData: false)
                    case .arrayPath(let path):
                        responseData = try response.map([T].self, atKeyPath: path, failsOnEmptyData: false)
                    case let .mapJSONDecoder(d):
                        responseData = try response.map(T.self, atKeyPath: nil, using: d, failsOnEmptyData: false)
                    case let .mapJSONDecoderPath(d, p):
                        responseData = try response.map(T.self, atKeyPath: p, using: d, failsOnEmptyData: false)
                    default:
                        responseData = response.data
                    }
                } catch {
                    responseData = response.data
                    print("AANetworkHelper: ", error.localizedDescription)
                }
                
            case let .failure(error):
                statusCode = error.response?.statusCode ?? error.errorCode
                responseData = result.value?.data ?? error
                onError?(error)
                target.onError(error: error)
                print("AANetworkHelper: Error...\(error.localizedDescription)")
            }
            completion?(responseData)
            target.onResponse(statusCode: statusCode, response: responseData)
        }
    }
    
    @discardableResult
    open func aa_request(_ target: AANetwork_TargetType,
                     completion: AANetwork_CompletionResponse?,
                     onError: AANetwork_CompletionError? = nil) -> AANetwork_Cancellable {
        
        target.onRequest()
        
        return request(target as! Target) { (result) in
            
            var statusCode: Int
            var responseData: Any
            switch result {
            case let .success(response):
                statusCode = response.statusCode
                do {
                    switch target.responseType {
                    case .string:
                        responseData = try response.mapString()
                    case .stringPath(let path):
                        responseData = try response.mapString(atKeyPath: path)
                    case .image:
                        responseData = try response.mapImage()
                    case .json:
                        responseData = try response.mapJSON()
                    case .data:
                        responseData = response.data
                    default:
                        responseData = response.data
                    }
                } catch {
                    responseData = response.data
                    print("AANetworkHelper: ", error.localizedDescription)
                }
                
                break
                
            case let .failure(error):
                statusCode = error.response?.statusCode ?? error.errorCode
                responseData = result.value?.data ?? error
                onError?(error)
                target.onError(error: error)
                print("AANetworkHelper: Error...\(error.localizedDescription)")
            }

            completion?(responseData)
            target.onResponse(statusCode: statusCode, response: responseData)
            
        }
            
    }
    
    

    
}


