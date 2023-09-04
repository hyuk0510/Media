//
//  DetailViewController.swift
//  Media
//
//  Created by 선상혁 on 2023/08/11.
//

import UIKit
import Kingfisher

class MediaDetailViewController: BaseViewController {

    enum MediaDetail: String, CaseIterable {
        case Overview
        case Cast
        case Crew
    }
    
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
    
    lazy var detailTableView = {
        let view = UITableView()
        view.delegate = self
        view.dataSource = self
        view.register(MediaOverViewTableViewCell.self, forCellReuseIdentifier: MediaOverViewTableViewCell.identifier)
        view.register(MediaDetailTableViewCell.self, forCellReuseIdentifier: MediaDetailTableViewCell.identifier)
        return view
    }()
    
    var seg = 0
    var id = 0
    var result: Result!
    var similarResult: SimilarResult!
    var castList: [Cast] = []
    var crewList: [Cast] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
                        
        detailTableView.delegate = self
        detailTableView.dataSource = self
        detailTableView.rowHeight = UIScreen.main.bounds.height / 5
        callRequest(mediaID: id)
        
        configureInfo()
        configureLeftBarButtonItem()
        title = "출연/제작"
        
        designTitleLabel()
    }
    
    override func configureView() {
        [backPosterImageView, titleLabel, posterImageView, detailTableView].forEach {
            view.addSubview($0)
        }
        view.backgroundColor = .white
    }
    
    override func setConstraints() {
        backPosterImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(0.25)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.height.equalTo(backPosterImageView.snp.height).multipliedBy(0.7)
            make.width.equalTo(backPosterImageView.snp.height).multipliedBy(0.7).multipliedBy(0.6)
        }
        detailTableView.snp.makeConstraints { make in
            make.top.equalTo(backPosterImageView.snp.bottom)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func designTitleLabel() {
        titleLabel.font = .boldSystemFont(ofSize: 17)
        titleLabel.textColor = .white
    }
    
    func configureInfo() {
        seg == 0 ? configureMediaInfo(data: result) : configureSimilarInfo(data: similarResult)
    }
    
    func configureMediaInfo(data: Result) {
        let imageURL = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: imageURL + data.posterPath)
        let backPosterURL = URL(string: imageURL + data.backdropPath)
        
        titleLabel.text = data.title
        posterImageView.kf.setImage(with: posterURL)
        backPosterImageView.kf.setImage(with: backPosterURL)
    }
    
    func configureSimilarInfo(data: SimilarResult) {
        let imageURL = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: imageURL + (data.posterPath ?? ""))
        let backPosterURL = URL(string: imageURL + (data.backdropPath ?? ""))
        
        titleLabel.text = data.title
        posterImageView.kf.setImage(with: posterURL)
        backPosterImageView.kf.setImage(with: backPosterURL)
    }
   
    func configureLeftBarButtonItem() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(closeButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    @objc func closeButtonPressed() {
        dismiss(animated: true)
    }
    
    func callRequest(mediaID: Int) {
        TMDBAPIManager.shared.callCredit(mediaID: mediaID) { result in
            self.castList = result.cast
            self.crewList = result.crew
            DispatchQueue.main.async {
                self.detailTableView.reloadData()
            }
        }
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
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaOverViewTableViewCell.identifier, for: indexPath) as! MediaOverViewTableViewCell
            
            seg == 0 ? cell.configureCell(overview: result.overview) : cell.configureCell(overview: similarResult.overview)
            return cell
        } else if section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailTableViewCell.identifier, for: indexPath) as! MediaDetailTableViewCell
            
            cell.configureCell(data: castList[row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: MediaDetailTableViewCell.identifier, for: indexPath) as! MediaDetailTableViewCell
            
            cell.configureCell(data: crewList[row])
            return cell
        }
        
    }
    
}
