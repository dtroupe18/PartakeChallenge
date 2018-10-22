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
    
    private let placeHolderStyle = StringStyle(
        .font(.light(withSize: 14)),
        .alignment(.left),
        .color(.black)
    )
    
    private let fullStackView = UIStackView()
    private let horizontalStackView = UIStackView()
    private let userImageView = CircleImageView()
    let searchBar = UITextField() // not private so we can assign the delegate to the VC
    private let searchImageView = UIImageView()
    private let sliderImageView = UIImageView()
    
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
        addSubview(searchBar)
        
        let searchImage = UIImage(named: "search")
        searchImageView.widthAnchor == 40 // little wider to get some extra space
        searchImageView.heightAnchor == 20
        searchImageView.contentMode = .scaleAspectFit // keeps the image square
        searchImageView.image = searchImage
        searchBar.leftView = searchImageView
        searchBar.leftViewMode = .always
        
        let sliderImage = UIImage(named: "slider")
        sliderImageView.widthAnchor == 40 // little wider to get some extra space
        sliderImageView.heightAnchor == 20
        sliderImageView.contentMode = .scaleAspectFit // keeps the image square
        sliderImageView.image = sliderImage
        searchBar.rightView = sliderImageView
        searchBar.rightViewMode = .always
        
        searchBar.attributedPlaceholder = "search venues...".styled(with: placeHolderStyle)
        searchBar.topAnchor == horizontalStackView.bottomAnchor + 13
        searchBar.heightAnchor == 31
        searchBar.horizontalAnchors == horizontalAnchors + 20
        searchBar.bottomAnchor == bottomAnchor - 13
        searchBar.backgroundColor = .white
        searchBar.layer.cornerRadius = 15
        searchBar.keyboardAppearance = .dark
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
