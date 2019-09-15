//
//  NetworkHelper.swift
//  MVCacher_Example
//
//  Created by M. Ahsan Ali on 14/09/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import AANetworking
import AAExtensions

/// Apis collection
///
/// - data: Data to fetch the dump data from the network
enum ApiAction {
    case data
}

// MARK: - ApiAction
extension ApiAction: AANetwork_TargetType {
    
    // MARK: - Base URL
    var baseURL: URL {
        return URL(string: "http://pastebin.com/raw/")!
    }
    
    // MARK: - Headers array
    var headers: [String : String]? {
        return ["Content-Type": "application/x-www-form-urlencoded"]
    }
    
    // MARK: - Response Types
    var responseType: AANetwork_ResponseType {
        switch self {
        case .data:
            return .data
        }
    }
    
    // MARK: - Api Paths
    var path: String {
        switch self {
        case .data:
            return "wgkJgazE"
        }
    }
    
    // MARK: - Request Methods
    var method: AANetwork_Method { return .get }
    
    // MARK: - Sample Data
    var sampleData: Data { return Data() }
    
    // MARK: - Tasks
    var task: AANetwork_Task { return .requestPlain }
    
    // MARK: - Calls before the network call
    func onRequest() { }
    
    // MARK: - Calls after the network call
    func onResponse(statusCode: Int) { }

    // MARK: - Error handling
    func onError(error: AANetwork_Error) {
        print("MVCacherDemo:- ", error.localizedDescription)
    }
}
