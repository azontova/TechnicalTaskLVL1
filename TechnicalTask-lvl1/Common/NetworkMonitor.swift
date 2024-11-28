//
//  NetworkMonitor.swift
//  TechnicalTask-lvl1
//
//  Created by User on 28/11/2024.
//

import Combine
import Reachability

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private var reachability: Reachability?
    private var connectionStatusRelay = PassthroughSubject<Bool, Never>()
    
    var connectionStatus: AnyPublisher<Bool, Never> {
        connectionStatusRelay.eraseToAnyPublisher()
    }
    
    private init() {
        reachability = try? Reachability()
    }
    
    func startMonitoring() {
        try? reachability?.startNotifier()
        reachability?.whenReachable = { _ in
            self.connectionStatusRelay.send(true)
        }
        reachability?.whenUnreachable = { _ in
            self.connectionStatusRelay.send(false)
        }
    }
    
    func stopMonitoring() {
        reachability?.stopNotifier()
    }
}
