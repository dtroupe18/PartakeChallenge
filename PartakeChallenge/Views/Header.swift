//
//  Header.swift
//  PartakeChallenge
//
//  Created by Dave on 10/18/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import Anchorage

class Header: UIView {
    
    let fullStackView = UIStackView()
    let horizontalStackView = UIStackView()
    
    let userImageView = CircleImageView()
    let searchBar = UITextField()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.text = "Select Venue"
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
        addSubview(userImageView)
        userImageView.heightAnchor == 28
        userImageView.widthAnchor == 28
        userImageView.topAnchor == self.topAnchor + 4
        userImageView.bottomAnchor == self.bottomAnchor - 4
        userImageView.leftAnchor == self.leftAnchor + 20
        userImageView.image = UIImage(named: "profilePicture")
        userImageView.contentMode = .scaleAspectFill
        
        addSubview(titleLabel)
        titleLabel.centerYAnchor == self.centerYAnchor
        titleLabel.centerXAnchor == self.centerXAnchor
        
        addSubview(rightButton)
        rightButton.heightAnchor == 28
        rightButton.widthAnchor == 28
        rightButton.rightAnchor == self.rightAnchor - 20
        rightButton.topAnchor == self.topAnchor + 4
        rightButton.bottomAnchor == self.bottomAnchor - 4
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
