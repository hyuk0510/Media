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
    
    var sectionHeader: String {
        switch self {
        case .Overview, .Cast: return self.rawValue
        }
    }
}

class MediaDetailViewController: UIViewController {

    @IBOutlet var detailTableView: UITableView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var posterImageView: UIImageView!
    @IBOutlet var backPosterImageView: UIImageView!
    
    var media: Media?
    var actorList: [Actor] = []
    let sectionHeader = ["OverView", "Cast"]
    var setSection = MediaDetail.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TMDB_CreditsAPIManager.shared.callRequest(mediaID: media!.ID, tv: detailTableView) { result in self.actorList = result
        }
        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.rowHeight = 200
        
        connectCell()
        configureLeftBarButtonItem()
        title = "출연/제작"
        
        configureInfo(data: media!)
        designTitleLabel()
    }
    
    func designTitleLabel() {
//        titleLabel.textColor =
        titleLabel.font = .boldSystemFont(ofSize: 17)
    }
    
    func configureInfo(data: Media) {
        let posterURL = URL(string: data.poster)
        let backPosterURL = URL(string: data.backPoster)
        
        titleLabel.text = data.title
        posterImageView.kf.setImage(with: posterURL)
        backPosterImageView.kf.setImage(with: backPosterURL)
    }
    
    func connectCell() {
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return actorList.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return String(describing: MediaDetail.allCases[section])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailTableViewCell.identifier, for: indexPath) as! MediaDetailTableViewCell
        let row = indexPath.row
        
        cell.configureCell(data: actorList[row])
        
        return cell
    }
    
}
