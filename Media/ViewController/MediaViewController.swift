//
//  ViewController.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit

class MediaViewController: UIViewController {

    @IBOutlet var mediaCollectionView: UICollectionView!
    
    var mediaList: [Media] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        
        connectCell()
        designLeftButton()
        cellLayout()
        TMDBAPIManager.shared.callRequest(type: .all, time: .day, cv: mediaCollectionView) { result in
            self.mediaList = result
        }
    }
    
    func connectCell() {
        let nib = UINib(nibName: MediaCollectionViewCell.identifier, bundle: nil)
        
        mediaCollectionView.register(nib, forCellWithReuseIdentifier: MediaCollectionViewCell.identifier)
    }
    
    func designLeftButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(checkMyList))
    }
    
    @objc func checkMyList() {
        let vc = storyboard?.instantiateViewController(identifier: MyListViewController.identifier) as! MyListViewController
        let nav = UINavigationController(rootViewController: vc)
        
        vc.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToMain))
        
        nav.modalPresentationStyle = .fullScreen

        present(nav, animated: true)
    }
    
    @objc func backToMain() {
        dismiss(animated: true)
    }

    func cellLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing = CGFloat(10)
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: 300)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        mediaCollectionView.collectionViewLayout = layout
    }
}

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mediaList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as! MediaCollectionViewCell
        let row = indexPath.row
        
        cell.configureCell(data: self.mediaList, index: row)
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: MediaDetailViewController.identifier) as! MediaDetailViewController
        let nav = UINavigationController(rootViewController: vc)
        let row = indexPath.row
        
        vc.media = mediaList[row]
        
        nav.modalPresentationStyle = .fullScreen

        present(nav, animated: true)
    }
    
}
