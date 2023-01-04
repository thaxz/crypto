//
//  LocalFileManager.swift
//  Crypto
//
//  Created by thaxz on 04/01/23.
//

import Foundation
import SwiftUI

class LocalFileManager{
    
    static let shared = LocalFileManager()
    private init () { }
    
    // Salvando imagens para o file manager
    func saveImage(image: UIImage, imageName: String, folderName: String){
        createFolderIfNeeded(folderName: folderName)
        // transformando a imagem em data, pq o FM só aceita data
        // e pegando o path
        guard
            let data = image.pngData(),
            let url = getURLForImage(imageName: imageName, folderName: folderName)
        else {return}
        // salvando imagem nesse path
        do {
            try data.write(to: url)
        } catch let error {
            print("error saving image. ImageName: \(imageName) \(error)")
        }
    }
    
    //Criando a pasta, se for necessário
    private func createFolderIfNeeded(folderName: String){
        guard let url = getURLFromFolder(folderName: folderName) else {return}
        // se não existir, cria
        // MARK: - se der erro é aqui esse pathExtension ao invés de só path
        if !FileManager.default.fileExists(atPath: url.path){
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory. FolderName: \(folderName). Error: \(error)")
            }
        }
    }
    
    // Pegando as imagens salvas
    func getImage(imageName: String, folderName: String) -> UIImage? {
        guard
            let url = getURLForImage(imageName: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path)
        else {return nil}
        return UIImage(contentsOfFile: url.pathExtension)
    }
    
    // Pegando a url da pasta de onde vai salvar
    private func getURLFromFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {return nil}
        return url.appendingPathComponent(folderName)
    }
    
    // Onde vai salvar a imagem em si
    private func getURLForImage(imageName: String, folderName: String) -> URL?{
        guard let folderUrl = getURLFromFolder(folderName: folderName) else {return nil}
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
    
    
}
