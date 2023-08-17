//
//  DetailViewController.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Kingfisher

class MediaDetailViewController: UIViewController {

    enum MediaDetail: String, CaseIterable {
        case Overview
        case Cast
        case Crew
    }
    
    @IBOutlet var detailTableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var backPosterImageView: UIImageView!
    
    var result: Result!
    var castList: [Cast] = []
    var crewList: [Cast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TMDB_CreditsAPIManager.shared.callRequest(mediaID: result.id) { result in
            self.castList = result.cast
            self.crewList = result.crew
            print(self.crewList)
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

        switch section {
        case 0: return 1
        case 1: return castList.count
        case 2: return crewList.count
        default: return 0
        }
}
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return String(describing: MediaDetail.allCases[section])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let section = indexPath.section
        
        if section == 0 {
            connectOverviewCell()
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaOverViewTableViewCell.identifier, for: indexPath) as! MediaOverViewTableViewCell
            
            cell.configureCell(data: result)
            return cell
        } else if section == 1 {
            connectCastCell()
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailTableViewCell.identifier, for: indexPath) as! MediaDetailTableViewCell
            
            cell.configureCell(data: castList[row])
            return cell
        } else {
            connectCastCell()
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailTableViewCell.identifier, for: indexPath) as! MediaDetailTableViewCell
            
            cell.configureCell(data: crewList[row])
            return cell
        }
        
    }
    
}
