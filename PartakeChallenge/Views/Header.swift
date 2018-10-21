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
    
    private let fullStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    
    private let userImageView = CircleImageView()
    private let searchBar = UITextField()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let rightButton: UIButton = {
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
        
        userImageView.widthAnchor == 36
        userImageView.image = UIImage(named: "profilePicture")
        userImageView.contentMode = .scaleAspectFill
 
        titleLabel.attributedText = "Select Venue".styled(with: titleStyle)
        rightButton.widthAnchor == 36
        
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
