//
//  FurnitureView.swift
//  AR Furniture
//
//  Created by Domagoj Kolaric on 25.12.2020..
//

import UIKit

class FurnitureCell: UICollectionViewCell {
    
    var furnitureData: Furniture? {
        didSet {
            guard let data = furnitureData else { return }
            furnitureImage.image = data.image
        }
    }
    
    fileprivate let furnitureImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "chair01")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 12
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor(red: 218/255, green: 178/255, blue: 75/255, alpha: 1).cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(furnitureImage)
        furnitureImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        furnitureImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        furnitureImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        furnitureImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("Has to be implemented as it is required but will never be used")
    }
}
