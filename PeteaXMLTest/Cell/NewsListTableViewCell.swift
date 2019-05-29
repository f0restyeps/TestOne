//
//  NewsListTableViewCell.swift
//  PeteaXMLTest
//
//  Created by 森宥貴 on 2019/05/07.
//  Copyright © 2019 森宥貴. All rights reserved.
//

import UIKit
import TagListView

class NewsListTableViewCell: UITableViewCell
{
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsDateLabel: UILabel!
    @IBOutlet weak var newsAuthorLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    
    
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
