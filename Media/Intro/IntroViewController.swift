//
//  IntroViewController.swift
//  Media
//
//  Created by 선상혁 on 2023/08/27.
//

import UIKit
import SnapKit

class FirstIntroViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .cyan
    }
}

class SecondIntroViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBlue
    }
}

class ThirdIntroViewController: UIViewController {

    let startButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = .white
        config.title = "시작"
        config.titleAlignment = .center
        config.baseForegroundColor = .red
        config.cornerStyle = .capsule
        button.configuration = config
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .darkGray
        view.addSubview(startButton)
        setConstraints()
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }
    
    func setConstraints() {
        startButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(20)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(24)
        }
    }
    
    @objc func startButtonPressed() {
        UserDefaults.standard.set(true, forKey: "isNotFirstLaunched")
        let vc = MediaViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }

}


class IntroViewController: UIPageViewController {

    var introViewControllerList: [UIViewController] = []
    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addViewController()
        configurePageViewController()
    }
    
    func addViewController() {
        
        introViewControllerList.append(contentsOf: [FirstIntroViewController(), SecondIntroViewController(), ThirdIntroViewController()])
    }
    
    func configurePageViewController() {
        delegate = self
        dataSource = self
        
        guard let first = introViewControllerList.first else { return }
        setViewControllers([first], direction: .forward, animated: true)
    }
}

extension IntroViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = introViewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        return previousIndex < 0 ? nil : introViewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = introViewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        return nextIndex >= introViewControllerList.count ? nil : introViewControllerList[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return introViewControllerList.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let first = viewControllers?.first, let index = introViewControllerList.firstIndex(of: first) else { return 0 }
        return index
    }
}
