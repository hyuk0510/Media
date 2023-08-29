//
//  ProfileViewController.swift
//  Media
//
//  Created by 선상혁 on 2023/08/29.
//

import UIKit
import SnapKit

class ProfileViewController: BaseViewController {
    
    let imageViewSize = CGFloat(80)
    let picker = UIImagePickerController()
    var isProfile = true
    let profileTitle: [[String]] = [["이름", "사용자 이름", "성별 대명사", "소개"], ["링크", "성별"]]
    let settingList: [String] = ["프로페셔널 계정으로 전환", "개인정보 설정"]
    lazy var titleList = profileTitle.flatMap{$0}
    
    let profileImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "person")
        view.contentMode = .scaleToFill
        view.tintColor = .white
        return view
    }()
    
    let avatarImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "star")
        view.contentMode = .scaleToFill
        view.tintColor = .white
        return view
    }()
    
    let changeImageViewButton = {
        let view = UIButton()
        view.setTitle("사진 또는 아바타 수정", for: .normal)
        view.setTitleColor(UIColor.systemBlue, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 12)
        return view
    }()
    
    lazy var profileTableView = {
        let view = UITableView()
        view.rowHeight = UITableView.automaticDimension
        view.delegate = self
        view.dataSource = self
        view.register(ProfileTableViewCell.self, forCellReuseIdentifier: ProfileTableViewCell.identifier)
        view.backgroundColor = .clear
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(okButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .white
    }
    
    @objc func cancelButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func okButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    override func configureView() {
        title = "프로필 편집"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        view.addSubview(profileImageView)
        view.addSubview(avatarImageView)
        view.addSubview(changeImageViewButton)
        view.addSubview(profileTableView)
        
        changeImageViewButton.addTarget(self, action: #selector(changeImageViewButtonPressed), for: .touchUpInside)
    }
    
    @objc func changeImageViewButtonPressed() {
        showImageAlert()
    }
    
    override func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view).offset(-50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.size.equalTo(imageViewSize)
            setImageViewCorner(imageView: profileImageView, size: imageViewSize)
        }
        avatarImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view).offset(50)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.size.equalTo(imageViewSize)
            setImageViewCorner(imageView: avatarImageView, size: imageViewSize)
        }
        changeImageViewButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        profileTableView.snp.makeConstraints { make in
            make.top.equalTo(changeImageViewButton.snp.bottom).offset(20)
            make.height.equalTo(view).multipliedBy(0.5)
            make.horizontalEdges.equalTo(view)
        }
    }
    
    func setImageViewCorner(imageView: UIImageView, size: CGFloat) {
        imageView.layer.cornerRadius = CGFloat(size / 2)
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.clipsToBounds = true
    }
    
    func showImageAlert() {
        let alert = UIAlertController(title: "이미지 수정", message: "", preferredStyle: .actionSheet)
        let profile = UIAlertAction(title: "프로필 이미지 수정", style: .default) { _ in
            self.isProfile = true
            self.showPhotoLibrary()
        }
        let avatar = UIAlertAction(title: "아바타 이미지 수정", style: .default) { _ in
            self.isProfile = false
            self.showPhotoLibrary()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(profile)
        alert.addAction(avatar)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
    
    func showPhotoLibrary() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            return
        }
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
                        
        present(picker, animated: true)
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if self.isProfile {
                self.profileImageView.image = image
            } else {
                self.avatarImageView.image = image
            }

            dismiss(animated: true)
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? titleList.count : settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier) as! ProfileTableViewCell
        
        if indexPath.section == 0 {
            cell.dataLabel.text = titleList[indexPath.row]
            cell.titleLabel.text = titleList[indexPath.row]
            if indexPath.row >= profileTitle[0].count {
                cell.tableViewImage.image = UIImage(systemName: "chevron.right")
            }
            
        } else {
            cell.titleLabel.textColor = .systemBlue
            cell.titleLabel.text = settingList[indexPath.row]
        }
                
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! ProfileTableViewCell
            let vc = SettingProfileViewController()
            vc.viewTitle = titleList[indexPath.row]
            vc.cell = cell
            vc.completionHandler = { data in
                cell.dataLabel.text = data
                cell.dataLabel.textColor = .white
            }
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
}
