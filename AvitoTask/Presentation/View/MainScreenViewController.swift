//
//  MainScreenViewController.swift
//  AvitoTask
//
//  Created by Тимур Миргалиев on 25.10.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let cellReuseIdentifier: String = "companyCell"
}

protocol IMainScreenViewController: AnyObject {
    func updateTableViewWithAnimation()
    func stopRefreshing()
    func showAlert(alert: UIAlertController)
}

final class MainScreenViewController: UIViewController, IMainScreenViewController {

    // Properties
    var presenter: MainScreenPresenter!

    // UI
    private lazy var refreshControll: UIRefreshControl = {
        let controll = UIRefreshControl()
        controll.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        return controll
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: Constants.cellReuseIdentifier)
        tableView.refreshControl = refreshControll
        tableView.backgroundColor = .systemBackground
        return tableView
    }()

    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUpUI()
        refreshControll.beginRefreshing()
        presenter.viewDidLoad()
    }

    func updateTableViewWithAnimation() {
        DispatchQueue.main.async {
            self.tableView.reloadSections(IndexSet(integersIn: 0..<self.tableView.numberOfSections),
                                          with: .automatic)
        }
    }

    func stopRefreshing() {
        DispatchQueue.main.async {
            self.refreshControll.endRefreshing()
        }
    }

    func showAlert(alert: UIAlertController) {
        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }

    // MARK: - Private

    private func setUpUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.bottom.equalToSuperview()
        }
    }

    // MARK: - Actions

    @objc
    private func refreshTable() {
        presenter.viewNeedToGetData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension MainScreenViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.dataSource?.employees.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellReuseIdentifier) as? MainTableViewCell,
              let employees = presenter.dataSource?.employees else { return UITableViewCell() }
        
        cell.configure(employee: employees[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let name = presenter.dataSource?.name,
              let count = presenter.dataSource?.employees.count else { return UIView() }

        return MainHeaderView(companyName: name, countOfEmployees: count)
    }
}
