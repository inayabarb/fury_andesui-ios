//
//  CellConfiguration.swift
//  AndesUI
//
//  Created by Jonathan Alonso Pinto on 20/10/20.
//

import Foundation

public class AndesSimpleViewCellConfig: AndesListViewCell {

    @objc public init(withTitle title: String, size: AndesListSize, subTitle: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        cellConfig(withTitle: title, size: size, subTitle: subTitle)
    }

    public init(withTitle title: String, size: AndesListSize?, subTitle: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: "")
        guard let size = size, let subTitle = subTitle else { return }
        cellConfig(withTitle: title, size: size, subTitle: subTitle)
    }

    private func cellConfig(withTitle title: String, size: AndesListSize? = .medium, subTitle: String? = String()) {
        guard let size = size, let subTitle = subTitle else { return }
        let hasDescription = (subTitle.isEmpty ) ? false : true
        let config = AndesListViewCellTypeFactory.provide(withSize: size, hasDescription: hasDescription)
        self.type = .simple
        self.title = title
        self.subTitle = subTitle
        self.fontStyle = config.font
        self.fontSubTitleStyle = config.fontDescription
        self.paddingLeftCell = config.paddingLeft
        self.paddingRightCell = config.paddingRight
        self.paddingTopCell = config.paddingTop
        self.paddingBottomCell = config.paddingBottom
        self.subTitleHeight = config.descriptionHeight
        self.separatorHeight = config.separatorHeight
        self.heightConstraint = config.heightConstraint
        self.titleHeightConstraint = config.titleHeightConstraint
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}