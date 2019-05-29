//
//  SideMenuNavigationTableViewController.swift
//  PeteaXMLTest
//
//  Created by 森宥貴 on 2019/05/13.
//  Copyright © 2019 森宥貴. All rights reserved.
//

import UIKit
import SDWebImage

class SideMenuNavigationTableViewController: UITableViewController
{
    let snsTitleArray: [String] = ["","Twitter", "Facebook", "Instagram"]
    let snsImageArray: [String] = ["","Twitter.png", "Facebook.png", "Instagram.png"]
    let snsUrlArray: [String] = ["","https://twitter.com/PeteaOfficial/", "https://www.facebook.com/PeteaOfficial/", "https://www.instagram.com/peteaofficial/"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //Delete separator of empty cells.
        tableView.tableFooterView = UIView(frame: .zero)
        
        
        //tableView.separatorStyle = .none
    }
    
    //Setting TableView.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row
        {
        case 0:
            
            return 163
            
        default:
            
            return 70
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return snsTitleArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TitleImageCell", for: indexPath)
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SnsCell", for: indexPath) as! SideMenuNavigationCell
            
            cell.snsImage.image = UIImage(named: snsImageArray[indexPath.row])
            
            cell.snsLabel.text = snsTitleArray[indexPath.row]
            cell.snsLabel.textColor = UIColor.darkGray
            cell.layoutMargins = UIEdgeInsets.zero
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let indexPath = self.tableView.indexPathForSelectedRow
        {
            let snsWebViewController = segue.destination as! SnsWebViewController
            
            print("\(snsUrlArray[indexPath.row])")
            snsWebViewController.receiveUrl = snsUrlArray[indexPath.row]
        }
    }
    /*
     case 0:
     let cell = tableView.dequeueReusableCell(withIdentifier: "TitleImageCell", for: indexPath)
     
     return cell
     
     default:
     let cell = tableView.dequeueReusableCell(withIdentifier: "SnsCell", for: indexPath) as! SideMenuNavigationCell
     
     cell.snsLabel.text = snsTitleArray[indexPath.row]
     cell.snsImage.image = UIImage(named: snsImageArray[indexPath.row])
     
     return cell
     }
     */
}
