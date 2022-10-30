//
//  MainScreenInteractor.swift
//  AvitoTask
//
//  Created by Тимур Миргалиев on 25.10.2022.
//

import Foundation

private enum Constants {
    static let generalUrl: String = "https://run.mocky.io/v3/1d1cb4ec-73db-4762-8c4b-0b8aa3cecd4c"
    static let lastTimeOfRequestKeyInUserDefaults: String = "time"
    static let maximumAllowedTimeForCaching: Int = 3600
    static let satisfactoryStatusCode: Range = Range(200...299)
}

private enum Errors: String, Error {
    case parsingError = "Parsing Eroor"
    case connectionError = "Connection Error"
    case strongSelfError = "Strong self Error"
    case unsatisfactoryStatusCodeError = "Unsatisfactory Status Code Error"
}

protocol IMainScreenInteractor: AnyObject {
    func getStoredOrLoadСompanies(completion: @escaping ((Company) -> Void))
    func getLoadCompanies(completion: @escaping ((Company) -> Void))
}

protocol MainScreenInteractorOutput: AnyObject {
    func needToUpdateCompanies()
    func needToShowAlert()
}

final class MainScreenInteractor: IMainScreenInteractor {

    // Properties
    private let session = URLSession.shared
    private let decoder = JSONDecoder()

    private let userDefaults = UserDefaults.standard
    private let cache = URLCache.shared

    private let cellDataConverter: ICompaniesTableViewDataConverter = CompaniesTableViewDataConverter()

    weak var output: MainScreenInteractorOutput!

    func getStoredOrLoadСompanies(completion: @escaping ((Company) -> Void)) {
        guard let url = URL(string: Constants.generalUrl) else { return }
        let request = URLRequest(url: url)

        guard Int(Date().timeIntervalSince1970) - userDefaults.integer(forKey: Constants.lastTimeOfRequestKeyInUserDefaults) < Constants.maximumAllowedTimeForCaching,
              let chachedData = cache.cachedResponse(for: request)?.data,
              let companies = try? self.decoder.decode(Companies.self, from: chachedData) else {
            getСompaniesFromNetwork(request: request) {
                switch $0 {
                case let .success(data):
                    completion(self.cellDataConverter.convertToCellData(companies: data))
                case .failure(_):
                    self.output.needToShowAlert()
                }
            }
            return
        }
        completion(self.cellDataConverter.convertToCellData(companies: companies))
    }

    func getLoadCompanies(completion: @escaping ((Company) -> Void)) {
        guard let url = URL(string: Constants.generalUrl) else { return }
        let request = URLRequest(url: url)
        getСompaniesFromNetwork(request: request) {
            switch $0 {
            case let .success(data):
                completion(self.cellDataConverter.convertToCellData(companies: data))
            case .failure(_):
                self.output.needToShowAlert()
            }
        }
    }

    private func getСompaniesFromNetwork(request: URLRequest,
                                         completion: @escaping ((Result<Companies, Error>) -> Void)) {

        self.session.dataTask(with: request) { [weak self] (data, response, error) in
            let result: Result<Companies, Error>
            guard let self = self else {
                result = .failure(Errors.strongSelfError)
                return
            }

            guard let response = response as? HTTPURLResponse,
                  Constants.satisfactoryStatusCode.contains(response.statusCode) else {
                result = .failure(Errors.unsatisfactoryStatusCodeError)
                completion(result)
                return
            }

            if error == nil, let parsData = data {
                guard let companies = try? self.decoder.decode(Companies.self, from: parsData) else {
                    result = .failure(Errors.parsingError)
                    return
                }

                self.cache.removeAllCachedResponses()
                let cachedURLResponse = CachedURLResponse(response: response, data: parsData)
                self.cache.storeCachedResponse(cachedURLResponse, for: request)
                self.userDefaults.set(Date().timeIntervalSince1970, forKey: Constants.lastTimeOfRequestKeyInUserDefaults)
                result = .success(companies)
            } else {
                result = .failure(Errors.connectionError)
            }

            completion(result)
        }.resume()
    }
}
