//
//  SettingProfileViewController.swift
//  Media
//
//  Created by 선상혁 on 2023/08/29.
//

import UIKit
import SnapKit

class SettingProfileViewController: BaseViewController {
    
    var viewTitle = ""
    
    let textField = {
        let view = UITextField()
        view.backgroundColor = .gray
        view.textColor = .white
        view.layer.cornerRadius = 5
        return view
    }()
    
    var completionHandler: ((String, UIColor) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureView() {
        title = viewTitle
        view.addSubview(textField)
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .plain, target: self, action: #selector(okButtonPressed))
        
        textField.placeholder = viewTitle + " 추가"
    }
    
    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func okButtonPressed() {
        NotificationCenter.default.post(name: Notification.Name("Data"), object: nil, userInfo: ["data": textField.text!])
        completionHandler?(textField.text!, .white)
        navigationController?.popViewController(animated: true)
    }
    
    override func setConstraints() {
        textField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.equalTo(view)
            make.height.equalTo(50)
        }
    }
}
