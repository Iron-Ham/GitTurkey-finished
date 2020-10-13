//
//  UserManager.swift
//  graphql
//
//  Created by Hesham Salman on 10/13/20.
//

import Foundation

struct UserManager {
    var token: String?

    private init() { }

    static var shared = UserManager()
}
