//
//  MediaDetailView.swift
//  Media
//
//  Created by 선상혁 on 2023/09/03.
//

import UIKit

class MediaDetailView: BaseView {
    
    let backPosterImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    let titleLabel = {
        let view = UILabel()
        return view
    }()
    
    let posterImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    let detailTableView = {
        let view = UITableView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureView() {
        [backPosterImageView, titleLabel, posterImageView, detailTableView].forEach {
            addSubview($0)
        }
    }
    
    override func setConstraints() {
        backPosterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(self.safeAreaLayoutGuide)
            make.height.equalTo(UIScreen.main.bounds.height).multipliedBy(0.25)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(self.safeAreaLayoutGuide).offset(20)
        }
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.height.equalTo(backPosterImageView.snp.height).multipliedBy(0.7)
            make.width.equalTo(backPosterImageView.snp.height).multipliedBy(0.7).multipliedBy(0.6)
        }
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(backPosterImageView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
