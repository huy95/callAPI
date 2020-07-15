//
//  CollectionViewCell.swift
//  SearchItunes
//
//  Created by Taof on 5/21/20.
//  Copyright © 2020 taoquynh. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var layerView: UIView!
    
    var itune: Itune? {
        didSet {
            if let itune = itune {
                photoImageView.kf.setImage(with: URL(string: itune.artworkUrl100 ?? ""))
                nameLabel.text = itune.trackName
                nameLabel.numberOfLines = 2
                layerView.alpha = 0.8
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupLayout()
    }
    
    func setupLayout(){
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: photoImageView.leadingAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: layerView.centerYAnchor, constant: 0)
        ])
    }
    
}
