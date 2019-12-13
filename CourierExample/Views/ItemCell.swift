//
//  ItemCell.swift
//  CourierExample
//
//  Created by k2o on 2019/12/12
//  Copyright © 2019 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(with item: Item) {
        self.itemImageView.image = item.image
        self.titleLabel.text = item.title
        self.detailLabel.text = item.detail
    }
}
