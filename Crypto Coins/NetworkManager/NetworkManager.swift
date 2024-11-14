//
//  NetworkManager.swift
//  Crypto Coins
//
//  Created by Vikee's Macbook Air on 13/11/24.
//

import Foundation

/// A dictionary of parameters to apply to a `URLRequest`.
public typealias Parameters = [String: Any]
public typealias HTTPHeaders = [String: String]

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public enum StatusCode: Int {
    case success = 200
    case invalidRequest = 400
    case internalServerError = 500
    case serviceDown = 503
}

public enum Result<T> {
    case success(T)
    case failure(CustomErrors, T?)
}

public enum CustomErrors: Error {
    case backend
    case noInternet
    case decodingFailed
    case dataUnavailable
    case unauthorised
    case noAction
}

public struct Resource<T: Decodable> {
    let url: URL
    var body: Parameters?
    var httpMethod = HTTPMethod.get
    var httpHeaders: HTTPHeaders?
}

// Protocol for handling network requests
protocol NetworkManagerProtocol {
    func sendRequest<T: Decodable>(
        resource: Resource<T>,
        sessionConfig: URLSessionConfiguration?,
        completion: @escaping (Result<T>) -> Void
    )
}

// Implementation of NetworkManager protocol
class NetworkManager: NSObject, NetworkManagerProtocol, URLSessionDelegate {
    
    func sendRequest<T: Decodable>(
        resource: Resource<T>,
        sessionConfig: URLSessionConfiguration? = URLSessionConfiguration.default,
        completion: @escaping (Result<T>) -> Void
    ) {
        if !AppUtility.isConnectedToInternet() {
            DispatchQueue.main.async {
                completion(.failure(.noInternet, nil))
            }
            return
        }

        var request = URLRequest(url: resource.url)
        request.httpMethod = resource.httpMethod.rawValue

        // Add headers if they exist
        resource.httpHeaders?.forEach { request.setValue($0.value, forHTTPHeaderField: $0.key) }

        // Set HTTP body if available
        if let body = resource.body,
           let jsonData = try? JSONSerialization.data(withJSONObject: body) {
            request.httpBody = jsonData
        }

        sendHTTPRequest(request, sessionConfig: sessionConfig, completion: completion)

    }
    
    private func sendHTTPRequest<T: Decodable>(_ request: URLRequest, sessionConfig: URLSessionConfiguration?,
                                               completion: @escaping(Result<T>) -> Void) {
        
        let session = URLSession(configuration: sessionConfig ?? .default, delegate: self, delegateQueue: nil)
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  200...299 ~= httpResponse.statusCode,
                  let dataResponse = data else {
                DispatchQueue.main.async {
                    completion(.failure(.dataUnavailable, nil))
                }
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: dataResponse)
                DispatchQueue.main.async {
                    completion(.success(decodedData))
                }
            } catch let error {
                debugPrint(error.localizedDescription)
                DispatchQueue.main.async {
                    completion(.failure(.decodingFailed, nil))
                }
            }
        }
        task.resume()

    }

}
