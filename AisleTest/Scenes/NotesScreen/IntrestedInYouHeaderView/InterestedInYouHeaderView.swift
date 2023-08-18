//
//  InterestedInYouHeaderView.swift
//  AisleTest
//
//  Created by Rajat Verma on 18/08/23.
//

import UIKit

class InterestedInYouHeaderView: UICollectionReusableView {
    struct ViewModel: NotesHeaderData {
        let heading: String
        let subHeading: String
    }

    @IBOutlet private weak var subLabel: UILabel!
    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var upgradeButton: UIButton!
    
    var callBack: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        upgradeButton.layer.cornerRadius = upgradeButton.frame.height/2
        upgradeButton.setTitle("Upgrade", for: .normal)
        upgradeButton.setTitle("Upgrade", for: .selected)
        upgradeButton.backgroundColor = .aisleYellow
        upgradeButton.titleLabel?.font = .boldSystemFont(ofSize: 15)
    }
    
    @IBAction func upgradeButtonClicked(_ sender: Any) {
        callBack?()
    }
    
    func config(_ data: ViewModel) {
        headingLabel.text = data.heading
        subLabel.text = data.subHeading
    }
    
}
