//
//  NetworkingManager.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import Foundation
import Combine

class NetworkingManager{
    
    // Enum para tratamento de erros
    enum NetworkingError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        // mudando a descrição do erro de acordo com o switch do enum
        var errorDescription: String? {
            switch self {
            case .badURLResponse(url: let url): return "Bad response from URL: \(url)"
            case .unknown: return "Unknown error occured."
            }
        }
    }
    
    // Função genérica para fazer a requisição da API
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
        // colocando na thread background
            .subscribe(on: DispatchQueue.global(qos: .default))
        // transformando o output que deu em Data
            .tryMap({ try handleURLResponse(output: $0, url: url)})
        // depois que pegar essa data, passar pra main
            .receive(on: DispatchQueue.main)
        // transformando em um publisher qualquer para poder retornar nessa func genérica
            .eraseToAnyPublisher()
    }
    
    // Função para tratar a resposta da URL
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        // checando se tá tudo ok
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    // Função genérica para checar a completion
    static func handleCompletion(completion: Subscribers.Completion<Error>){
        // Vendo se deu certo (observando a completion)
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    
    
}
