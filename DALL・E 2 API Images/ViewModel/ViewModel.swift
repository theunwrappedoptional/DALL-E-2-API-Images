//
//  ViewModel.swift
//  DALL・E 2 API Images
//
//  Created by Manhattan on 12/01/23.
//

import Foundation
import UIKit

final class ViewModel: NSObject, ObservableObject {
    private let urlSession: URLSession
    
    private var api_key: String {
        get {
          guard let filePath = Bundle.main.path(forResource: "OpenAI-info", ofType: "plist") else {
            fatalError("Couldn't find file 'OpenAI-info.plist'.")
          }
          let plist = NSDictionary(contentsOfFile: filePath)
          guard let value = plist?.object(forKey: "API_KEY") as? String else {
            fatalError("Couldn't find key 'API_KEY' in 'OpenAI-info.plist'.")
          }
          return value
        }
    }
    
    @Published var imageURL: URL?
    @Published var isLoading: Bool = false
    @Published var saved:Bool = false
    
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
        urlRequest.addValue("Bearer \(api_key)", forHTTPHeaderField: "Authorization")
        
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
                
                guard let firstModel = model.data.first else {
                    return
                }
                
                self.imageURL = URL(string: firstModel.url)
                print(self.imageURL ?? "No imageURL")
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isLoading = false
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveImageGallery() {
        guard let imageURL = self.imageURL else {
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let data = try! Data(contentsOf: imageURL)
            DispatchQueue.main.async {
                let image = UIImage(data: data)!
                UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveError), nil)
            }
        }
    }
    
    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            print("Error while saving")
        } else {
            saved = true
            print("Successfully saved")
        }
    }

}
