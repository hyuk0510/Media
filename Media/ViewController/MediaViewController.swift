//
//  ViewController.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit

class MediaViewController: UIViewController {

    @IBOutlet var mediaCollectionView: UICollectionView!
    
    @IBOutlet var searchButton: UIBarButtonItem!
    
    let searchBar = UISearchBar()
    var mediaResult: [Result] = []
    var genreResult: [GenreElement] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mediaCollectionView.delegate = self
        mediaCollectionView.dataSource = self
        navigationItem.titleView = searchBar
        
        connectCell()
        designLeftButton()
        designSearchButton()
        cellLayout()
        
        TMDBAPIManager.shared.callRequest(type: .movie, time: .day) { result, genre in
            self.mediaResult = result
            self.genreResult = genre
            self.mediaCollectionView.reloadData()
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
        
        vc.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToMain))
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backToMain() {
        navigationController?.popViewController(animated: true)
    }
    
    func designSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(checkMyList))
    }

    func cellLayout() {
        let layout = UICollectionViewFlowLayout()
        let spacing = CGFloat(10)
        let width = UIScreen.main.bounds.width - (spacing * 2)
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width, height: 400)
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        mediaCollectionView.collectionViewLayout = layout
    }
}

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return mediaResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as! MediaCollectionViewCell
        let row = indexPath.row
        
        cell.configureCell(data: self.mediaResult, genre: self.genreResult, index: row)
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: MediaDetailViewController.identifier) as! MediaDetailViewController
        let nav = UINavigationController(rootViewController: vc)
        let row = indexPath.row
        
        vc.result = mediaResult[row]
        
        nav.modalPresentationStyle = .fullScreen

        present(nav, animated: true)
    }
    
}
