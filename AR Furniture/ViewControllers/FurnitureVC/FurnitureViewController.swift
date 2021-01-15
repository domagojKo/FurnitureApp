//
//  FurnitureViewController.swift
//  AR Furniture
//
//  Created by Domagoj Kolaric on 22.12.2020..
//

import UIKit

protocol FurnitureCellDelegate: class {
    func didSelectCell(furnitureDae: String, furnitureModelName: String)
}

enum FurnitureType {
    case chair, table, lamp
    
    var titleOfCollection: String {
        switch self {
        case .chair:
            return "Chairs"
        case .table:
            return "Tables"
        default:
            return "Lamps"
        }
    }
}

class FurnitureViewController: UIViewController {
    
    weak var delegate: FurnitureCellDelegate?
    
    var typeOfFurniture: FurnitureType? {
        didSet {
            self.titleLabel.text = typeOfFurniture?.titleOfCollection
            
            switch typeOfFurniture {
            case .chair:
                furnitureModels = Chair.chairModels
            case .table:
                furnitureModels = Chair.tableModels
            default:
                furnitureModels = Chair.lampModels
            }
        }
    }

    lazy var backdropView: UIView = {
        let bdView = UIView(frame: self.view.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bdView
    }()
    
    lazy var furnitureCollectionView: UICollectionView = {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(FurnitureCell.self, forCellWithReuseIdentifier: "MyCell")
        return cv
    }()

    let menuView = UIView()
    let menuHeight = UIScreen.main.bounds.height / 5 * 4
    var isPresenting = false
    
    let titleLabel = UILabel()
    
    var furnitureModels = [Furniture]()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupTitleView()
        setupCollectionView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(FurnitureViewController.handleTap(_:)))
        backdropView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillLayoutSubviews() {
        menuView.roundCorners(corners: [.topLeft, .topRight], radius: 20)
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupView() {
        view.backgroundColor = .clear
        view.addSubview(backdropView)
        view.addSubview(menuView)
        
        menuView.backgroundColor = UIColor.white
        menuView.translatesAutoresizingMaskIntoConstraints = false
        menuView.heightAnchor.constraint(equalToConstant: menuHeight).isActive = true
        menuView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        menuView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        menuView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
    }
    
    private func setupCollectionView() {
        self.menuView.addSubview(furnitureCollectionView)
        furnitureCollectionView.backgroundColor = .clear
        
        furnitureCollectionView.topAnchor.constraint(equalTo: self.menuView.topAnchor, constant: 80).isActive = true
        furnitureCollectionView.leadingAnchor.constraint(equalTo: self.menuView.leadingAnchor, constant: 20).isActive = true
        furnitureCollectionView.trailingAnchor.constraint(equalTo: self.menuView.trailingAnchor, constant: -20).isActive = true
        furnitureCollectionView.bottomAnchor.constraint(equalTo: self.menuView.bottomAnchor, constant: -20).isActive = true
        
        furnitureCollectionView.delegate = self
        furnitureCollectionView.dataSource = self
    }
    
    private func setupTitleView() {
        let lineView = UIView()
        self.menuView.addSubview(titleLabel)
        self.menuView.addSubview(lineView)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.menuView.topAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.menuView.leadingAnchor, constant: 20).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.menuView.trailingAnchor, constant: -20).isActive = true
        
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Roboto-Regular", size: 19)
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.topAnchor.constraint(equalTo: self.menuView.topAnchor, constant: 50).isActive = true
        lineView.leadingAnchor.constraint(equalTo: self.menuView.leadingAnchor).isActive = true
        lineView.trailingAnchor.constraint(equalTo: self.menuView.trailingAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        lineView.backgroundColor = UIColor.lightGray
    }
}

extension FurnitureViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return furnitureModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! FurnitureCell
        
        cell.furnitureData = furnitureModels[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let furniture = furnitureModels[indexPath.row]
        delegate?.didSelectCell(furnitureDae: furniture.furnitureDae, furnitureModelName: furniture.furnitureModelName)
        self.dismiss(animated: false, completion: nil)
    }
}

extension FurnitureViewController: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting

        if isPresenting == true {
            containerView.addSubview(toVC.view)

            menuView.frame.origin.y += menuHeight
            backdropView.alpha = 0

            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y -= self.menuHeight
                self.backdropView.alpha = 1
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseOut], animations: {
                self.menuView.frame.origin.y += self.menuHeight
                self.backdropView.alpha = 0
            }, completion: { (finished) in
                transitionContext.completeTransition(true)
            })
        }
    }
}
