//
//  FurnitureBaseVC.swift
//  AR Furniture
//
//  Created by Domagoj Kolaric on 22.12.2020..
//
import UIKit

class FurnitureBaseVC: UIViewController {
    
    let childContentViewController: UIViewController!
    var contentContainer: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.commonSetup()
    }
    
    init(childViewController: UIViewController) {
        self.childContentViewController = childViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonSetup() {
        let contentContainer = UIView()
        contentContainer.backgroundColor = UIColor.orange
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(contentContainer)
        
        contentContainer.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        contentContainer.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        contentContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        contentContainer.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor).isActive = true
        
        let heightConstraint = contentContainer.heightAnchor.constraint(equalToConstant: 200)
        heightConstraint.priority = UILayoutPriority(rawValue: 200)
        heightConstraint.isActive = true
        
        self.contentContainer = contentContainer
    }
    
    private func attachChildView() {
        self.addChild(self.childContentViewController)
        self.contentContainer.addSubview(self.childContentViewController.view)
        guard let childContentView = childContentViewController.view else { return }
        
        childContentView.translatesAutoresizingMaskIntoConstraints = false
        
        childContentView.topAnchor.constraint(equalTo: self.contentContainer.topAnchor, constant: 36).isActive = true
        childContentView.centerXAnchor.constraint(equalTo: self.contentContainer.centerXAnchor).isActive = true
        childContentView.widthAnchor.constraint(equalTo: self.contentContainer.widthAnchor, multiplier: 0.9).isActive = true
        childContentView.bottomAnchor.constraint(equalTo: self.contentContainer.bottomAnchor, constant: -20).isActive = true
        
        childContentView.backgroundColor = UIColor.white
        contentContainer.backgroundColor = UIColor.white
        
        self.childContentViewController.didMove(toParent: self)
    }
}
