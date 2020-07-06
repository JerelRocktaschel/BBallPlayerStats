//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class PlayerTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets
    
    @IBOutlet weak var teamLogoImageView: UIImageView!
    @IBOutlet weak var playerNameLabel: UILabel!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    //MARK: Public functions
    
    public func configureCell(with presenter: PlayerTableViewCellPresentable) {
        teamLogoImageView.image = presenter.getTeamLogoImage(from: presenter.teamModel)
        playerNameLabel.text = presenter.getPlayerName(from: presenter.playerModel)
        favoriteImageView.image = presenter.getFavoriteImage(from: presenter.playerModel)
    }
}
