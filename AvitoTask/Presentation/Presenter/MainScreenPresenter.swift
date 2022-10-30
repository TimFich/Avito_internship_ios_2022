//
//  MainScreenPresenter.swift
//  AvitoTask
//
//  Created by Тимур Миргалиев on 25.10.2022.
//

import Foundation
import UIKit

private enum Constants {
    static let errorMessageTitle: String = "We have problems getting data"
    static let errorMessageDescription: String = "Try later, you can always update the data with a swipe up"
    static let errorMessageButtonTitle: String = "Okey"
}

protocol IMainScreenPresenter: AnyObject {
    var dataSource: Company? { get }

    func viewDidLoad()
    func viewNeedToGetData()
}

final class MainScreenPresenter: IMainScreenPresenter {

    // Properties
    private var interactor: MainScreenInteractor
    weak var view: MainScreenViewController?

    var dataSource: Company?

    init(interactor: MainScreenInteractor, view: MainScreenViewController) {
        self.interactor = interactor
        self.view = view
    }

    func viewDidLoad() {
        interactor.getStoredOrLoadСompanies {
            self.dataSource = $0
            self.view?.updateTableViewWithAnimation()
            self.view?.stopRefreshing()
        }
    }

    func viewNeedToGetData() {
        interactor.getLoadCompanies {
            self.dataSource = $0
            self.view?.updateTableViewWithAnimation()
            self.view?.stopRefreshing()
        }
    }
}

// MARK: - MainScreenInteractorOutput

extension MainScreenPresenter: MainScreenInteractorOutput {
    func needToShowAlert() {
        let alertController = UIAlertController(title: Constants.errorMessageTitle,
                                                message: Constants.errorMessageDescription,
                                                preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: Constants.errorMessageButtonTitle,
                                                style: .default,
                                                handler: nil)
        )
        view?.stopRefreshing()
        view?.showAlert(alert: alertController)
    }

    func needToUpdateCompanies() {
        view?.updateTableViewWithAnimation()
    }
}
