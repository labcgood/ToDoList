//
//  ListTableViewCell.swift
//  Demo
//
//  Created by Labe on 2024/6/5.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var listTitleLabel: UILabel!
    
    let originalImage = UIImage(systemName: "circle")
    let okImage = UIImage(systemName: "checkmark.circle")
    var listIsOk:Bool = false
    let okColor = UIColor(red: 233/255, green: 232/255, blue: 232/255, alpha: 1)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        checkButton.setImage(originalImage, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // 勾選清單的效果及回復
    @IBAction func isFinish(_ sender: UIButton) {
        if listIsOk == false {
            listIsOk = true
            checkButton.setImage(okImage, for: .normal)
            checkButton.tintColor = okColor
            listTitleLabel.textColor = okColor
        } else {
            listIsOk = false
            checkButton.setImage(originalImage, for: .normal)
            checkButton.tintColor = .accent
            listTitleLabel.textColor = .accent
        }
    }
    
    // 設定cell
    func update(with item: ToDoItem) {
        listTitleLabel.text = item.title
        if item.isFinish == false {
            checkButton.setImage(originalImage, for: .normal)
            checkButton.tintColor = .accent
            listTitleLabel.textColor = .accent
        } else {
            checkButton.setImage(okImage, for: .normal)
            checkButton.tintColor = okColor
            listTitleLabel.textColor = okColor
        }
    }
}
