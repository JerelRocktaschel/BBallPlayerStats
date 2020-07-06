//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class TeamTableViewCell: UITableViewCell {
    
    //MARK: IBOutlets

    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var teamLogoImageView: UIImageView!
    
    //MARK: Public functions
    
    public func configureCell(with presenter: TeamTableViewCellPresentable) {
        self.teamNameLabel.text = presenter.getTeamName(from: presenter.teamModel)
        self.teamLogoImageView.image = presenter.getTeamLogoImage(from: presenter.teamModel)
    }
}
