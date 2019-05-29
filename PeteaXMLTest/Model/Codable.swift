//
//  File.swift
//  PeteaXMLTest
//
//  Created by 森宥貴 on 2019/04/26.
//  Copyright © 2019 森宥貴. All rights reserved.
//

import Foundation

//typealias HomeJsonData = [HomeJsonDataElement]

/*
struct UserResponse
{
    let elements: [JsonData]
}

 */
public struct Elements: Codable
{
    let title: String
    let permalink: String
    let date: String
    let author: String
    let thumbnail: String
    let categories: [String]
    let tags: [String]

}

public struct SliderElements: Codable
{
    let title: String
    let permalink: String
    let thumbnail: String
    
    private enum CodingKeys: String, CodingKey
    {
        case title = "post_title"
        case permalink = "guid"
        case thumbnail = "thumbnail"
    }
}

public struct SearchElements: Codable
{
    let title: String
    let permalink: String
    let thumbnail: String
    let categories:[String]
    let date: String
    let author: String
    
    
    private enum CodingKeys: String, CodingKey
    {
        case title = "post_title"
        case permalink = "guid"
        case thumbnail = "thumbnail"
        case categories = "categories"
        case date = "post_date"
        case author = "post_author"
    }
}

/*
extension UserResponse: Codable
{
    init(from decoder: Decoder) throws
    {
        self.init(elements: try [JsonData](from: decoder))
    }
    
    func encode(to encoder: Encoder) throws
    {
        try elements.encode(to: encoder)
    }
}
 
 enum CodingKeys: String, CodingKey
 {
 case title = "post_title"
 }
*/

