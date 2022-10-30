//
//  CompaniesTableViewDataConverter.swift
//  AvitoTask
//
//  Created by Тимур Миргалиев on 25.10.2022.
//

import Foundation

protocol ICompaniesTableViewDataConverter: AnyObject {
    func convertToCellData(companies: Companies) -> Company
}

final class CompaniesTableViewDataConverter: ICompaniesTableViewDataConverter {
    
    func convertToCellData(companies: Companies) -> Company {
        var company: Company = Company()
        
        guard let nameOfCompany = companies.company?.name,
              let employees = companies.company?.employees else { return Company() }
        
        company.employees = employees.sorted { $0.name < $1.name }
        company.name = nameOfCompany
        
        return company
    }
}
