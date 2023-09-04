//
//  DetailTableViewCell.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Kingfisher

class MediaDetailTableViewCell: BaseTableViewCell {
        
    let actorImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    let nameLabel = {
        let view = UILabel()
        view.textColor = .black
        view.font = .boldSystemFont(ofSize: 15)
        return view
    }()
    
    let characterLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .lightGray
        return view
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        actorImageView.image = nil
    }
    
    override func configureView() {
        [actorImageView, nameLabel, characterLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func setConstraints() {
        actorImageView.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
            make.width.equalTo(actorImageView.snp.height).multipliedBy(0.6)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(50)
            make.leading.equalTo(actorImageView.snp.trailing).offset(20)
        }
        characterLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(nameLabel.snp.leading)
        }
    }
    
    func configureCell(data: Cast) {
        let imageURL = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: imageURL + (data.profilePath ?? ""))
        
        nameLabel.text = data.name
        characterLabel.text = data.character ?? data.job
        actorImageView.kf.setImage(with: url)
    }
}
