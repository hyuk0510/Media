//
//  MediaCollectionViewCell.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Kingfisher

class MediaCollectionViewCell: UICollectionViewCell {

    @IBOutlet var firstRateLabel: UILabel!
    @IBOutlet var secondRateLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var overviewLabel: UILabel!
    
    @IBOutlet var mediaImageView: UIImageView!
    
    @IBOutlet var likeButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        designFirstRateLabel()
        designSecondRateLabel()
        designtitleLabel()
        designOverviewLabel()
        designLikeButton()
        mediaImageView.contentMode = .scaleAspectFit
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
        titleLabel.font = .systemFont(ofSize: 15)
    }
    
    func designOverviewLabel() {
        overviewLabel.font = .systemFont(ofSize: 13)
    }
    
    func designLikeButton() {
        likeButton.setTitle("", for: .normal)
        likeButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        likeButton.tintColor = .yellow
    }
    
    func configureCell(data: [Media], index: Int) {
        let url = URL(string: data[index].poster)
        
        titleLabel.text = data[index].title
        overviewLabel.text = data[index].overview
        secondRateLabel.text = String(format: "%.2f", data[index].rate)
        mediaImageView.kf.setImage(with: url)
    }
}
