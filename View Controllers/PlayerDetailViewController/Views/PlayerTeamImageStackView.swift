//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class PlayerTeamImageStackView: UIStackView {
    
    //MARK: Internal Properties
    
    var playerDetailViewModel: PlayerDetailViewModel
    private lazy var playerImageView = UIImageView()

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
        addBackground(color: playerDetailViewModel.backgroundViewColor)
        axis = .horizontal
        alignment = .center
        distribution = .fill
        spacing = 0
        translatesAutoresizingMaskIntoConstraints = false
        
        let logoJerseyPositionStackView = UIStackView()
        logoJerseyPositionStackView.axis = .vertical
        logoJerseyPositionStackView.distribution = .fill
        logoJerseyPositionStackView.spacing = 0
        logoJerseyPositionStackView.translatesAutoresizingMaskIntoConstraints = false
               
        let jerseyPositionStackView = UIStackView()
        jerseyPositionStackView.axis = .horizontal
        jerseyPositionStackView.distribution  = .fillProportionally
        jerseyPositionStackView.spacing = Resources.float.playerTeamImageStackView.jerseyStackViewSpacing
        jerseyPositionStackView.alignment = .fill
    
        playerImageView.contentMode = .scaleAspectFit
        
        let teamLogoImageView: UIImageView = UIImageView()
        teamLogoImageView.contentMode = .scaleAspectFit
        teamLogoImageView.image = playerDetailViewModel.teamLogoImage

        let jerseyPositionLabel: UILabel = UILabel()
        jerseyPositionLabel.textAlignment = .center
        jerseyPositionLabel.textColor = playerDetailViewModel.foregroundViewColor
        jerseyPositionLabel.font = Resources.font.jerseyPositionLabel
        jerseyPositionLabel.adjustsFontSizeToFitWidth = true
        jerseyPositionLabel.text = playerDetailViewModel.jersey
        
        let spacerView = UIView()
        spacerView.frame = CGRect(
            x: 0,
            y: 0,
            width: Resources.float.spacerView.width,
            height: jerseyPositionLabel.frame.height
        )
        
        jerseyPositionStackView.addArrangedSubview(jerseyPositionLabel)
        jerseyPositionStackView.addArrangedSubview(spacerView)
        addArrangedSubview(playerImageView)
        
        logoJerseyPositionStackView.addArrangedSubview(teamLogoImageView)
        logoJerseyPositionStackView.addArrangedSubview(jerseyPositionStackView)
        addArrangedSubview(logoJerseyPositionStackView)
        
        NSLayoutConstraint.activate([
            teamLogoImageView.heightAnchor.constraint(
                equalTo: logoJerseyPositionStackView.heightAnchor,
                multiplier: Resources.float.teamLogoView.heightAnchor),
            logoJerseyPositionStackView.widthAnchor.constraint(
                equalTo: widthAnchor,
                multiplier: Resources.float.logoJerseyPositionStackView.widthAnchor)
        ])
    }
    
    func setPlayerImage() {
        playerImageView.image = playerDetailViewModel.playerImage
    }
}
