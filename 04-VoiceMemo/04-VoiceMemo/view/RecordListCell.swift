//
//  RecordListCell.swift
//  04-VoiceMemo
//
//  Created by dzw on 2019/5/19.
//  Copyright © 2019 dzw. All rights reserved.
//

import UIKit

enum FoldState {
    case isflod
    case unfold
}

class RecordListCell: UITableViewCell {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    @IBOutlet weak var back15Button: UIButton!
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBOutlet weak var forward15Button: UIButton!
    
    var currentFoldState :FoldState = .unfold
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func forward15Action(_ sender: UIButton) {
        print("forward15Action")
    }
    
    @IBAction func back15Action(_ sender: UIButton) {
        print("back15Action")
    }
    
    
    @IBAction func playAction(_ sender: Any) {
        print("playAction")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func foldState(foldState: FoldState) {
        switch foldState {
        case .unfold://展开
            self.progressView.isHidden = false
            self.startTimeLabel.isHidden = false
            self.endTimeLabel.isHidden = false
            self.back15Button.isHidden = false
            self.playButton.isHidden = false
            self.forward15Button.isHidden = false
            break
        case .isflod://s折叠
            self.progressView.isHidden = true
            self.startTimeLabel.isHidden = true
            self.endTimeLabel.isHidden = true
            self.back15Button.isHidden = true
            self.playButton.isHidden = true
            self.forward15Button.isHidden = true
            break
        }
    }
    
}
