//
//  ConnectionManager.swift
//  TechnicalTask-lvl1
//
//  Created by User on 28/11/2024.
//

import Combine
import Reachability

final class ConnectionManager {
    
    static let shared = ConnectionManager()
    private var reachability: Reachability?
    private var connectionStatusSubject = PassthroughSubject<Bool, Never>()
    
    private init() {
        reachability = try? Reachability()
    }
    
    var connectionStatus: AnyPublisher<Bool, Never> {
        return connectionStatusSubject.eraseToAnyPublisher()
    }
    
    func startMonitoring() {
        reachability?.whenReachable = { _ in
            self.connectionStatusSubject.send(true)
        }
        
        reachability?.whenUnreachable = { _ in
            self.connectionStatusSubject.send(false)
        }
        
        do {
            try reachability?.startNotifier()
            let isConnected = self.isConnectedToNetwork()
            self.connectionStatusSubject.send(isConnected)
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func stopMonitoring() {
        reachability?.stopNotifier()
    }
    
    private func isConnectedToNetwork() -> Bool {
        return reachability?.connection != .unavailable
    }
}
