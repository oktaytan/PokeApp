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
    
    /// Endpoint'e ait parametreleri varsa bir tuple halinde döner.
    /// - Parameter task: <#task description#>
    /// - Returns: <#description#>
    private func buildParams(task: Task) -> ([String: Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(parameters: let parameters, encoding: let encoding):
            return (parameters, encoding)
        }
    }
    
    /// Servis isteklerinin yapılıp cevabın işlenmesini sağlar.
    /// - Parameter target: İsteğin yapılacağı endpint' in parametrelerini içeriri.
    /// - Returns: Promise nesnesi
    func processRequest<M: Codable, T: TargetType>(target: T) -> Promise<M> {
        let parameters = buildParams(task: target.task)
        
        return Promise<M> { seal in
            AF.request(target.baseURL + target.path, method: target.method, parameters: parameters.0, encoding: parameters.1, headers: target.headers).responseData { (data: DataResponse<Data>) in
                
                guard data.response?.statusCode == 200 else {
                    seal.reject(self.processError(error: .notFound, code: data.response?.statusCode))
                    return
                }
                
                switch data.result {
                case .success(let result):
                    let decoder = JSONDecoder()
                    do {
                        seal.fulfill(try decoder.decode(M.self, from: result))
                    } catch {
                        seal.reject(self.processError(error: .parse, code: data.response?.statusCode))
                    }
                case .failure:
                    seal.reject(self.processError(error: .failure, code: data.response?.statusCode))
                }
            }
        }
    }
    
    // MARK: - Process Error
    private func processError(error: PokeError, code: Int?) -> NSError {
        
        let responseError =  NSError(domain: Bundle.main.bundleIdentifier ?? "", code: code ?? 0, userInfo: [NSLocalizedDescriptionKey : error.rawValue])
        
        return responseError
    }
}
