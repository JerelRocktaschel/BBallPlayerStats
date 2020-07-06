//
//  Copyright (c) 2020 Jerel Rocktaschel. All rights reserved.
//

import UIKit

final class PlayerPersonalStatisticsView: UIView {
    
    //MARK: Internal Properties
    
    private var playerDetailViewModel: PlayerDetailViewModel
    
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
        backgroundColor = playerDetailViewModel.backgroundViewColor
        translatesAutoresizingMaskIntoConstraints = false
        
        let heightCategoryLabel: UILabel = UILabel()
        heightCategoryLabel.text = Resources.string.playerStatsLabel.heightCategory
        heightCategoryLabel.font = Resources.font.heightCategoryLabel
        addSubview(heightCategoryLabel)
        setCategoryLabelConstraints(for: heightCategoryLabel, with: Resources.float.heightCategoryLabel.centerYMultiplier)
                
        let heightLineView = UIView()
        let heightValueLabel = UILabel()
        heightValueLabel.attributedText = playerDetailViewModel.height
        addSubview(heightLineView)
        addSubview(heightValueLabel)
        setLineViewConstraints(for: heightLineView, using: heightCategoryLabel, and: heightValueLabel)
        setValueLabelConstraints(for: heightValueLabel, using: heightLineView)

        let weightCategoryLabel: UILabel = UILabel()
        weightCategoryLabel.text = Resources.string.playerStatsLabel.weightCategory
        weightCategoryLabel.font = Resources.font.weightCategoryLabel
        addSubview(weightCategoryLabel)
        setCategoryLabelConstraints(for: weightCategoryLabel, with: Resources.float.weightCategoryLabel.centerYMultiplier)

        let weightLineView = UIView()
        let weightValueLabel = UILabel()
        weightValueLabel.attributedText = playerDetailViewModel.pounds
        addSubview(weightLineView)
        addSubview(weightValueLabel)
        setLineViewConstraints(for: weightLineView, using: weightCategoryLabel, and: weightValueLabel)
        setValueLabelConstraints(for: weightValueLabel, using: weightLineView)

        let dateOfBirthCategoryLabel: UILabel = UILabel()
        dateOfBirthCategoryLabel.text = Resources.string.playerStatsLabel.dateOfBirthCategory
        dateOfBirthCategoryLabel.font = Resources.font.dateOfBirthCategoryLabel
        addSubview(dateOfBirthCategoryLabel)
        setCategoryLabelConstraints(for: dateOfBirthCategoryLabel, with: Resources.float.dateOfBirthCategoryLabel.centerYMultiplier)
        
        let dateOfBirthLineView = UIView()
        let dateOfBirthValueLabel = UILabel()
        dateOfBirthValueLabel.text = playerDetailViewModel.dateOfBirth
        dateOfBirthValueLabel.font = Resources.font.dateOfBirthValueLabel
        dateOfBirthValueLabel.textColor = playerDetailViewModel.foregroundViewColor
        addSubview(dateOfBirthLineView)
        addSubview(dateOfBirthValueLabel)
        setLineViewConstraints(for: dateOfBirthLineView, using: dateOfBirthCategoryLabel, and: dateOfBirthValueLabel)
        setValueLabelConstraints(for: dateOfBirthValueLabel, using: dateOfBirthLineView)
        
        let ageCategoryLabel: UILabel = UILabel()
        ageCategoryLabel.text = Resources.string.playerStatsLabel.ageCategory
        ageCategoryLabel.font = Resources.font.ageCategoryLabel
        addSubview(ageCategoryLabel)
        setCategoryLabelConstraints(for: ageCategoryLabel, with: Resources.float.ageCategoryLabel.centerYMultiplier)
        
        let ageLineView = UIView()
        let ageValueLabel = UILabel()
        ageValueLabel.attributedText = playerDetailViewModel.age
        addSubview(ageLineView)
        addSubview(ageValueLabel)
        setLineViewConstraints(for: ageLineView, using: ageCategoryLabel, and: ageValueLabel)
        setValueLabelConstraints(for: ageValueLabel, using: ageLineView)
    }
    
    //MARK: Private Functions
    
    private func setCategoryLabelConstraints(for categoryLabel: UILabel, with multiplier: CGFloat) {
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.textColor = .black
        categoryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Resources.float.categoryLabel.leadingAnchorConstant).isActive = true
        let categoryLabelCenterYConstraint = NSLayoutConstraint(item: categoryLabel,
                                                                attribute: NSLayoutConstraint.Attribute.centerY,
                                                                relatedBy: NSLayoutConstraint.Relation.equal,
                                                                toItem: self,
                                                                attribute: NSLayoutConstraint.Attribute.centerY,
                                                                multiplier: multiplier,
                                                                constant: 0)
        addConstraint(categoryLabelCenterYConstraint)
    }
    
    private func setLineViewConstraints(for lineView: UIView, using statView: UIView, and valueLabel: UIView) {
        lineView.backgroundColor = UIColor.white.withAlphaComponent(Resources.float.lineView.alpha)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.leadingAnchor.constraint(equalTo: statView.trailingAnchor, constant: Resources.float.lineView.trailingAnchorConstant).isActive = true
        lineView.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: Resources.float.lineView.leadingAnchorConstant).isActive = true
        lineView.centerYAnchor.constraint(equalTo: statView.centerYAnchor).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setValueLabelConstraints(for valueLabel: UILabel, using lineView: UIView) {
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.centerYAnchor.constraint(equalTo: lineView.centerYAnchor).isActive = true
        valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Resources.float.valueLabel.trailingAnchorConstant).isActive = true
    }
}
