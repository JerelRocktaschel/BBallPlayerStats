//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class PlayerNameAndFavoriteView: UIView {
    
    //MARK: Internal Properties

    private let playerDetailViewModel: PlayerDetailViewModel
    private let favoriteButton = UIButton()
    var handle: ((_ error: LocalizedError) -> Void)?

    //MARK: Init
    
    init(with playerDetailViewModel: PlayerDetailViewModel) {
        self.playerDetailViewModel = playerDetailViewModel
        super.init(frame: .zero)
        initUI()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Init UI
    
    private func initUI() {
        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false
        let safeArea = safeAreaLayoutGuide
        let lastNameLabel = UILabel()
        lastNameLabel.font = Resources.font.lastNameLabel
        lastNameLabel.textColor = playerDetailViewModel.foregroundViewColor
        lastNameLabel.adjustsFontSizeToFitWidth = true
        lastNameLabel.minimumScaleFactor = Resources.float.lastNameLabel.minimumScaleFactor
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.text = playerDetailViewModel.lastName
        addSubview(lastNameLabel)
        let lastNameLabelCenterYConstraint = NSLayoutConstraint(
            item: lastNameLabel,
            attribute: NSLayoutConstraint.Attribute.centerY,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: safeArea,
            attribute: NSLayoutConstraint.Attribute.centerY,
            multiplier: Resources.float.lastNameLabel.centerYMultiplier,
            constant: 0
        )
        NSLayoutConstraint.activate([
            lastNameLabelCenterYConstraint,
            lastNameLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            lastNameLabel.leadingAnchor.constraint(
                equalTo: safeArea.leadingAnchor,
                constant: Resources.float.lastNameLabel.leadingAnchorConstant
            ),
            lastNameLabel.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: Resources.float.lastNameLabel.trailingAnchorConstant
            )
        ])
        
        let firstNameLabel = UILabel()
        firstNameLabel.font = Resources.font.firstNameLabel
        firstNameLabel.textColor = playerDetailViewModel.foregroundViewColor
        firstNameLabel.adjustsFontSizeToFitWidth = true
        firstNameLabel.minimumScaleFactor = Resources.float.firstNameLabel.minimumScaleFactor
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.text = playerDetailViewModel.firstName
        addSubview(firstNameLabel)
        let firstNameLabelCenterYConstraint = NSLayoutConstraint(
            item: firstNameLabel,
            attribute: NSLayoutConstraint.Attribute.centerY,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: safeArea,
            attribute: NSLayoutConstraint.Attribute.centerY,
            multiplier: Resources.float.firstNameLabel.centerYMultiplier,
            constant: 0
        )
        NSLayoutConstraint.activate([
            firstNameLabelCenterYConstraint,
            firstNameLabel.leadingAnchor.constraint(equalTo: lastNameLabel.leadingAnchor)
        ])
             
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.addTarget(self, action:#selector(setFavorite), for: .touchUpInside)
        addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            favoriteButton.trailingAnchor.constraint(
                equalTo: safeArea.trailingAnchor,
                constant: Resources.float.favoriteButton.trailingAnchorConstant
            ),
            favoriteButton.topAnchor.constraint(
                equalTo: safeArea.topAnchor,
                constant: Resources.float.favoriteButton.topAnchorConstant
            )
        ])
        setFavoriteButton()
    }
    
    //MARK: Private Functions

    private func setFavoriteButton() {
        let favorite = playerDetailViewModel.playerModel.favorite
        if favorite != nil {
            let favoritedImage = Resources.image.favoriteButton.favoritedStar
            favoriteButton.setImage(favoritedImage, for: .normal)
            favoriteButton.setImage(favoritedImage, for: .selected)
        } else {
            let unFavoritedImage = Resources.image.favoriteButton.unfavoritedStar
            favoriteButton.setImage(unFavoritedImage, for: .normal)
            favoriteButton.setImage(unFavoritedImage, for: .selected)
        }
    }
    
    @objc
    private func setFavorite() {
        do {
            try CoreDataManager.shared.saveFavoriteRelationship(for: playerDetailViewModel.playerModel)
        } catch {
            handle?(CoreDataError.saveFavoriteError)
            return
        }
        setFavoriteButton()
    }
}
