//
//  BreweryTableViewCell.swift
//  rx medium article
//
//  Created by Pramodya Abeysinghe on 10/11/20.
//

import UIKit

class BreweryTableViewCell: UITableViewCell {

    static let id = "BreweryTableViewCell"
    static let nib = UINib(nibName: id, bundle: nil)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(with brewery: Brewery) {
        nameLabel.text = brewery.name
        addressLabel.text = "\(brewery.street ?? "") \(brewery.city ?? "")"
    }
}
