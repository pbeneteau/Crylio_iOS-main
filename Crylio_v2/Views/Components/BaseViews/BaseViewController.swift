//
//  BaseViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 07/05/2021.
//

import UIKit



class BaseViewController: UIViewController {
    
    open var didMakeConstraints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initColors()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.setAnimationsEnabled(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        UIView.setAnimationsEnabled(false)
        
        super.viewDidDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    func initColors() {
        
        view.backgroundColor = AppColors.background.primary
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        initColors()
    }
    

    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if !didMakeConstraints {
            didMakeConstraints = true
            makeConstraints()
        }
    }
    
    open func makeConstraints() {
        
    }
    
}
