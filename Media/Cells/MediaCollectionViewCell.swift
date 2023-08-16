//
//  MediaCollectionViewCell.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Kingfisher

class MediaCollectionViewCell: UICollectionViewCell {

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var genreLabel: UILabel!
    
    @IBOutlet var backView: UIView!
    
    @IBOutlet var firstRateLabel: UILabel!
    @IBOutlet var secondRateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    @IBOutlet var mediaImageView: UIImageView!
    
    @IBOutlet var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        designDateLabel()
        designGenreLabel()
        setShadow()
        setCornerRadius()
        designFirstRateLabel()
        designSecondRateLabel()
        designtitleLabel()
        designOverviewLabel()
        designLikeButton()
        mediaImageView.contentMode = .scaleToFill
    }
    
    func designDateLabel() {
        dateLabel.font = .systemFont(ofSize: 12)
        dateLabel.textColor = .lightGray
    }
    
    func designGenreLabel() {
        genreLabel.font = .boldSystemFont(ofSize: 15)
    }

    func setShadow() {
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = .zero
        backView.layer.shadowRadius = 10
        backView.layer.shadowOpacity = 0.5
        backView.clipsToBounds = false
    }
    
    func setCornerRadius() {
        backView.layer.cornerRadius = 10
        mediaImageView.layer.cornerRadius = 10
        mediaImageView.layer.maskedCorners = [.layerMaxXMinYCorner,
            .layerMinXMinYCorner]
    }
    
    func designFirstRateLabel() {
        firstRateLabel.backgroundColor = .systemPurple
        firstRateLabel.textColor = .white
        firstRateLabel.textAlignment = .center
        firstRateLabel.font = .systemFont(ofSize: 12)
        firstRateLabel.text = "평점"
    }
    
    func designSecondRateLabel() {
        secondRateLabel.backgroundColor = .white
        secondRateLabel.textAlignment = .center
        secondRateLabel.font = .systemFont(ofSize: 12)
    }
    
    func designtitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 15)
    }
    
    func designOverviewLabel() {
        overviewLabel.font = .systemFont(ofSize: 13)
        overviewLabel.textColor = .lightGray
    }
    
    func designLikeButton() {
        likeButton.setTitle("", for: .normal)
        likeButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        likeButton.tintColor = .yellow
    }
    
    func setGenre(data: [Result], genreList: [GenreElement]) -> [String] {
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
    
    func configureCell(data: [Result], genre: [GenreElement], index: Int) {
        let imageURL = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: imageURL + data[index].posterPath)
        let genreList = setGenre(data: data, genreList: genre)

        dateLabel.text = data[index].releaseDate
        genreLabel.text = "#" + genreList[index]
        titleLabel.text = data[index].title
        overviewLabel.text = data[index].overview
        secondRateLabel.text = String(format: "%.2f", data[index].voteAverage)
        mediaImageView.kf.setImage(with: url)
    }
}
