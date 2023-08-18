//
//  MainNoteCollectionViewCell.swift
//  AisleTest
//
//  Created by Rajat Verma on 18/08/23.
//

import UIKit

class MainNoteCollectionViewCell: UICollectionViewCell {
    struct ViewModel: CellDataType {
        let name: String
        let age: Int
        let imageURLStr: String
        let imageIsBlur: Bool
    }

    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var nameAgeLabel: UILabel!
    @IBOutlet private weak var blurrView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainImageView.layer.cornerRadius = 10
        blurrView.layer.cornerRadius = 10
    }
    
    func config(_ data: ViewModel) {
        var nameText = "\(data.name)"
        nameText.append(data.age == -1 ? "" : ", \(data.age)")
        nameAgeLabel.text = nameText
        mainImageView.image = UIImage(named: "dummy_image")
        
        if data.imageIsBlur {
            blurrView.isHidden = false
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.clipsToBounds = true
            blurrView.clipsToBounds = true
            blurEffectView.frame = blurrView.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            blurrView.addSubview(blurEffectView)
        } else {
            blurrView.isHidden = true
        }
    }

}