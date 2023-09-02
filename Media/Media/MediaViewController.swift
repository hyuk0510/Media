//
//  ViewController.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit

class MediaViewController: BaseViewController {
    
    var mediaResult: [Result] = []
    var genreResult: [GenreElement] = []
    var similarResult: [SimilarResult] = []
    let segment = UISegmentedControl(items: ["Media", "Similar"])
    var movieID = 0

    let mainView = MediaView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        callRequest()
        mainView.mediaCollectionView.delegate = self
        mainView.mediaCollectionView.dataSource = self

        configureSegment()
        
        designLeftButton()
        designSearchButton()
        
    }
    
    func callRequest() {
        let group = DispatchGroup()
        
        group.enter()
        TMDBAPIManager.shared.callRequest(type: .movie, time: .day) { result, genre in
            self.mediaResult.append(contentsOf: result)
            self.genreResult.append(contentsOf: genre)
            self.movieID = result[0].id
            
            TMDBAPIManager.shared.callSimilar(movieID: self.movieID) { similar in
                self.similarResult.append(contentsOf: similar)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            self.mainView.mediaCollectionView.reloadData()
        }
    }
    
    func designLeftButton() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: #selector(checkMyList))
    }
    
    @objc func checkMyList() {
        let vc = MyListViewController()
        
        vc.navigationItem.leftBarButtonItem =  UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backToMain))
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func backToMain() {
        navigationController?.popViewController(animated: true)
    }
    
    func designSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person"), style: .plain, target: self, action: #selector(setProfile))
    }

    @objc func setProfile() {
        let vc = ProfileViewController()
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func configureSegment() {
        navigationItem.titleView = segment
        segment.selectedSegmentIndex = 0

        segment.addTarget(self, action: #selector(changeSegmentValue(segment:)), for: .valueChanged)
    }
    
    @objc func changeSegmentValue(segment: UISegmentedControl) {
        
        mainView.mediaCollectionView.reloadData()
    }
    
}

extension MediaViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                
        return segment.selectedSegmentIndex == 0 ? mediaResult.count : similarResult.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.identifier, for: indexPath) as? MediaCollectionViewCell else {
            return UICollectionViewCell()
        }
        let row = indexPath.row
        
        segment.selectedSegmentIndex == 0 ? cell.configureMediaCell(data: self.mediaResult, genre: self.genreResult, index: row) : cell.configureSimilarCell(data: self.similarResult, genre: self.genreResult, index: row)
                
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: MediaDetailViewController.identifier) as! MediaDetailViewController
        let nav = UINavigationController(rootViewController: vc)
        let row = indexPath.row
        var id = 0
        if segment.selectedSegmentIndex == 0 {
            id = mediaResult[row].id
            vc.result = mediaResult[row]
            self.movieID = id
        } else {
            id = similarResult[row].id
            vc.seg = 1
            vc.similarResult = similarResult[row]
        }
        
        vc.id = id
        
        nav.modalPresentationStyle = .fullScreen

        present(nav, animated: true)
    }
    
}
