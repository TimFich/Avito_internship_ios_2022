//
//  MainHeaderView.swift
//  AvitoTask
//
//  Created by Тимур Миргалиев on 26.10.2022.
//

import UIKit
import SnapKit

private enum Constants {
    static let topAndLeftConstraints: Int = 20
    static let rightConstraintOfCountOfEmployeesLabel: Int = 20
}

final class MainHeaderView: UIView {

    // Properties
    private let companyName: String
    private let countOfEmployees: Int

    // UI
    private lazy var nameOfCompanyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.text = companyName
        return label
    }()

    private lazy var countOfEmployeesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.text = "Count of employees in this company = \(self.countOfEmployees)"
        return label
    }()

    // MARK: - Initialization

    init(companyName: String, countOfEmployees: Int) {
        self.countOfEmployees = countOfEmployees
        self.companyName = companyName
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private func configure() {
        self.backgroundColor = .systemBackground

        addSubview(nameOfCompanyLabel)
        nameOfCompanyLabel.snp.makeConstraints {
            $0.top.left.equalToSuperview().inset(Constants.topAndLeftConstraints)
            $0.bottom.equalToSuperview()
        }

        addSubview(countOfEmployeesLabel)
        countOfEmployeesLabel.snp.makeConstraints {
            $0.left.equalTo(nameOfCompanyLabel.snp.right).offset(Constants.topAndLeftConstraints)
            $0.right.equalToSuperview().inset(Constants.rightConstraintOfCountOfEmployeesLabel)
            $0.bottom.equalToSuperview()
        }
    }
}
