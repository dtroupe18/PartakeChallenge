//
//  VenueCell.swift
//  PartakeChallenge
//
//  Created by Dave on 10/21/18.
//  Copyright © 2018 High Tree Development. All rights reserved.
//

import UIKit
import Anchorage
import Kingfisher
import BonMot

class VenueCell: UITableViewCell {
    
    private let nameStyle = StringStyle(
        .font(.medium(withSize: 18)),
        .alignment(.left),
        .color(.white)
    )

    private let locationStyle = StringStyle(
        .font(.light(withSize: 11)),
        .alignment(.left),
        .color(.white)
    )
    
    let containerView = UIView()
    let venueImageView = ScaledHeightImageView()
    let labelStackView = UIStackView()
    let nameLabel = UILabel()
    let locationLabel = UILabel()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(withVenue venue: Venue) {
        backgroundColor = UIColor.backgroundBlack
        addSubview(containerView)
        containerView.edgeAnchors == edgeAnchors
        
        addSubview(venueImageView)
        venueImageView.layer.cornerRadius = 8
        venueImageView.clipsToBounds = true
        venueImageView.topAnchor == topAnchor
        venueImageView.horizontalAnchors == horizontalAnchors + 20
        venueImageView.heightAnchor == venueImageView.widthAnchor * 0.51
        // venueImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight, .flexibleBottomMargin, .flexibleRightMargin, .flexibleLeftMargin, .flexibleTopMargin]
        // venueImageView.contentMode = .scaleAspectFit
        // venueImageView.contentMode = .bottom
        venueImageView.clipsToBounds = true
        
        
        if let url = URL(string: venue.imageURL) {
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: {[weak self] image, error, cacheType, imageURL in
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                } else if let img = image, let sself = self {
                
                    let ratio = img.size.width / img.size.height
                    if sself.containerView.frame.width > sself.containerView.frame.height {
                        let newHeight = sself.containerView.frame.width / ratio
                        sself.venueImageView.frame.size = CGSize(width: sself.containerView.frame.width, height: newHeight)
                    }
                    else{
                        let newWidth = sself.containerView.frame.height * ratio
                        sself.venueImageView.frame.size = CGSize(width: newWidth, height: sself.containerView.frame.height)
                    }
                    
                    // sself.venueImageView.image = sself.cropToBounds(image: img, width: width, height: height)
                    sself.venueImageView.image = img
                }
            })
        } else {
            // use some default image
        }

        // venueImageView.kf.setImage(with: URL(string: venue.imageURL))
        nameLabel.heightAnchor == 24
        nameLabel.attributedText = venue.name.styled(with: nameStyle)
        nameLabel.numberOfLines = 1
        
        let cityState = "\(venue.address.city), \(venue.address.state.uppercased()) |"
        let distance = " 3.1 mi"
        let locationString = cityState + distance
        
        locationLabel.attributedText = locationString.styled(with: locationStyle)
        
        addSubview(labelStackView)
        labelStackView.axis = .vertical
        labelStackView.spacing = 4
        labelStackView.distribution = .fillProportionally
        labelStackView.topAnchor == venueImageView.bottomAnchor + 8
        labelStackView.horizontalAnchors == horizontalAnchors + 20
        labelStackView.bottomAnchor == bottomAnchor - 12
        labelStackView.addArrangedSubviews([nameLabel, locationLabel])
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    override func prepareForReuse() {
        venueImageView.image = nil
    }
    
    func hide() {
        for aView in containerView.subviews{
            aView.alpha = 0.0
        }
    }
    
    func show() {
        for aView in containerView.subviews{
            aView.alpha = 1.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
