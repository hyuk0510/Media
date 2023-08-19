//
//  MediaOverViewTableViewCell.swift
//  Media
//
//  Created by 선상혁 on 2023/08/13.
//

import UIKit

class MediaOverViewTableViewCell: UITableViewCell {

    @IBOutlet var overviewTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        designOverviewTextView()
    }

    func designOverviewTextView() {
        overviewTextView.isEditable = false
        overviewTextView.font = .systemFont(ofSize: 12)
    }
    
    func configureCell(overview: String) {
        overviewTextView.text = overview
    }
    
}
