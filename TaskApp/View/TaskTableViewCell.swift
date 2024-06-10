//
//  File.swift
//  TaskApp
//
//  Created by Nilgul Cakir on 2.06.2024.
//

import UIKit
import SnapKit

class TaskTableViewCell: UITableViewCell {

    private let colorCodeLabel = UILabel()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let colorView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
        contentView.backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(colorCodeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(colorView)

        colorCodeLabel.textColor = .black
        colorCodeLabel.font = UIFont.boldSystemFont(ofSize: 16)
        colorCodeLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(10)
        }
        
        titleLabel.textColor = .black
        titleLabel.font = UIFont.systemFont(ofSize: 14)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(colorCodeLabel.snp.bottom).offset(5)
            make.left.equalTo(colorCodeLabel)
            make.right.lessThanOrEqualTo(colorView.snp.left).offset(-10)
        }
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 12)
        descriptionLabel.textColor = .gray
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(colorCodeLabel)
            make.right.lessThanOrEqualTo(colorView.snp.left).offset(-10)
            make.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        colorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(20)
            make.height.equalTo(20)
        }
    }

    func configure(with task: Task) {
        colorCodeLabel.text = task.task
        titleLabel.text = task.title
        descriptionLabel.text = task.description
        colorView.backgroundColor = UIColor(hex: task.colorCode)
    }
}
