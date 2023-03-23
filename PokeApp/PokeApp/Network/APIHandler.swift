//
//  APIHandler.swift
//  PokeApp
//
//  Created by Oktay Tanrıkulu on 23.03.2023.
//

import Alamofire
import PromiseKit

final class APIHandler {
    
    let AF = Alamofire.SessionManager.default
    static let shared = APIHandler()
    
    private init() {}
    
    private func buildParams(task: Task) -> ([String: Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
    
    func processRequest<M: Codable, T: TargetType>(target: T) -> Promise<M> {
        let parameters = buildParams(task: target.task)
        
        return Promise<M> { seal in
            AF.request(target.baseURL + target.path, method: target.method, parameters: parameters.0, encoding: parameters.1, headers: target.headers).responseData { (data: DataResponse<Data>) in
                
                guard data.response?.statusCode == 200 else {
                    seal.reject(self.processError(error: .notFound, code: data.response?.statusCode, shouldShowMessage: true))
                    return
                }
                
                switch data.result {
                case .success(let result):
                    let decoder = JSONDecoder()
                    do {
                        seal.fulfill(try decoder.decode(M.self, from: result))
                    } catch {
                        seal.reject(self.processError(error: .parse, code: data.response?.statusCode, shouldShowMessage: true))
                    }
                case .failure:
                    seal.reject(self.processError(error: .failure, code: data.response?.statusCode, shouldShowMessage: true))
                }
            }
        }
    }
    
    // MARK: - Process Error
    private func processError(error: PokeError, code: Int?, shouldShowMessage: Bool) -> NSError {
        
        let responseError =  NSError(domain: Bundle.main.bundleIdentifier ?? "", code: code ?? 0, userInfo: [NSLocalizedDescriptionKey : error.rawValue])
        
        if shouldShowMessage == true {
            DispatchQueue.main.async {
                ToastMessage.shared.showOnWindow(title: AppConstants.AppTitle, message: responseError.localizedDescription, type: .error)
            }
        }
        
        return responseError
    }
}
