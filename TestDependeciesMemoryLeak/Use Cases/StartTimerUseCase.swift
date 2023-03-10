//
//  StartTimerUseCase.swift
//  TestDependeciesMemoryLeak
//
//  Created by Roberto Pastor on 10/3/23.
//

import Foundation
import Combine
import Dependencies

public protocol StartTimerUseCase {
    func listenTotream() -> AnyPublisher<Int, Never>
}

final class StartTimer: StartTimerUseCase {
    
    private var subscriptions = Set<AnyCancellable>()
    private var stream: PassthroughSubject<Int, Never> = .init()
    private var timer = Timer.publish(every: 1, on: .main, in: .default)
        
    init() {
        start()
    }
    
    private func start() {
        timer
            .autoconnect()
            .map { _ in Int.random(in: 0...1_000) }
            .sink { [weak self] in
                print("--> Random generated value is \($0)")
                self?.stream.send($0)
            }
            .store(in: &subscriptions)
    }
    
    func listenTotream() -> AnyPublisher<Int, Never> {
        stream.eraseToAnyPublisher()
    }
}

extension StartTimer: DependencyKey {
    static var liveValue: StartTimerUseCase = StartTimer()
}


extension DependencyValues {
    var startTimerUseCase: StartTimerUseCase {
        get { self[StartTimer.self] }
        set { self[StartTimer.self] = newValue }
    }
}
