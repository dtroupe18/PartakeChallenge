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
    
    var imageViewHeightContraint: NSLayoutConstraint?

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
        imageViewHeightContraint = venueImageView.heightAnchor == venueImageView.widthAnchor * 0.51
        venueImageView.contentMode = .scaleToFill

        if let url = URL(string: venue.imageURL) {
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: {[weak self] image, error, cacheType, imageURL in
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                } else if let img = image, let sself = self {
                    
//                    let ratio = img.size.width / img.size.height
//                    let newHeight = sself.venueImageView.frame.width / ratio
//                    sself.imageViewHeightContraint?.constant = newHeight
//                    sself.layoutIfNeeded()
                    
//                    let ratio = img.size.width / img.size.height
//                    let imageViewRatio = sself.venueImageView.frame.size.width / sself.venueImageView.frame.size.height
//                    print("imageRatio: \(ratio)")
//                    print("imageViewRatio: \(imageViewRatio)")
//
//                    if sself.containerView.frame.width > sself.containerView.frame.height {
//                        let newHeight = sself.containerView.frame.width / ratio
//                        sself.venueImageView.frame.size = CGSize(width: sself.containerView.frame.width, height: newHeight)
//                    }
//                    else {
//                        let newWidth = sself.containerView.frame.height * ratio
//                        sself.venueImageView.frame.size = CGSize(width: newWidth, height: sself.containerView.frame.height)
//                    }
                    
//                    let resized = img.resize(height: sself.venueImageView.frame.height)
//                    print("resized.height: \(String(describing: resized?.size.height))")
//                    print("venueImageView.frame.height: \(sself.venueImageView.frame.height)")
//                    print("\n")
//                    sself.venueImageView.image = resized
                    
//                    let resized = img.resize(width: sself.venueImageView.frame.width)
//                    sself.venueImageView.image = resized
//                    print("resized.width: \(String(describing: resized.size.width))")
//                    print("resized.height: \(String(describing: resized.size.height))")
//                    print("venueImageView.frame.height: \(sself.venueImageView.frame.width)")
//                    print("\n")
                    
//                    let resized = img.resizeImage(targetSize: sself.venueImageView.frame.size)
//                    sself.venueImageView.image = resized
//                    print("resized.width: \(String(describing: resized.size.width))")
//                    print("resized.height: \(String(describing: resized.size.height))")
//                    print("venueImageView.frame.width: \(sself.venueImageView.frame.width)")
//                    print("venueImageView.frame.height: \(sself.venueImageView.frame.height)")
//                    print("\n")
                    
//                    let resized = sself.resizedImageWith(image: img, targetSize: sself.venueImageView.frame.size)
//                    sself.venueImageView.image = resized
//                    print("original.width: \(String(describing: img.size.width))")
//                    print("original.height: \(String(describing: img.size.height))")
//                    print("resized.width: \(String(describing: resized?.size.width))")
//                    print("resized.height: \(String(describing: resized?.size.height))")
//                    print("\n")
                    
                    let cropped = sself.cropToBounds(image: img, width: Double(sself.venueImageView.frame.width), height: Double(sself.venueImageView.frame.height))
                    sself.venueImageView.image = cropped
                    print("original.width: \(String(describing: img.size.width))")
                    print("original.height: \(String(describing: img.size.height))")
                    print("resized.width: \(String(describing: cropped.size.width))")
                    print("resized.height: \(String(describing: cropped.size.height))")
                    print("\n")


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
        
        selectionStyle = .none
    }
    
    func resizedImageWith(image: UIImage, targetSize: CGSize) -> UIImage? {
        
        let imageSize = image.size
        let newWidth  = targetSize.width/image.size.width
        let newHeight = targetSize.height/image.size.height
        var newSize: CGSize
        
        if newWidth > newHeight {
            newSize = CGSize(width: imageSize.width * newHeight, height: imageSize.height * newHeight)
        } else {
            newSize = CGSize(width: imageSize.width * newWidth, height: imageSize.height * newWidth)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
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
