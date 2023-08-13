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
        
        nameLabel.font = .boldSystemFont(ofSize: 15)
        characterLabel.font = .systemFont(ofSize: 13)
        characterLabel.textColor = .lightGray
    }
    
    func configureCell(data: Actor) {
        let url = URL(string: data.actorImage)
        
        nameLabel.text = data.name
        characterLabel.text = data.character
        actorImageView.kf.setImage(with: url)
    }
}
