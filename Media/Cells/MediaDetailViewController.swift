//
//  DetailViewController.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Kingfisher

enum MediaDetail: String, CaseIterable {
    case Overview
    case Cast
    
    var sectionNum: Int {
        switch self {
        case .Overview: return 0
        case .Cast: return 1
        }
    }
}

class MediaDetailViewController: UIViewController {

    @IBOutlet var detailTableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var backPosterImageView: UIImageView!
    
    var result: Result!
    var actorResult: [Cast] = []
    var sectionNum = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TMDB_CreditsAPIManager.shared.callRequest(mediaID: result.id) { result in self.actorResult = result
            self.detailTableView.reloadData()
        }
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.rowHeight = UIScreen.main.bounds.height / 5
        
        configureLeftBarButtonItem()
        title = "출연/제작"
        
        configureInfo(data: result)
        designTitleLabel()
    }
    
    func designTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .white
    }
    
    func configureInfo(data: Result) {
        let imageURL = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: imageURL + data.posterPath)
        let backPosterURL = URL(string: imageURL + data.backdropPath)
        
        titleLabel.text = data.title
        posterImageView.kf.setImage(with: posterURL)
        backPosterImageView.kf.setImage(with: backPosterURL)
    }
    
    func connectOverviewCell() {
        let nib = UINib(nibName: MediaOverViewTableViewCell.identifier, bundle: nil)
        
        detailTableView.register(nib, forCellReuseIdentifier: MediaOverViewTableViewCell.identifier)
    }
    
    func connectCastCell() {
        let nib = UINib(nibName: MediaDetailTableViewCell.identifier, bundle: nil)
        
        detailTableView.register(nib, forCellReuseIdentifier: MediaDetailTableViewCell.identifier)
    }

    func configureLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func closeButtonPressed() {
        dismiss(animated: true)
    }
}

extension MediaDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return MediaDetail.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        sectionNum = section
        return section == 0 ? 1: actorResult.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return String(describing: MediaDetail.allCases[section])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if MediaDetail.allCases[indexPath.section].sectionNum == 0 {
            connectOverviewCell()
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaOverViewTableViewCell.identifier, for: indexPath) as! MediaOverViewTableViewCell
            
            cell.configureCell(data: result)
            return cell
        } else {
            connectCastCell()
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailTableViewCell.identifier, for: indexPath) as! MediaDetailTableViewCell
            
            cell.configureCell(data: actorResult[row])
            return cell
        }
        
    }
    
}
