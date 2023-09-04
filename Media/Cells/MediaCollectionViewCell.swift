//
//  MediaCollectionViewCell.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Kingfisher

class MediaCollectionViewCell: BaseCollectionViewCell {
    
    let dateLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        view.textColor = .lightGray
        return view
    }()
    
    let genreLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        return view
    }()
    
    let backView = {
        let view = UIView()
        view.setShadow()
        return view
    }()
    
    let firstRateLabel = {
        let view = UILabel()
        view.backgroundColor = .systemPurple
        view.textColor = .white
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 12)
        view.text = "평점"
        return view
    }()
    
    let secondRateLabel = {
        let view = UILabel()
        view.backgroundColor = .white
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 12)
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 15)
        return view
    }()
    
    let originalTitleLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 12)
        return view
    }()
    
    let overviewLabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 13)
        view.textColor = .lightGray
        view.numberOfLines = 3
        return view
    }()
    
    let mediaImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        return view
    }()
    
    let likeButton = {
        let view = UIButton()
        view.setTitle("", for: .normal)
        view.setImage(UIImage(systemName: "star.fill"), for: .normal)
        view.tintColor = .yellow
        return view
    }()
    
    override func configureView() {
        let subViewList = [dateLabel, genreLabel, backView, firstRateLabel, secondRateLabel, titleLabel, originalTitleLabel, overviewLabel, likeButton]
        for item in subViewList {
            contentView.addSubview(item)
        }
        backView.addSubview(mediaImageView)
        contentView.layer.cornerRadius = 15
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        
    }
    
    override func setConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(20)
            make.leading.equalTo(contentView).offset(20)
            make.height.equalTo(18)
        }
        genreLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalTo(dateLabel.snp.leading)
            make.height.equalTo(18)
        }
        backView.snp.makeConstraints { make in
            make.top.equalTo(genreLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(contentView).inset(20)
            make.bottom.equalTo(contentView).offset(-20)
        }
        mediaImageView.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top)
            make.horizontalEdges.equalTo(backView.snp.horizontalEdges)
            make.height.equalTo(backView.snp.height).multipliedBy(0.6)
        }
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(backView.snp.top).offset(10)
            make.trailing.equalTo(backView.snp.trailing).offset(-10)
        }
        firstRateLabel.snp.makeConstraints { make in
            make.leading.equalTo(backView.snp.leading).offset(10)
            make.bottom.equalTo(mediaImageView.snp.bottom).offset(-20)
        }
        secondRateLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstRateLabel.snp.trailing)
            make.bottom.equalTo(firstRateLabel.snp.bottom)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(firstRateLabel.snp.leading)
            make.top.equalTo(mediaImageView.snp.bottom).offset(20)
        }
        originalTitleLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(20)
            make.trailing.equalTo(backView.snp.trailing).offset(20)
            make.centerY.equalTo(titleLabel.snp.centerY)
        }
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(backView.snp.horizontalEdges).inset(20)
        }
        
    }
    
    func setMediaGenre(data: [Result], genreList: [GenreElement]) -> [String] {
        var result: [String] = []
        
        for item in data {
            for genre in genreList {
                if item.genreIDS[0] == genre.id {
                    result.append(genre.name)
                }
            }
        }
        
        return result
    }
    
    func setSimilarGenre(data: [SimilarResult], genreList: [GenreElement]) -> [String] {
        var result: [String] = []
        
        for item in data {
            for genre in genreList {
                if !item.genreIDS.isEmpty {
                    if let genreID = item.genreIDS[0], genreID == genre.id {
                        result.append(genre.name)
                    }
                }
            }
        }
        
        return result
    }
    
    func configureMediaCell(data: [Result], genre: [GenreElement], index: Int) {
        let imageURL = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: imageURL + data[index].posterPath)
        let genreList = setMediaGenre(data: data, genreList: genre)

        dateLabel.text = data[index].releaseDate
        genreLabel.text = "#" + genreList[index]
        titleLabel.text = data[index].title
        originalTitleLabel.text = data[index].originalTitle
        overviewLabel.text = data[index].overview
        secondRateLabel.text = String(format: "%.2f", data[index].voteAverage)
        mediaImageView.kf.setImage(with: url)
    }
    
    func configureSimilarCell(data: [SimilarResult], genre: [GenreElement], index: Int) {
        let imageURL = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: imageURL + (data[index].posterPath ?? ""))
        let genreList = setSimilarGenre(data: data, genreList: genre)

        dateLabel.text = data[index].releaseDate
        genreLabel.text = "#" + genreList[index]
        titleLabel.text = data[index].title
        originalTitleLabel.text = data[index].originalTitle
        overviewLabel.text = data[index].overview
        secondRateLabel.text = String(format: "%.2f", data[index].voteAverage)
        mediaImageView.kf.setImage(with: url)
    }
}

extension UIView {
    func setShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .zero
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.5
        clipsToBounds = false
    }
}
