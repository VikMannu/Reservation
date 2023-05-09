//
//  APIClient.swift
//  Reservation
//
//  Created by Victor Ayala  on 2023-05-08.
//

import Alamofire
import AlamofireActivityLogger
import TrustKit
import os.log

typealias DataResponse = Alamofire.DataResponse
typealias JSONObject = [String: Any]
typealias SUDictionary = [String: AnyObject]

enum Encoding {
    case `default`
    case json
    case query
    case array
    case body
    
    var alamofire: ParameterEncoding {
        switch self {
        case .default:
            return URLEncoding(destination: .methodDependent)
        case .json:
            return JSONEncoding.default
        case .query:
            return URLEncoding.queryString
        case .array:
            return ArrayEncoding()
        case .body:
            return StringEncoding()
        }
    }
}

struct APIClient {
    // Custom logger for this API Client
    static let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "APIClient")
    // Default error when error type is not recognized
    static let errorCustom = ErrorModel.init(useApiMessage: false, message: "", code: "")
    
    // DICTIONARY PARAMETERS REQUEST.
    @discardableResult
    static func apiRequest<T: Codable>(
        method: HTTPMethod = .get,
        api: DiscoveryAPI,
        keypath: String? = nil,
        parameters: [String: Any] = [:],
        headers: HTTPHeaders? = nil,
        encoding: Encoding = .default,
        successHandler: @escaping (T) -> Void,
        errorHandler: ((ErrorModel) -> Bool)? = nil
    ) -> DataRequest? {
        return rawRequest(method: method, url: api.urlString, keypath: keypath, parameters: parameters, headers: headers, encoding: encoding, successHandler: successHandler, errorHandler: errorHandler)
    }
    
    // RAW REQUEST.
    @discardableResult
    static func rawRequest<T: Codable>(
        method: HTTPMethod = .get,
        url: String?,
        keypath: String? = nil,
        parameters: [String: Any] = [:],
        headers: HTTPHeaders? = nil,
        useSLLPinning: Bool = false,
        encoding: Encoding = .default,
        successHandler: @escaping (T) -> Void,
        errorHandler: ((ErrorModel) -> Bool)? = nil
    ) -> DataRequest? {
        
        guard NetworkReachabilityManager()?.isReachable == true else {
            os_log("No internet connection", log: logger)
            let error = ErrorModel(useApiMessage: true, message: ErrorModel.networkMessage, code: "0")
            if !(errorHandler?(error) ?? false) {
                Utils.showBarnner(title: "Error de conexion", subtitle: error.getMessage())
            }
            return nil
        }
        
        // Use a decoder with a custom ISO 8601 decoder to handle dates.
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .customISO8601
        
        let header = headers ?? getHeaders()
        
        let defaultErrorHandler = { (data: Data) in
            guard let error = try? decoder.decode(ErrorModel.self, from: data) else {
                Utils.showBarnner(title: "Error Decode", subtitle: errorCustom.getMessage())
                return
            }

            switch error.code {
            case "a1100":
                os_log("Session expiration", log: logger)
                Utils.showBarnner(title: "Session expirarion", subtitle: error.getMessage())
                break
            default:
                os_log("Default message error", logger)
                Utils.showBarnner(title: "Error", subtitle: error.getMessage())
                break
            }
        }
        
        let handleError = { (data: Data?) in
            guard let data = data else {
                os_log("Data for handle error is null", log: logger)
                Utils.showBarnner(title: "Data for handle error is null", subtitle: errorCustom.getMessage())
                return
            }
            
            if let error = try? decoder.decode(ErrorModel.self, from: data) {
                let wasHandled = errorHandler?(error)
                if wasHandled == nil || wasHandled == false {
                    defaultErrorHandler(data)
                }
            } else {
                os_log("Failed to decode error data model", log: logger)
                if !(errorHandler?(errorCustom) ?? false) {
                    Utils.showBarnner(title: "Failed to decode error data model", subtitle: errorCustom.getMessage())
                }
            }
        }
        
        guard let url = url else {
            os_log("Failed to get URL. Clear Singleton", log: logger)
            Singleton.shared.clear()
            return nil
        }
        
        let request = useSLLPinning ? CustomSessionManager.shared.request(url, method: method, parameters: parameters, encoding: encoding.alamofire, headers: header) : CustomSessionManagerNoSSL.shared.request(url, method: method, parameters: parameters, encoding: encoding.alamofire, headers: header)
        
        let req = request.log().responseData(completionHandler: { response in
            
            guard response.response?.statusCode == 200 && response.error == nil, var data = response.data else {
                os_log("The api response came with http error", log: logger)
                handleError(response.data)
                return
            }
            
            do {
                // Handle the keypath if present (only handles one level of keypath).
                if let key = keypath, let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Get the object that the keypath references and convert it back to data for `Codable` to deserialize.
                    if let subDict = dict[key], let subData = try? JSONSerialization.data(withJSONObject: subDict, options: []) {
                        data = subData
                    }
                }
                let obj = try decoder.decode(T.self, from: data)
                successHandler(obj)
            } catch let e {
                os_log("Error serializing json to data model", log: logger)
                print(e) // Printing is the only way to get the keystream where serialization fails
                handleError(response.data)
            }
        })
        
        return req
    }
    
    static func getHeaders() -> HTTPHeaders {
        let parameters = [
            "Accept"                    : "application/json"
        ]
        return parameters
    }
}

class CustomSessionManager: SessionManager {
    static let shared: CustomSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.timeoutIntervalForRequest = 120
        let delegate = CustomSessionManagerDelegate()
        let manager = CustomSessionManager(configuration: configuration, delegate: delegate)
        return manager
    }()
}

//First conection to discovery must be without pinning ssl
class CustomSessionManagerNoSSL: SessionManager {
    static let shared: CustomSessionManagerNoSSL = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 120
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        let manager = CustomSessionManagerNoSSL(configuration: configuration)
        return manager
        
    }()
}

class CustomSessionManagerDelegate: SessionDelegate {
    override func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        // Call into TrustKit here to do pinning validation
        if TrustKit.sharedInstance().pinningValidator.handle(challenge, completionHandler: completionHandler) == false {
            // TrustKit did not handle this challenge: perhaps it was not for server trust
            // or the domain was not pinned. Fall back to the default behavior
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
