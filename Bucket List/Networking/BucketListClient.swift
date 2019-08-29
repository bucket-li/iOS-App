//
//  BucketListClient.swift
//  Bucket List
//
//  Created by Michael Stoffer on 8/22/19.
//  Copyright © 2019 Michael Stoffer. All rights reserved.
//

import UIKit

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
    var token: Token?
    
    private (set) var items: [Item] = []
    
    var completedItems: [Item] {
        return self.items.filter { $0.completed == true }
    }
    
    var notCompletedItems: [Item] {
        return self.items.filter { $0.completed == false }
    }
    
    func register(withName name: String, withEmail email: String, withPassword password: String, completion: @escaping CompletionHandler = { _ in }) {
        let registerURL = baseURL.appendingPathComponent("api/register")
        
        var request = URLRequest(url: registerURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userParams = ["name": name, "email": email, "password": password] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
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
    
    func login(withEmail email: String, withPassword password: String, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/login")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userParams = ["email": email, "password": password] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
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
    
    func fetchAllUsers(completion: @escaping (Result<Users, NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/users")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            do {
                let users = try decoder.decode(Users.self, from: data)
                completion(.success(users))
            } catch {
                NSLog("Error decoding users object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchLoggedInUser(completion: @escaping (Result<UserResponse, NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/user")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(UserResponse.self, from: data)
                completion(.success(user))
            } catch {
                NSLog("Error decoding user object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchUser(withId id: Int, completion: @escaping (Result<UserResponse, NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/user/\(id)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(UserResponse.self, from: data)
                completion(.success(user))
            } catch {
                NSLog("Error decoding user object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchUserItems(withId id: Int, completion: @escaping (Result<Items, NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/user/\(id)/items")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let items = try decoder.decode(Items.self, from: data)
                completion(.success(items))
            } catch {
                NSLog("Error decoding items object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchItem(withId id: Int, completion: @escaping (Result<ItemResponse, NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/item/\(id)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let item = try decoder.decode(ItemResponse.self, from: data)
                completion(.success(item))
            } catch {
                NSLog("Error decoding item object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchItemPosts(withId id: Int, completion: @escaping (Result<Posts, NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/item/\(id)/posts")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let posts = try decoder.decode(Posts.self, from: data)
                completion(.success(posts))
            } catch {
                NSLog("Error decoding items object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchPost(withId id: Int, completion: @escaping (Result<PostResponse, NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/item/post/\(id)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let post = try decoder.decode(PostResponse.self, from: data)
                completion(.success(post))
            } catch {
                NSLog("Error decoding item object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchPostImages(withId id: Int, completion: @escaping (Result<Images, NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/item/post/\(id)/images")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let images = try decoder.decode(Images.self, from: data)
                completion(.success(images))
            } catch {
                NSLog("Error decoding item object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func fetchPostImage(withId id: Int, completion: @escaping (Result<ImageResponse, NetworkError>) -> Void) {
        guard let token = self.token else { completion(.failure(.noAuth)); return }
        
        let requestURL = baseURL.appendingPathComponent("api/item/post/image/\(id)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.addValue(token.token, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode == 401 {
                completion(.failure(.badAuth))
                return
            }
            
            if let _ = error { completion(.failure(.otherError)); return }
            guard let data = data else { completion(.failure(.badData)); return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            do {
                let image = try decoder.decode(ImageResponse.self, from: data)
                completion(.success(image))
            } catch {
                NSLog("Error decoding item object: \(error)")
                completion(.failure(.noDecode))
                return
            }
        }.resume()
    }
    
    func createItem(withUserId userId: Int, withDescription description: String, withCompleted completed: Bool = false, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/item")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userParams = ["user_id": userId, "completed": completed, "description": description] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            print("Error encoding item object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            completion(nil)
        }.resume()
    }
    
    func createItemPost(withItemId itemId: Int, withMessage message: String, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/item")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userParams = ["item_id": itemId, "message": message] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            print("Error encoding item object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            completion(nil)
        }.resume()
    }
    
    func createPostImage(withPostId postId: Int, withImage image: UIImage?, withImageURL imageURL: URL?, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/item")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userParams = ["post_id": postId, "image": image ?? "", "url": imageURL ?? ""] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            print("Error encoding item object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            completion(nil)
        }.resume()
    }
    
    func updateItem(withItemId itemId: Int, withDescription description: String, withCompleted completed: Bool = false, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/item/\(itemId)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userParams = ["completed": completed, "description": description] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            print("Error encoding item object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            completion(nil)
        }.resume()
    }
    
    func updateItemPost(withPostId postId: Int, withItemId itemId: Int, withMessage message: String, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/item/post/\(postId)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userParams = ["item_id": itemId, "message": message] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            print("Error encoding item object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            completion(nil)
        }.resume()
    }
    
    func updatePostImage(withImageId imageId: Int, withPostId postId: Int, withImage image: UIImage?, withImageURL imageURL: URL?, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/item/post/image/\(imageId)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let userParams = ["post_id": postId, "image": image ?? "", "url": imageURL ?? ""] as [String: Any]
            let json = try JSONSerialization.data(withJSONObject: userParams, options: .prettyPrinted)
            request.httpBody = json
        } catch {
            print("Error encoding item object: \(error)")
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            completion(nil)
        }.resume()
    }
    
    func deleteItem(withItemId itemId: Int, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/item/\(itemId)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            completion(nil)
        }.resume()
    }
    
    func deleteItemPost(withPostId postId: Int, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/item/post/\(postId)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            completion(nil)
        }.resume()
    }
    
    func deletePostImage(withImageId imageId: Int, completion: @escaping CompletionHandler = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("api/item/post/image/\(imageId)")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                completion(NSError(domain: "", code: response.statusCode, userInfo: nil))
                return
            }
            
            if let error = error { completion(error); return }
            completion(nil)
        }.resume()
    }
}
