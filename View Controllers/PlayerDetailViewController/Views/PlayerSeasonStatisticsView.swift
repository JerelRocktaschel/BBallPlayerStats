//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class PlayerSeasonStatisticsView: UIView {
    
    //MARK: Internal Properties
    
    var playerDetailViewModel: PlayerDetailViewModel
    private let seasonValueLabel = UILabel()
    private let ppgValueLabel = UILabel()
    private let rpgValueLabel = UILabel()
    private let apgValueLabel = UILabel()
    private let spgValueLabel = UILabel()
    private let bpgValueLabel = UILabel()
    
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
        seasonValueLabel.font = Resources.font.seasonValueLabel
        seasonValueLabel.textColor = .black
        seasonValueLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(seasonValueLabel)
        seasonValueLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        seasonValueLabel.topAnchor.constraint(equalTo: topAnchor,
                                              constant: Resources.float.seasonValueLabel.topAnchorConstant).isActive = true
        
        let ppgCategoryView = UIView()
        addSubview(ppgCategoryView)
        setCategoryViewConstraints(for: ppgCategoryView)
              
        let ppgCategoryLabel = UILabel()
        ppgCategoryLabel.text = Resources.string.playerStatsLabel.ppgCategory
        ppgCategoryLabel.font = Resources.font.ppgCategoryLabel
        ppgCategoryView.addSubview(ppgCategoryLabel)
        setCategoryLabelConstraints(for: ppgCategoryLabel, using: ppgCategoryView)
                      
        ppgValueLabel.font = Resources.font.ppgValueLabel
        ppgValueLabel.textColor = playerDetailViewModel.foregroundViewColor
        ppgCategoryView.addSubview(ppgValueLabel)
        setValueLabelConstraints(for: ppgValueLabel, using: ppgCategoryView)
              
        let ppgCenterLineView = UIView()
        ppgCenterLineView.backgroundColor = .black
        ppgCategoryView.addSubview(ppgCenterLineView)
        setCenterLineViewConstraints(for: ppgCenterLineView, using: ppgCategoryView)
              
        let ppgRightBorder = UIView()
        ppgRightBorder.backgroundColor = .black
        ppgCategoryView.addSubview(ppgRightBorder)
        setRightBorderViewConstraints(for: ppgRightBorder, using: ppgCategoryView)
              
        let rpgCategoryView = UIView()
        addSubview(rpgCategoryView)
        setCategoryViewConstraints(for: rpgCategoryView, using: ppgCategoryView)
              
        let rpgCategoryLabel: UILabel = UILabel()
        rpgCategoryLabel.text = Resources.string.playerStatsLabel.rpgCategory
        rpgCategoryLabel.font = Resources.font.rpgCategoryLabel
        rpgCategoryView.addSubview(rpgCategoryLabel)
        setCategoryLabelConstraints(for: rpgCategoryLabel, using: rpgCategoryView)
              
        rpgValueLabel.font = Resources.font.rpgValueLabel
        rpgValueLabel.textColor = playerDetailViewModel.foregroundViewColor
        rpgCategoryView.addSubview(rpgValueLabel)
        setValueLabelConstraints(for: rpgValueLabel, using: rpgCategoryView)
              
        let rpgCenterLineView = UIView()
        rpgCenterLineView.backgroundColor = .black
        rpgCategoryView.addSubview(rpgCenterLineView)
        setCenterLineViewConstraints(for: rpgCenterLineView, using: rpgCategoryView)
              
        let rpgRightBorder = UIView()
        rpgRightBorder.backgroundColor = .black
        rpgCategoryView.addSubview(rpgRightBorder)
        setRightBorderViewConstraints(for: rpgRightBorder, using: rpgCategoryView)
              
        let apgCategoryView = UIView()
        addSubview(apgCategoryView)
        setCategoryViewConstraints(for: apgCategoryView, using: rpgCategoryView)
                             
        let apgCategoryLabel = UILabel()
        apgCategoryLabel.text = Resources.string.playerStatsLabel.apgCategory
        apgCategoryLabel.font = Resources.font.apgCategoryLabel
        apgCategoryView.addSubview(apgCategoryLabel)
        setCategoryLabelConstraints(for: apgCategoryLabel, using: apgCategoryView)
              
        apgValueLabel.font = Resources.font.apgValueLabel
        apgValueLabel.textColor = playerDetailViewModel.foregroundViewColor
        apgCategoryView.addSubview(apgValueLabel)
        setValueLabelConstraints(for: apgValueLabel, using: apgCategoryView)

        let apgCenterLineView = UIView()
        apgCenterLineView.backgroundColor = .black
        apgCategoryView.addSubview(apgCenterLineView)
        setCenterLineViewConstraints(for: apgCenterLineView, using: apgCategoryView)
              
        let apgRightBorder = UIView()
        apgRightBorder.backgroundColor = .black
        apgCategoryView.addSubview(apgRightBorder)
        setRightBorderViewConstraints(for: apgRightBorder, using: apgCategoryView)
                      
        let spgCategoryView = UIView()
        addSubview(spgCategoryView)
        setCategoryViewConstraints(for: spgCategoryView, using: apgCategoryView)
              
        let spgCategoryLabel = UILabel()
        spgCategoryLabel.text = Resources.string.playerStatsLabel.spgCategory
        spgCategoryLabel.font = Resources.font.spgCategoryLabel
        spgCategoryView.addSubview(spgCategoryLabel)
        setCategoryLabelConstraints(for: spgCategoryLabel, using: spgCategoryView)
              
        spgValueLabel.font = Resources.font.spgValueLabel
        spgValueLabel.textColor = playerDetailViewModel.foregroundViewColor
        spgCategoryView.addSubview(spgValueLabel)
        setValueLabelConstraints(for: spgValueLabel, using: spgCategoryView)
              
        let spgCenterLineView = UIView()
        spgCenterLineView.backgroundColor = .black
        spgCategoryView.addSubview(spgCenterLineView)
        setCenterLineViewConstraints(for: spgCenterLineView, using: spgCategoryView)
              
        let spgRightBorder = UIView()
        spgRightBorder.backgroundColor = .black
        spgCategoryView.addSubview(spgRightBorder)
        setRightBorderViewConstraints(for: spgRightBorder, using: spgCategoryView)
              
        let bpgCategoryView = UIView()
        addSubview(bpgCategoryView)
        setCategoryViewConstraints(for: bpgCategoryView, using: spgCategoryView)
        bpgCategoryView.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                                  constant: Resources.float.bpgCategoryView.trailingAnchorConstant).isActive = true
              
        let bpgCategoryLabel = UILabel()
        bpgCategoryLabel.text = Resources.string.playerStatsLabel.bpgCategory
        bpgCategoryLabel.font = Resources.font.bpgCategoryLabel
        bpgCategoryView.addSubview(bpgCategoryLabel)
        setCategoryLabelConstraints(for: bpgCategoryLabel, using: bpgCategoryView)
              
        bpgValueLabel.font = Resources.font.bpgValueLabel
        bpgValueLabel.textColor = playerDetailViewModel.foregroundViewColor
        bpgCategoryView.addSubview(bpgValueLabel)
        setValueLabelConstraints(for: bpgValueLabel, using: bpgCategoryView)
              
        let bpgCenterLineView = UIView()
        bpgCenterLineView.backgroundColor = .black
        bpgCategoryView.addSubview(bpgCenterLineView)
        setCenterLineViewConstraints(for: bpgCenterLineView, using: bpgCategoryView)
    }
    
    func setStatValues() {
        seasonValueLabel.text = setSeasonLabelText(with: playerDetailViewModel.seasonYear)
        ppgValueLabel.text = playerDetailViewModel.ppg
        rpgValueLabel.text = playerDetailViewModel.rpg
        apgValueLabel.text = playerDetailViewModel.apg
        spgValueLabel.text = playerDetailViewModel.spg
        bpgValueLabel.text = playerDetailViewModel.bpg
    }
    
    //MARK: Private Functions
    
    private func setCategoryLabelConstraints(for categoryLabel: UILabel, using categoryView: UIView) {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor).isActive = true
        let categoryLabelCenterYConstraint = NSLayoutConstraint(item: categoryLabel,
                                                                 attribute: NSLayoutConstraint.Attribute.centerY,
                                                                 relatedBy: NSLayoutConstraint.Relation.equal,
                                                                 toItem: categoryView,
                                                                 attribute: NSLayoutConstraint.Attribute.centerY,
                                                                 multiplier: Resources.float.seasonStatsCategoryLabel.centerYMultiplier,
                                                                 constant: 0)
        categoryView.addConstraint(categoryLabelCenterYConstraint)
    }
    
    private func setCategoryViewConstraints(for categoryView: UIView) {
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: Resources.float.seasonStatsCategoryView.leadingAnchorConstant).isActive = true
        categoryView.topAnchor.constraint(equalTo: self.topAnchor, constant: Resources.float.seasonStatsCategoryView.topAnchorConstant).isActive = true
        categoryView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: Resources.float.seasonStatsCategoryView.bottomAnchorConstant).isActive = true
    }
    
    private func setCategoryViewConstraints(for categoryView: UIView, using baseCategoryView: UIView) {
        categoryView.translatesAutoresizingMaskIntoConstraints = false
        categoryView.widthAnchor.constraint(equalTo: baseCategoryView.widthAnchor).isActive = true
        categoryView.topAnchor.constraint(equalTo: baseCategoryView.topAnchor).isActive = true
        categoryView.bottomAnchor.constraint(equalTo: baseCategoryView.bottomAnchor).isActive = true
        categoryView.leadingAnchor.constraint(equalTo: baseCategoryView.trailingAnchor).isActive = true
    }
    
    private func setValueLabelConstraints(for valueLabel: UILabel, using categoryView: UIView) {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerXAnchor.constraint(equalTo: categoryView.centerXAnchor).isActive = true
        let valueLabelCenterYConstraint = NSLayoutConstraint(item: valueLabel,
                                                                attribute: NSLayoutConstraint.Attribute.centerY,
                                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                                toItem: categoryView,
                                                                attribute: NSLayoutConstraint.Attribute.centerY,
                                                                multiplier: Resources.float.seasonStatsValueLabel.centerYMultiplier,
                                                                constant: 0)
        categoryView.addConstraint(valueLabelCenterYConstraint)
    }
    
    private func setCenterLineViewConstraints(for centerLineView: UIView, using categoryView: UIView) {
        centerLineView.translatesAutoresizingMaskIntoConstraints = false
        centerLineView.heightAnchor.constraint(equalToConstant: Resources.float.seasonStatsCenterLineView.heightAnchorMultiplier).isActive = true
        centerLineView.leadingAnchor.constraint(equalTo: categoryView.leadingAnchor).isActive = true
        centerLineView.trailingAnchor.constraint(equalTo: categoryView.trailingAnchor).isActive = true
        centerLineView.centerYAnchor.constraint(equalTo: categoryView.centerYAnchor).isActive = true
    }
    
    private func setRightBorderViewConstraints(for rightBorderView: UIView, using categoryView: UIView) {
        rightBorderView.translatesAutoresizingMaskIntoConstraints = false
        rightBorderView.widthAnchor.constraint(equalToConstant: Resources.float.seasonStatsRightBorderView.widthAnchorConstant).isActive = true
        rightBorderView.topAnchor.constraint(equalTo: categoryView.topAnchor).isActive = true
        rightBorderView.bottomAnchor.constraint(equalTo: categoryView.bottomAnchor).isActive = true
        let rightBorderViewCenterXConstraint = NSLayoutConstraint(item: rightBorderView,
                                                                      attribute: NSLayoutConstraint.Attribute.centerX,
                                                                      relatedBy: NSLayoutConstraint.Relation.equal,
                                                                      toItem: categoryView,
                                                                      attribute: NSLayoutConstraint.Attribute.centerX,
                                                                      multiplier: Resources.float.seasonStatsRightBorderView.centerYMultiplier,
                                                                      constant: 0)
        categoryView.addConstraint(rightBorderViewCenterXConstraint)
    }
    
    private func setSeasonLabelText(with seasonYear:Int) -> String {
        if seasonYear > 0 {
            let nextSeasonYear = seasonYear + 1
            return "\(seasonYear)-\(nextSeasonYear) SEASON"
        } else {
            return Resources.string.statsNotAvailable.na
        }
    }
}
