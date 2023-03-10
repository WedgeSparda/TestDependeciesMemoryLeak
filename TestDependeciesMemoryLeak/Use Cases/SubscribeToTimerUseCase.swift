//
//  SubscribeToTimerUseCase.swift
//  TestDependeciesMemoryLeak
//
//  Created by Roberto Pastor on 10/3/23.
//

import Foundation
import Combine
import Dependencies

public protocol SubscribeToTimerUseCase {
    func execute() -> AnyPublisher<Int, Never>
}

struct SubscribeToTimer: SubscribeToTimerUseCase {
    
    @Dependency(\.startTimerUseCase) var startTimerUseCase
    
    func execute() -> AnyPublisher<Int, Never> {
        startTimerUseCase.listenTotream()
    }
}

extension SubscribeToTimer: DependencyKey {
    static var liveValue: SubscribeToTimerUseCase = SubscribeToTimer()
}

extension DependencyValues {
    var subscribeToTimerUseCase: SubscribeToTimerUseCase {
        get { self[SubscribeToTimer.self] }
        set { self[SubscribeToTimer.self] = newValue }
    }
}
