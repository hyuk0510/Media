//
//  MediaView.swift
//  Media
//
//  Created by 선상혁 on 2023/09/01.
//

import UIKit

class MediaView: BaseView {
    
    lazy var mediaCollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        view.register(MediaCollectionViewCell.self, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
        return view
    }()
    
    
    override func configureView() {
        addSubview(mediaCollectionView)
        backgroundColor = .white
    }
    
    override func setConstraints() {
        mediaCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing = CGFloat(10)
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: 400)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        return layout
    }
}
