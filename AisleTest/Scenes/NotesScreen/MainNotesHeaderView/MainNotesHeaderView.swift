//
//  MainNotesHeaderView.swift
//  AisleTest
//
//  Created by Rajat Verma on 18/08/23.
//

import UIKit

class MainNotesHeaderView: UICollectionReusableView {
    struct ViewModel: NotesHeaderData {
        let heading: String
        let subHeading: String
    }
    
    @IBOutlet private weak var headingLabel: UILabel!
    @IBOutlet private weak var subLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(_ data: ViewModel) {
        headingLabel.text = data.heading
        subLabel.text = data.subHeading
    }
    
}
