//
//  ProfileTableViewCell.swift
//  Media
//
//  Created by 선상혁 on 2023/08/29.
//

import UIKit
import SnapKit

class ProfileTableViewCell: UITableViewCell {
    
    let titleLabel = {
        let view = UILabel()
        view.textColor = .white
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    let dataLabel = {
        let view = UILabel()
        view.textColor = .gray
        view.font = .systemFont(ofSize: 13)
        return view
    }()
    
    let tableViewImage = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.tintColor = .white
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(dataLabel)
        contentView.addSubview(tableViewImage)
        contentView.backgroundColor = .black
    }
    
    func setConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leadingMargin.equalTo(contentView.snp.leading).offset(8)
        }
        dataLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leadingMargin.equalTo(contentView.snp.centerX).offset(-60)
        }
        tableViewImage.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.trailingMargin.equalTo(contentView.snp.trailing).offset(-8)
        }
    }
    
}
