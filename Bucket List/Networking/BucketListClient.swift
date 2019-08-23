//
//  BucketListClient.swift
//  Bucket List
//
//  Created by Michael Stoffer on 8/22/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noAuth
    case badAuth
    case otherError
    case badData
    case noDecode
}

class BucketListClient {
    typealias CompletionHandler = (Error?) -> Void
    
    private let baseURL = URL(string: "https://bucket-list-be.herokuapp.com/")!
    private (set) var users: [User] = []
    var token: Token?
    
    func register(with user: User, completion: @escaping CompletionHandler = { _ in }) {
        let registerURL = baseURL.appendingPathComponent("api/register")
        
        var request = URLRequest(url: registerURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            
            completion(nil)
        }.resume()
    }
    
    func login(with user: User, completion: @escaping CompletionHandler = { _ in }) {
        let loginURL = baseURL.appendingPathComponent("api/login")
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            guard let data = data else { completion(NSError()); return }
            
            let decoder = JSONDecoder()
            
            do {
                self.token = try decoder.decode(Token.self, from: data)
            } catch {
                print("Error decoding bearer object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func fetchAllUsers(completion: @escaping (Result<[User], NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/users")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue("USER_TOKEN \(token.token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .secondsSince1970
            do {
                let users = try decoder.decode([User].self, from: data)
                completion(.success(users))
            } catch {
                NSLog("Error decoding users object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
}
