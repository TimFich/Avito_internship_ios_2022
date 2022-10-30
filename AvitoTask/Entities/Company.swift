//
//  Company.swift
//  AvitoTask
//
//  Created by Тимур Миргалиев on 25.10.2022.
//

import Foundation

struct Companies: Codable {
    var company: Company?
}

struct Company: Codable {
    var name: String
    var employees: [Employee]
    
    init(name: String, employees: [Employee]) {
        self.name = name
        self.employees = employees
    }
    
    init() {
        name = ""
        employees = []
    }
}

struct Employee: Codable {
    var name: String
    var phoneNumber: String
    var skills: [String]
    
    enum CodingKeys: String, CodingKey {
        case name, skills
        case phoneNumber = "phone_number"
    }
}
