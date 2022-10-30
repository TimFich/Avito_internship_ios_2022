//
//  MainScreenAssemble.swift
//  AvitoTask
//
//  Created by Тимур Миргалиев on 25.10.2022.
//

import Foundation
import UIKit

protocol IMainScreenAssemble: AnyObject {
    func assemble() -> UIViewController
}

final class MainScreenAssemble: IMainScreenAssemble {
    
    func assemble() -> UIViewController {
        let interactor = MainScreenInteractor()
        let view = MainScreenViewController()
        let presenter = MainScreenPresenter(interactor: interactor, view: view)
        view.presenter = presenter
        interactor.output = presenter
        return view
    }
}
