//
//  CVReachability.swift
//  CVNetworking
//
//  Created by caven on 2018/11/27.
//  Copyright © 2018 com.caven. All rights reserved.
//

import Foundation
import Alamofire

typealias OnClosureNetworkStateChanged = (_ state: CVNetworkState)->()

enum CVNetworkState {
    case unknown     // 未知
    case wwan
    case ethernetOrWiFi // 以太网或wifi
    case notReachable   // 无网
}

public class CVReachability: NSObject, SelfAware {
    
    static let share = CVReachability()
    
    public var isReachable: Bool { return _isReachable() }
    
    lazy private var reachability: NetworkReachabilityManager = { return _reachability() }()
    private var stateChanged: OnClosureNetworkStateChanged?
    
    deinit {
        stopListening()
    }
    
    
    public static func swiftyLoad() {
        CVReachability.share.startListening()
    }
}

// MARK: - Public Methods
extension CVReachability {
    
    func startListening() {
        reachability.startListening()
    }
    
    func stopListening() {
        reachability.stopListening()
    }
    
    func stateChanged(state: OnClosureNetworkStateChanged?) {
        stateChanged = state
    }
}

// MARK: - Getter Setter
fileprivate extension CVReachability {
    func _reachability() -> NetworkReachabilityManager {
        let mananger = NetworkReachabilityManager()!
        mananger.listener = { (state: NetworkReachabilityManager.NetworkReachabilityStatus) in
            switch state {
            case .notReachable:
                self.stateChanged?(.notReachable)
            case .unknown:
                self.stateChanged?(.unknown)
            case .reachable(.ethernetOrWiFi):
                self.stateChanged?(.ethernetOrWiFi)
            case .reachable(.wwan):
                self.stateChanged?(.wwan)
            }
        }
        return mananger
    }
    
    func _isReachable() -> Bool {
        // 当 WIFI, 以太网， WWAN，或 未知状态均认为已联网
        if reachability.isReachable || reachability.networkReachabilityStatus == .unknown {
            return true
        }
        return false
    }
}
