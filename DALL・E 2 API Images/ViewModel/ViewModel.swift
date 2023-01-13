//
//  ViewModel.swift
//  DALL・E 2 API Images
//
//  Created by Manhattan on 12/01/23.
//

import Foundation
import UIKit

final class ViewModel: ObservableObject {
    private let urlSession: URLSession
    
    private var api_key: String {
        get {
          // 1
          guard let filePath = Bundle.main.path(forResource: "OpenAI-Info", ofType: "plist") else {
            fatalError("Couldn't find file 'OpenAI-Info.plist'.")
          }
          // 2
          let plist = NSDictionary(contentsOfFile: filePath)
          guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'OpenAI-Info.plist'.")
          }
          return value
        }
    }
    
    @Published var imageURL: URL?
    @Published var isLoading: Bool = false
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func generateImage(withText text : String) async {
        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(api_key, forHTTPHeaderField: "Authorization")
        
        let dictionary: [String: Any] = [
            "n": 1,
            "size": "1024x1024",
            "prompt": text
        ]
        
        urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
        
        do {
            DispatchQueue.main.async {
                self.isLoading = true
            }
            let (data, _) = try await urlSession.data(for: urlRequest)
            let model = try JSONDecoder().decode(ModelResponse.self, from: data)
            
            DispatchQueue.main.async {
                self.isLoading = false
                guard let firstModel = model.data.first else {
                    return
                }
                
                self.imageURL = URL(string: firstModel.url)
//                print(self.imageURL ?? "No imageURL")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveImageGallery() {
        guard let imageURL = imageURL else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let data = try! Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                let image = UIImage(data: data)!
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
}
