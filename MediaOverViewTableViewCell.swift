//
//  MediaOverViewTableViewCell.swift
//  Media
//
//  Created by 선상혁 on 2023/08/13.
//

import UIKit

class MediaOverViewTableViewCell: BaseTableViewCell {
    
    let overviewTextView = {
        let view = UITextView()
        view.isEditable = false
        view.font = .systemFont(ofSize: 12)
        return view
    }()
    
    override func configureView() {
        contentView.addSubview(overviewTextView)
    }
    
    override func setConstraints() {
        overviewTextView.snp.makeConstraints { make in
            make.edges.equalTo(contentView).inset(20)
        }
    }
    
    func configureCell(overview: String) {
        overviewTextView.text = overview
    }
    
}
