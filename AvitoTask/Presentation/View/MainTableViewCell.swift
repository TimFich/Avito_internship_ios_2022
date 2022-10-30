//
//  MainTableViewCell.swift
//  AvitoTask
//
//  Created by Тимур Миргалиев on 26.10.2022.
//

import UIKit
import SnapKit

protocol IMainTableViewCell: AnyObject {
    func configure(employee: Employee)
}

private enum Constants {
    static let allLabelsTopConstreint: Int = 16
    static let allLabelsSideConstraints: Int = 24
    static let skillsLabelBottomConstaint: Int = 16
}

final class MainTableViewCell: UITableViewCell, IMainTableViewCell {

    // UI
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()

    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        return label
    }()

    private lazy var skillsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        return label
    }()

    func configure(employee: Employee) {
        backgroundColor = .systemBackground
        setUpUI()
        
        nameLabel.text = employee.name
        numberLabel.text = employee.phoneNumber
        skillsLabel.text = employee.skills.joined(separator: ", ")
    }

    // MARK: - Private

    private func setUpUI() {
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(Constants.allLabelsTopConstreint)
            $0.left.right.equalToSuperview().inset(Constants.allLabelsSideConstraints)
        }

        addSubview(numberLabel)
        numberLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(Constants.allLabelsTopConstreint)
            $0.right.left.equalToSuperview().inset(Constants.allLabelsSideConstraints)
        }

        addSubview(skillsLabel)
        skillsLabel.snp.makeConstraints {
            $0.top.equalTo(numberLabel.snp.bottom).offset(Constants.allLabelsTopConstreint)
            $0.left.right.equalToSuperview().inset(Constants.allLabelsSideConstraints)
            $0.bottom.equalToSuperview().inset(Constants.skillsLabelBottomConstaint)
        }
    }
}
