//
//  URLSessionHTTPClient.swift
//  Weatherly
//
//  Created by Hu Qiushi on 2026/11/25.
//

import OSLog
import Foundation

struct URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func send<Response>(_ endpoint: Endpoint) async throws -> Response where Response : Decodable {
        let request = try makeRequest(from: endpoint)
        AppLogger.network.debug("→ \(endpoint.method.rawValue, privacy: .public) \(endpoint.path, privacy: .public)")
        
        
        do {
            let (data, response) = try await session.data(for: request)
            
#if DEBUG
            AppLogger.network.debug("URL: \(request.url?.absoluteString ?? "nil", privacy: .public)")
            AppLogger.network.debug("Body: \(String(decoding: data.prefix(2000), as: UTF8.self), privacy: .public)")
#endif
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw AppError.unknown
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                throw AppError.server(
                    statusCode: httpResponse.statusCode
                )
            }
            
            do {
                let response  = try JSONDecoder().decode(
                    Response.self,
                    from: data
                )
                print("response", response)
                return response
            } catch {
                throw AppError.decoding
            }
        } catch let error as AppError {
            throw error
        } catch is CancellationError {
            throw CancellationError()
        } catch let error as URLError {
            switch error.code {
            case .cancelled:
                throw CancellationError()
            case .notConnectedToInternet,
                    .networkConnectionLost,
                    .dataNotAllowed:
                throw AppError.offline
            case .timedOut:
                throw AppError.timeout
            default:
                throw AppError.unknown
            }
        } catch {
            throw AppError.unknown
        }
        
    }
    
    private func makeRequest(from endpoint: Endpoint) throws -> URLRequest {
        guard var components = URLComponents(url: endpoint.baseURL, resolvingAgainstBaseURL: false) else {
            throw AppError.unknown
        }
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems.isEmpty ? nil : endpoint.queryItems
        
        guard let url = components.url else { throw AppError.unknown }
        
        var request = URLRequest(url: url, timeoutInterval: 15)
        request.httpMethod = endpoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        endpoint.headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return request
    }
}
