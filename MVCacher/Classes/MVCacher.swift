//
//  MVCacher.swift
//  AAExtensions
//
//  Created by M. Ahsan Ali on 14/09/2019.
//

/// Private variables
fileprivate let QueueID = "com.aacreations.mvcacher"

/// MARK:- MVCacher
open class MVCacher {

    /// Cache Types
    ///
    /// - memory: in memory
    public enum MVCacherType {
        case memory
    }
    
    public var memoryCapacity: UInt64 = 100 * 1024 * 1024
    public var memoryUsageAfterPurge: UInt64 = 50 * 1024 * 1024
    
    var usedMemory: UInt64 = 0
    var cacheType: MVCacherType
    var cachedItems: [String: MVCacherData] = [:]
    var downloadTasks: [String: URLSessionDataTask] = [:]

    /// Cache Queue
    lazy var queue: DispatchQueue = {
        let name = String(format: "%@-%08x%08x%08x", QueueID, arc4random(), arc4random(), arc4random())
        return DispatchQueue(label: name, attributes: .concurrent)
    }()
    
    /// Init the cacher with the cache type
    ///
    /// - Parameter cacheType: cache type
    public init(cacheType: MVCacherType = .memory) {
        
        self.cacheType = cacheType
    
        if memoryCapacity <= memoryUsageAfterPurge {
            memoryUsageAfterPurge = memoryCapacity
        }
        
        addMemoryObserver()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    /// Register the memory receive warning
    func addMemoryObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clearCache),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
}

// MARK: - Helper methods for get, add and remove from cache
public extension MVCacher {
    
    /// Add the item to cache
    ///
    /// - Parameters:
    ///   - data: Data to cache
    ///   - identifier: cache identifier
    func addItem(_ data: Data, identifier: String) {
        guard cacheType == .memory else {
            fatalError("MVCacher:- In-Memory supported only")
        }
        
        queue.async(flags: [.barrier]) {
            let cachedImage = MVCacherData(data, identifier: identifier)
            
            if let previousCachedImage = self.cachedItems[identifier] {
                self.usedMemory -= previousCachedImage.dataBytes
            }
            
            self.cachedItems[identifier] = cachedImage
            self.usedMemory += cachedImage.dataBytes
        }
        
        queue.async(flags: [.barrier]) {
            guard self.usedMemory > self.memoryCapacity else { return }
            
            var sortItems = self.cachedItems.map { $1 }
            sortItems.sort { $0.accessTime.timeIntervalSince($1.accessTime) < 0.0 }
            
            var bytesPurged = UInt64(0)
            let bytesToPurge = self.usedMemory - self.memoryUsageAfterPurge
            sortItems.forEach {
                self.cachedItems.removeValue(forKey: $0.identifier)
                bytesPurged += $0.dataBytes
                if bytesPurged >= bytesToPurge { return }
            }
            
            self.usedMemory -= bytesPurged
        }
    }
    
    /// Remove the cached Item
    ///
    /// - Parameter identifier: cache identifier
    func removeItem(identifier: String)  {
        guard cacheType == .memory else {
            fatalError("MVCacher:- In-Memory supported only")
        }

        queue.sync {
            if let cachedImage = self.cachedItems.removeValue(forKey: identifier) {
                self.usedMemory -= cachedImage.dataBytes
            }
        }
    }
    
    /// Get the cached Item
    ///
    /// - Parameter identifier: cache identifier
    /// - Returns: Cached Data if exists
    func getItem(identifier: String) -> Data? {
        guard cacheType == .memory else {
            fatalError("MVCacher:- In-Memory supported only")
        }
        
        var data: Data?

        queue.sync {
            if let cachedImage = self.cachedItems[identifier] {
                data = cachedImage.cachedData
            }
        }
        
        return data
    }
    
    /// Clear the cache and stops all the pending data tasks
    @objc func clearCache() {
        guard cacheType == .memory else {
            fatalError("MVCacher:- In-Memory supported only")
        }
        queue.sync {
            if !self.cachedItems.isEmpty {
                self.cachedItems.removeAll()
                self.usedMemory = 0
            }
        }
        
        downloadTasks.forEach { $1.cancel() }
        downloadTasks.removeAll()
    }
    

    
}

// MARK: - Helper methods for downloading the data from network
public extension MVCacher {
    
    /// Used memory
    var memoryUsage: UInt64 {
        var memoryUsage: UInt64 = 0
        queue.sync { memoryUsage = self.usedMemory }
        return memoryUsage
    }
    
    /// Cancel the data task with identifier
    ///
    /// - Parameter identifier: item identifier
    func cancelTask(_ identifier: String) {
        downloadTasks[identifier]?.cancel()
    }
    
    /// Downloads the data from network and cache that data
    ///
    /// - Parameters:
    ///   - urlString: Network API Endpoint for data
    ///   - identifier: Cache Identifier
    ///   - completion: Completion block
    func downloadData(_ urlString: String, identifier: String, completion: @escaping ((Data) -> ())) {

        guard let url = URL(string: urlString) else {
            print("MVCacher:- ", "Error accessing \(urlString)")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let data = data, error == nil {
                self.addItem(data, identifier: urlString)
                self.downloadTasks[identifier] = nil
                completion(data)
            }
            else {
                print("MVCacher:- ", "Error loading \(url)")
            }
            
        }
        
        downloadTasks[identifier] = task
        task.resume()

    }
}
