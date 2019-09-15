//
//  AANetworking+Constants.swift
//  AANetworking
//
//  Created by Muhammad Ahsan Ali on 08/03/2019.
//

import Moya


/// AANetwork alias
public typealias AANetwork_Method = Moya.Method
public typealias AANetwork_Task = Task
public typealias AANetwork_Provider = MoyaProvider
public typealias AANetwork_Response = Moya.Response
public typealias AANetwork_Cancellable = Cancellable
public typealias AANetwork_Error = MoyaError
public typealias AANetwork_Result = Result
public typealias AANetwork_Parameters = [String: Any]
public typealias AANetwork_LoggerPlugin = NetworkLoggerPlugin
public typealias AANetwork_CompletionResponse = ((Any) -> ())
public typealias AANetwork_CompletionError = ((AANetwork_Error) -> ())

public enum AANetwork_ResponseType {
    case object, objectPath(path: String?)
    case array, arrayPath(path: String?)
    case mapJSONDecoder(JSONDecoder), mapJSONDecoderPath(JSONDecoder, String?)
    case string, stringPath(path: String?)
    case json, image, data
}

public protocol AANetwork_TargetType : TargetType {
    var responseType: AANetwork_ResponseType { get }
    func onRequest()
    func onResponse(statusCode: Int, response: Any)
    func onError(error: AANetwork_Error)
}

public extension AANetwork_TargetType {
    func onRequest() {}
    func onResponse(statusCode: Int, response: Any) {}
    func onError(error: AANetwork_Error) {}
}

public extension AANetwork_TargetType {
    func aa_multipart(_ params: [String: Any]) -> [Moya.MultipartFormData] {
        return params.map { MultipartFormData(provider: .data("\($1)".data(using: .utf8)!), name: $0) }
    }
}

public func AAResponseJSONFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}
