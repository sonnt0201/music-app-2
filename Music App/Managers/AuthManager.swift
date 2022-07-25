//
//  AuthManager.swift
//  Music App
//
//  Created by Sơn Nguyễn on 10/07/2022.
//

import Foundation

final class AuthManager {
    // MARK: - Singleton init
    static let shared = AuthManager()
    var refreshingToken = false
    
    struct Constant {
        static let clientID = "17d785a3d4f44d69915d7e0e2c9146e9"
        static let clientSecret = "52d5a6c3ce5541cf9449ace6d36b6b1a"
        static let tokenAPIURL = "https://accounts.spotify.com/api/token"
        static let redirectURI = "https://open.spotify.com"
        static let scope = "user-read-private"
        static let base = "https://accounts.spotify.com/authorize"
    }
    private init(){}
    
    // MARK: - redirect
    public var signInURL: URL? {
        
        let string = "\(Constant.base)?response_type=code&client_id=\(Constant.clientID)&scope=\(Constant.scope)&redirect_uri=\(Constant.redirectURI)&show_dialog=TRUE"
        return URL(string: string)
    }
    
    var isSignIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken : String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let tokenExpirationDate = tokenExpirationDate else {
            return false
        }
        let currentDate = Date()
        // timeInterval = 5 minutes
        let timeInterval : TimeInterval = 300
        return currentDate.addingTimeInterval(timeInterval) >= tokenExpirationDate
    }
    var onRefreshBlocks = [((String) -> Void)]()
    // MARK: -
    public func exchangeCodeForToken (
        code: String,
        completion: @escaping ((Bool) -> Void)
    ) {
        
        guard let url = URL(string: Constant.tokenAPIURL) else { return }
        
        // MARK: - query
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "authorization_code"),
            URLQueryItem(name: "code", value: code),
            URLQueryItem(name: "redirect_uri", value: Constant.redirectURI)
        ]
        // MARK: - request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constant.clientID + ":" + Constant.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure to get base 64")
            completion(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        // MARK: - pass data using url session
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                print("success")
                self?.cacheToken(result: result)
                completion(true )
            }
            catch {
                print(error)
                completion(false)
            }
            
        }
        task.resume()
    }

//    private func refreshToken() {
//
//    }
    
    private func cacheToken(result: AuthResponse) {
        UserDefaults.standard.set(result.access_token, forKey: "access_token")
        if let refreshToken = result.refresh_token {
            UserDefaults.standard.set(refreshToken, forKey: "refresh_token")
        }
        
        UserDefaults.standard.set(Date().addingTimeInterval(TimeInterval(result.expires_in)),
                                  forKey: "expirationDate")

    }
}

// MARK: - supplies valid token to be used with apicall
extension AuthManager {
    public func withValidToken(completion: @escaping (String) -> Void){
        guard !refreshingToken else {
            onRefreshBlocks.append(completion)
            return
        }
        if shouldRefreshToken {
            // TODO: - refresh
            self.refreshAccessToken { [weak self] success in
                if let token = self?.accessToken, success {
                    completion(token)
                }
            }
            
        } else {
            if let token = self.accessToken {
                completion(token)
            }
        }
    }
    
    // MARK: - refresh if needed
    public func refreshAccessToken(completion: ((Bool) -> Void)?){
        guard !refreshingToken else {
            return
        }
        guard shouldRefreshToken else {
            completion?(true)
            return
            
        }
        guard let refreshToken = self.refreshToken else {
            return
        }
        // MARK: - get new token
        guard let url = URL(string: Constant.tokenAPIURL) else { return }
        refreshingToken = true
        // MARK: - query
        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "refresh_token"),
            URLQueryItem(name: "refresh_token", value: refreshToken)
        ]
        // MARK: - request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = components.query?.data(using: .utf8)
        let basicToken = Constant.clientID + ":" + Constant.clientSecret
        let data = basicToken.data(using: .utf8)
        guard let base64String = data?.base64EncodedString() else {
            print("failure to get base 64")
            completion?(false)
            return
        }
        request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
        
        // MARK: - pass data using url session
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion?(false)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(AuthResponse.self, from: data)
                self?.onRefreshBlocks.forEach{ $0 (result.access_token) }
                self?.onRefreshBlocks.removeAll()
                self?.cacheToken(result: result)
                completion?(true )
            }
            catch {
                print(error)
                completion?(false)
            }
            
        }
        task.resume()
    }
}
