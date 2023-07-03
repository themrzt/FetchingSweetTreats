//
//  Menu.swift
//  SweetTreats
//
//  Created by Zach Tarvin on 7/3/23.
//
// Purpose: Use this struct to persist menus of existing meals and recipes across sessions.

import Foundation

struct TreatsMenu: Codable{
    var meals: [Meal]
}
