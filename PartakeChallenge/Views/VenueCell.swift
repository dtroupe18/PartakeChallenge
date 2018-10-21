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
import CoreLocation

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
    let venueImageView = UIImageView()
    let labelStackView = UIStackView()
    let nameLabel = UILabel()
    let locationLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(withVenue venue: Venue, userLocation: CLLocation) {
        backgroundColor = UIColor.backgroundBlack
        addSubview(containerView)
        containerView.edgeAnchors == edgeAnchors
        
        addSubview(venueImageView)
        venueImageView.layer.cornerRadius = 8
        venueImageView.clipsToBounds = true
        venueImageView.topAnchor == topAnchor
        venueImageView.horizontalAnchors == horizontalAnchors + 20
        venueImageView.heightAnchor == venueImageView.widthAnchor * 0.51
        venueImageView.contentMode = .scaleToFill
        venueImageView.kf.indicatorType = .activity
        
        if let url = URL(string: venue.imageURL) {
            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: {[weak self] image, error, cacheType, imageURL in
                if error != nil {
                    print("Error: \(error!.localizedDescription)")
                } else if let img = image, let sself = self {
                    let resized = img.resizedImageWith(targetSize: sself.venueImageView.frame.size)
                    
                    sself.venueImageView.alpha = 0
                    sself.venueImageView.image = resized
                    UIView.animate(withDuration: 0.2) {
                        sself.venueImageView.alpha = 1
                    }
                }
            })
        } else {
            // use some default image
        }
        
        nameLabel.heightAnchor == 24
        nameLabel.attributedText = venue.name.styled(with: nameStyle)
        nameLabel.numberOfLines = 1
        
        let cityState = "\(venue.address.city), \(venue.address.state.uppercased()) |"
        let distance = getDistanceString(userLocation: userLocation, venue: venue)
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
    
    func getDistanceString(userLocation: CLLocation, venue: Venue) -> String {
        if userLocation.coordinate.latitude == 0.0 || userLocation.coordinate.longitude == 0.0 {
            // No location
            return " ∞ mi"
        } else {
            let venueLocation = CLLocation(latitude: venue.latitude, longitude: venue.longitude)
            let distanceInMeters = userLocation.distance(from: venueLocation)
            let distanceInMiles = distanceInMeters/1609.344
            let distanceString = " " + String(format: "%.1f", distanceInMiles) + " mi"
            return distanceString
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        venueImageView.image = nil
    }
    
    func hide() {
        for view in containerView.subviews {
            view.alpha = 0.0
        }
    }
    
    func show() {
        for view in containerView.subviews {
            view.alpha = 1.0
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

