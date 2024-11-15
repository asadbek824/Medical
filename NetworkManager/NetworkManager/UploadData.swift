//
//  UploadData.swift
//  NetworkManager
//
//  Created by Azizbek Musurmonov   on 12/06/24.
//

import UIKit

public extension NetworkService {

    // Function to upload an image to your server (async/await with error handling)
    func uploadImage(image: UIImage, toURL url: URL) async throws {

        // 1. Encode the image as PNG data
        guard let imageData = image.pngData() else {
            throw UploadError.encodingFailed
        }

        // 2. Create a URLRequest
        var request = URLRequest(url: url)
        request.httpMethod = "POST" // Or "PUT" depending on your server API

        // 3. Set the Content-Type header
        request.setValue("image/png", forHTTPHeaderField: "Content-Type")

        // 4. Create a task with URLSession
        let (_, response) = try await URLSession.shared.upload(for: request, from: imageData)

        // 5. Handle the response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw UploadError.invalidResponse
        }

        // Check for successful upload (HTTP status code 200 or 201)
        if (200..<300).contains(httpResponse.statusCode) {
            print("Image uploaded successfully!")
        } else {
            throw UploadError.uploadFailed(statusCode: httpResponse.statusCode)
        }
    }

    // Custom error type for upload errors
    enum UploadError: Error {
        case encodingFailed
        case invalidResponse
        case uploadFailed(statusCode: Int)
    }

    // Example Usage
//    let myImage = UIImage(named: "myImage") // Assuming you have an image named "myImage" in your project
//    let uploadURL = URL(string: "https://your-server.com/api/upload")! // Replace with your server's upload endpoint
//
//    if let myImage = myImage {
//        do {
//            try await uploadImage(image: myImage, toURL: uploadURL)
//        } catch {
//            print("Error uploading image: \(error.localizedDescription)")
//        }
//    }
}
