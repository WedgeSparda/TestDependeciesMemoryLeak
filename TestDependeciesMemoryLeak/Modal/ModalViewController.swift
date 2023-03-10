//
//  ModalViewController.swift
//  TestDependeciesMemoryLeak
//
//  Created by Roberto Pastor on 10/3/23.
//

import UIKit
import Combine
import Dependencies

class ModalViewController: UIViewController {

    @Dependency(\.subscribeToTimerUseCase) var subscribeToTimerUseCase
    private var subscriptions = Set<AnyCancellable>()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToTimerUseCase
            .execute()
            .sink {
                print("--> Received values is \($0)")
            }
            .store(in: &subscriptions)
    }
    
    deinit {
        print("--> DEINIT MODAL")
    }

}
