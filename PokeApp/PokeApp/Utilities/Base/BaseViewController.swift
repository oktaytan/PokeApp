//
//  BaseViewController.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import UIKit

class BaseViewController: UIViewController {
    
    weak var coordinatorDelegate: CommonControllerToCoordinatorDelegate?
    
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        return loadingView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupView() {
        
    }
    
    // Ekranda üst uyarı barı oluşturur.
    func showToastMessage(title: String?, message: String?, type: ToastMessageType) {
        DispatchQueue.main.async {
            ToastMessage.shared.showOnWindow(title: title, message: message ?? "", type: type)
        }
    }
    
    // Ekranda fullpage loading animasyonu gösterir.
    func showLoading() {
        guard !view.subviews.contains(loadingView) else {
            loadingView.start()
            return
        }
        
        loadingView.isHidden = false
        view.addSubview(loadingView)
        loadingView.anchorToSuperview()
        loadingView.start()
    }
    
    // Ekrandaki loading animasyonunu kaldırır.
    func hideLoading() {
        guard view.subviews.contains(loadingView) else {
            return
        }
        loadingView.removeFromSuperview()
        loadingView.isHidden = true
        loadingView.stop()
    }
    
    // Navbar'a varsa action ile butonn ekler.
    func setupNavBar(title: String?, leftIcon: String?, rightIcon: String?, leftItemAction: Selector? = nil, rightItemAction: Selector? = nil) {
        if let leftIcon = leftIcon {
            let leftItem = UIBarButtonItem(image: UIImage(named: leftIcon)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: leftItemAction)
            self.navigationItem.leftBarButtonItem = leftItem
        }
        
        if let rightIcon = rightIcon {
            let rightItem = UIBarButtonItem(image: UIImage(named: rightIcon)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: rightItemAction)
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
        self.title = title
    }
    
    // Önceki controller'a geri döner.
    @objc func goBack() {
        if self.navigationController?.viewControllers.count == 1 {
            self.dismiss(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
