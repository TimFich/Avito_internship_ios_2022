//
//  MainFlowCoordinator.swift
//  AvitoTask
//
//  Created by Тимур Миргалиев on 25.10.2022.
//

import Foundation
import UIKit

protocol FlowCoordinatorProtocol: AnyObject {
    func start(animated: Bool)
    func finish()
}

final class MainFlowCoordinator: FlowCoordinatorProtocol {
    
    //  Properties
    private let mainScreenAssemble: MainScreenAssemble = MainScreenAssemble()
    weak var parentViewController: UINavigationController?

    // MARK: - Initialization

    init(parentViewController: UINavigationController?) {
        self.parentViewController = parentViewController
    }

    func start(animated: Bool) {
        let view = mainScreenAssemble.assemble()
        parentViewController?.pushViewController(view, animated: animated)
    }

    func finish() {
        // unused
    }
}
