//
//  DetailTableViewCell.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Kingfisher

class MediaDetailTableViewCell: UITableViewCell {
        
    @IBOutlet var actorImageView: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var characterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        designLabel()
        designImageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        actorImageView.image = nil
    }
    
    func designLabel() {
        nameLabel.font = .boldSystemFont(ofSize: 15)
        characterLabel.font = .systemFont(ofSize: 13)
        characterLabel.textColor = .lightGray
    }
    
    func designImageView() {
        actorImageView.layer.masksToBounds = true
        actorImageView.layer.cornerRadius = 10
    }
    
    func configureCell(data: Cast) {
        let imageURL = "https://image.tmdb.org/t/p/w500"
        let url = URL(string: imageURL + (data.profilePath ?? ""))
        
        nameLabel.text = data.name
        characterLabel.text = data.character
        actorImageView.kf.setImage(with: url)
    }
}
