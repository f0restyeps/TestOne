//
//  SliderTableViewCell.swift
//  PeteaXMLTest
//
//  Created by 森宥貴 on 2019/04/24.
//  Copyright © 2019 森宥貴. All rights reserved.
//sliderCollectionCell

import UIKit
import CenteredCollectionView
import Alamofire

class SliderTableViewCell: UITableViewCell,UICollectionViewDelegate,UICollectionViewDataSource
{
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var titleArray: [String] = []
    var urlJsonArray: [String] = []
    var urlArray: [String] = []
    var thumbnailArray: [String] = []
    var thumbnailJsonArray: [String] = []
 
    var centeredCollectionViewFlowLayout: CenteredCollectionViewFlowLayout!
    let cellPercentWidth: CGFloat = 0.95
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
        sliderAlamofireRequest()
        setCenteredCollectionView()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return titleArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
     {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sliderCollectionCell", for: indexPath) as! SliderTestCollectionViewCell
        
        let thumbnailImage = thumbnailArray[indexPath.row]
        cell.sliderImageView.sd_setImage(with: URL(string: thumbnailImage), placeholderImage: UIImage(named: ""))
        cell.sliderImageView.clipsToBounds = true
        cell.sliderImageView.layer.cornerRadius = 0
        cell.sliderImageView.contentMode = UIView.ContentMode.scaleToFill
        
        cell.sliderTitle.text = titleArray[indexPath.row]
        cell.sliderTitle.textColor = UIColor.white
        
        UserDefaults.standard.set(indexPath.row, forKey: "INDEX_PATH")
        UserDefaults.standard.set(urlArray, forKey: "URL")
        
        return cell
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func sliderAlamofireRequest()
    {
        let requestUrl = "https://petea.jp/sjson/"

        
        Alamofire.request(requestUrl,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: nil)
            .response
            {
                response in
                guard let data = response.data else
                {
                    return
                }
                let elements = try! JSONDecoder().decode([SliderElements].self, from: data)
                
                for element in elements
                {
                    //Print element.
                    print("---------------------------------------------")
                    print("TITLE      | \(element.title)")
                    print("THUMBNAIL  | \(element.thumbnail)")
                    print("URL      | \(element.permalink)")
                    
                    self.titleArray.append(element.title)
                    self.thumbnailJsonArray.append(element.thumbnail)
                    self.urlJsonArray.append(element.permalink)
                    
                    self.thumbnailArray = self.thumbnailJsonArray.map { "https://petea.jp" + $0 }
                    self.urlArray = self.urlJsonArray.map{ "https://petea.jp" + $0 }
                }
                self.collectionView.reloadData()
        }
    }
    
    func setCenteredCollectionView()
    {
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Get the reference to the `CenteredCollectionViewFlowLayout` (REQURED STEP)
        centeredCollectionViewFlowLayout = collectionView.collectionViewLayout as! CenteredCollectionViewFlowLayout
        
        // Modify the collectionView's decelerationRate (REQURED STEP)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        
        // Configure the required item size (REQURED STEP)
        centeredCollectionViewFlowLayout.itemSize = CGSize(
            width: collectionView.bounds.width * cellPercentWidth,
            height: collectionView.bounds.height * cellPercentWidth * cellPercentWidth
        )
        
        // Configure the optional inter item spacing (OPTIONAL STEP)
        centeredCollectionViewFlowLayout.minimumLineSpacing = 10
        
        // Get rid of scrolling indicators
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = true
        
        collectionView.backgroundColor = UIColor.white
    }
}

