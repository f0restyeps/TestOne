//
//  ViewController.swift
//  PeteaXMLTest
//
//  Created by 森宥貴 on 2019/04/17.
//  Copyright © 2019 森宥貴. All rights reserved.
//https://petea.jp/dog/feed/
//https://news.yahoo.co.jp/pickup/rss.xml

import UIKit
import Parchment
import Alamofire
import SideMenu


class ViewController: UIViewController,UISearchBarDelegate
{
    
    override func viewDidLoad()
    {
        SideMenuManager.defaultManager.menuFadeStatusBar = false
        SideMenuManager.defaultManager.menuPresentMode = .menuSlideIn
        SideMenuManager.defaultManager.menuEnableSwipeGestures = false
        SideMenuManager.defaultManager.menuBlurEffectStyle = .none
        SideMenuManager.defaultManager.menuWidth = view.frame.width / 2
        
        /*
        var titleView : UIImageView
        titleView = UIImageView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        titleView.contentMode = .scaleAspectFit
        titleView.image = UIImage(named: "logo")
        self.navigationItem.titleView = titleView
        */
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: .white)
        //Navigation bar back ground color.
        self.navigationController?.navigationBar.barTintColor = .white
        //Navigation item color.
        self.navigationController?.navigationBar.tintColor = .lightGray
        //Navigaton title change text and color.
 
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let homeCategoryViewController = storyboard.instantiateViewController(withIdentifier: "HomeCategoryTableViewController")
        
        let dogCategoryViewController = storyboard.instantiateViewController(withIdentifier: "DogCategoryTableViewController")
        
        let catCategoryViewController = storyboard.instantiateViewController(withIdentifier: "CatCategoryTableViewController")
        
        let animalCategoryViewController = storyboard.instantiateViewController(withIdentifier: "AnimalCategoryTableViewController")
        
        let movieCategoryViewController = storyboard.instantiateViewController(withIdentifier: "MovieCategoryTableViewController")
        
        let pagingViewController = FixedPagingViewController(viewControllers: [
            homeCategoryViewController,
            dogCategoryViewController,
            catCategoryViewController,
            animalCategoryViewController,
            movieCategoryViewController
            ])
        
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
        
        pagingViewController.menuItemSize = .sizeToFit(minWidth: 100, height: 50)
        pagingViewController.menuHorizontalAlignment = .center
        pagingViewController.menuTransition = .scrollAlongside
        pagingViewController.menuInteraction = .scrolling
        pagingViewController.menuItemSpacing = 0
        pagingViewController.indicatorColor = UIColor.black
        
        pagingViewController.borderOptions = .visible(
            height: 10.4,//def 0.4
            zIndex: Int.max - 1,
            insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8))
        
        pagingViewController.indicatorOptions = .visible(
            height: 12,
            zIndex: Int.max,
            spacing: UIEdgeInsets.zero,
            insets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 1))
 
        pagingViewController.borderColor = UIColor.lightGray
        pagingViewController.textColor = UIColor.darkGray
        pagingViewController.selectedTextColor = UIColor.black
    }
}

extension UIImage
{
    class func imageWithColor(color: UIColor) -> UIImage
    {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 0.5)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
