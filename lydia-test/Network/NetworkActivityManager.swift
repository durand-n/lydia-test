//
//  NetworkActivityManager.swift
//  lydia-test
//
//  Created by Benoît Durand on 17/10/2020.
//

import Foundation
import Network

class NetworkActivityManager: NSObject {
    var isConnected: Bool {
        return false
    }
    var didConnect: (() -> Void)?
    var didDisconnect: (() -> Void)?
    func setup() {}
    
    static let shared: NetworkActivityManager = NetworkActivityMonitor()
    
    override init() {
        
    }
}

@available(iOS 12.0, *)
final class NetworkActivityMonitor: NetworkActivityManager {
    override var isConnected: Bool {
        return wasConnected
    }
    
    private var wasConnected = true
    private let activity = NWPathMonitor()
    
    override init() {
    }
    
    override func setup() {
        activity.pathUpdateHandler = { path in
            if path.status == .satisfied {
                if !self.wasConnected {
                    self.didConnect?()
                    self.wasConnected = true
                }
            } else {
                if self.wasConnected {
                    self.didDisconnect?()
                    self.wasConnected = false
                }
            }
        }
        let queue = DispatchQueue.global(qos: .background)
        activity.start(queue: queue)
    }
}

