//
//  MVCacherData.swift
//  MVCacher
//
//  Created by M. Ahsan Ali on 14/09/2019.
//


/// MVCacherData
class MVCacherData {
    let data: Data
    let identifier: String
    var accessTime = Date()
    
    /// total data bytes
    lazy var dataBytes: UInt64 = {
        return UInt64(data.count)
    }()
    
    
    /// Init with data and identifier
    ///
    /// - Parameters:
    ///   - data: item data
    ///   - identifier: item identifier
    init(_ data: Data, identifier: String) {
        self.data = data
        self.identifier = identifier
    }
    
    var cachedData: Data {
        accessTime = Date()
        return data
    }
}
