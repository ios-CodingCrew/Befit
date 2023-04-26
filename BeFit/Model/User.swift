//
//  User.swift
//  BeFit
//
//  Created by Evelyn on 4/25/23.
//

import Foundation

import ParseSwift


struct User: ParseUser {
    // These are required by `ParseObject`.
    var objectId: String?
    var createdAt: Date?
    var updatedAt: Date?
    var ACL: ParseACL?
    var originalData: Data?

    // These are required by `ParseUser`.
    var username: String?
    var email: String?
    var emailVerified: Bool?
    var password: String?
    var authData: [String: [String: String]?]?

    // Your custom properties.

    // TODO: Pt 2 - Add custom property for `lastPostedDate`
    //var lastPostedDate: Date?
    var userid: Int?
    
    //incase we need to implement the stretch goal
    var height: Float?
    var weight: Float?

}
