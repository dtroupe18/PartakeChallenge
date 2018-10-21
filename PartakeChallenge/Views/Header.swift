//
//  Header.swift
//  PartakeChallenge
//
//  Created by Dave on 10/18/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import Anchorage
import BonMot // String styling

class Header: UIView {
    
    private let titleStyle = StringStyle(
        .font(.light(withSize: 20)),
        .alignment(.center),
        .color(.white)
    )
    
    private let mediumStyle = StringStyle(
        .font(.medium(withSize: 18)),
        .alignment(.center),
        .color(.white)
    )
    
    private let lightStyle = StringStyle(
        .font(.light(withSize: 11)),
        .alignment(.center),
        .color(.white)
    )
    
    let fullStackView = UIStackView()
    let horizontalStackView = UIStackView()
    
    let userImageView = CircleImageView()
    let searchBar = UITextField()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    let rightButton: UIButton = {
        let button = UIButton(type : .system)
        // Just making this a square because I couldn't find an image for this button
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1.0
        return button
    }()

    public init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.backgroundBlack
        // Horizontal stackView holds the top section of the header
        
        addSubview(horizontalStackView)
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 8
        horizontalStackView.distribution = .equalCentering
        horizontalStackView.horizontalAnchors == horizontalAnchors + 20
        horizontalStackView.topAnchor == topAnchor + 8
        horizontalStackView.heightAnchor == 36
        
//        userImageView.heightAnchor == 28
        userImageView.widthAnchor == 36
        userImageView.image = UIImage(named: "profilePicture")
        userImageView.contentMode = .scaleAspectFill
        
        // addSubview(titleLabel)
        // titleLabel.centerXAnchor == self.centerXAnchor
        titleLabel.attributedText = "Select Venue".styled(with: titleStyle)
        // titleLabel.text = "Select Venue"
        
        // addSubview(rightButton)
//        rightButton.heightAnchor == 28
        rightButton.widthAnchor == 36
        // rightButton.rightAnchor == self.rightAnchor - 20
        // rightButton.topAnchor == self.topAnchor + 4
        // rightButton.bottomAnchor == self.bottomAnchor - 4
        
        horizontalStackView.addArrangedSubviews([userImageView, titleLabel, rightButton])
        horizontalStackView.bottomAnchor == bottomAnchor - 8
        
        
        
        
        
        
//        addSubview(searchBar)
//        searchBar.placeholder = "search venues..."
//        searchBar.layer.cornerRadius = searchBar.frame.height/2
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
