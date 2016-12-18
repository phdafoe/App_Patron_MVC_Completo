//
//  ICOPersistencyManager.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 24/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit

class ICOPersistencyManager: NSObject {
    
    //1 -> Aqui declaramos una variable privada no es constante lo que permitirá agregar o eliminiar albumes de musica
    //MARK: - MODEL
    private var albumesDeMusica = [ICOAlbumModel]() //array de objetos del modelo
    
    override init() {
        //2 -> aqui estamos poblando en el inicializador con 5 albumes de musica de muestra
        let album1 = ICOAlbumModel(
            aTituloAlbum: "Best of Bowie",
            aArtista: "David Bowie",
            aGeneroMusical: "Pop",
            aUrlCaratula: "http://www.quantummx.com/www/wp-content/uploads/2016/01/David-Bowie.jpg",
            aAnyoDisco: "1992")
        
        let album2 = ICOAlbumModel(
            aTituloAlbum: "It's my life",
            aArtista: "No Doubt",
            aGeneroMusical: "Pop",
            aUrlCaratula: "http://cdn6.rockinrio.com/usa/wp-content/uploads/sites/8/2014/10/post-blog-no-doubt.jpg",
            aAnyoDisco: "2003")
        
        let album3 = ICOAlbumModel(
            aTituloAlbum: "Nothing Like The Sun",
            aArtista: "Sting",
            aGeneroMusical: "Pop",
            aUrlCaratula: "http://cdn.sting.com/pr/KevinMazur-Lyrics.jpg",
            aAnyoDisco: "1999")
        
        let album4 = ICOAlbumModel(
            aTituloAlbum: "Staring at the Sun",
            aArtista: "U2",
            aGeneroMusical: "Pop",
            aUrlCaratula: "http://nosgustalamusica.com/wp-content/uploads/2014/09/u23.jpg",
            aAnyoDisco: "2000")
        
        let album5 = ICOAlbumModel(
            aTituloAlbum: "American Pie",
            aArtista: "Madonna",
            aGeneroMusical: "Pop",
            aUrlCaratula: "http://elcirculord.com/wp-content/uploads/2015/10/Madonna2.jpg",
            aAnyoDisco: "2000")
        
        albumesDeMusica = [album1,album2, album3, album4, album5]
        
        super.init()
        
    }
    
    //3 -> Debemos añadir 3 metodos que nos permitiran obtener, añadir y borrar albumes
    //MARK: - UTILS
    func getAlbumsMusicales () -> [ICOAlbumModel]{
        return albumesDeMusica
    }
    
    func addAlbumsMusicales (album: ICOAlbumModel, indice: Int){
        if (albumesDeMusica.count >= indice){
            albumesDeMusica.insert(album, atIndex: indice)
            
        }else{
            albumesDeMusica.append(album)
        }
    }
    
    func deleteAlbumsMusicales (indice: Int){
        albumesDeMusica.removeAtIndex(indice)
    }
    
    
    
    //Guardado de Imagenes localmente en el fichero "Documents"
    func salvarLocalmenteImagenes (image: UIImage, fileName: String){
        
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(fileName)")
        let data = UIImagePNGRepresentation(image)
        // si es cierto los datos se escriben en un archivo de copia de seguridad, de ser falso los datos se escriben directamente al camino
        data!.writeToFile(path, atomically: true)
        
    }
    
    //devolvera nil si alguna imagen no se encuentra
    //Habiendo realizado esta persistencia basica en la carpeta Documents vamos a descargar las imagenes el ICOLibraryAPI
    func getImagenesSalvadasLocalmente(fileName: String) -> UIImage? {
        
        var errorInicial : NSError?
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(fileName)")
        let data : NSData?
        
        //let data1 : NSData = NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingUncached, error: errorInicial)
        
        do{
            data = try NSData(contentsOfFile: path, options: NSDataReadingOptions.UncachedRead)
            
        }catch let errorTemporal as NSError{
            
            errorInicial = errorTemporal
            data = nil
        }
        
        if let _ = errorInicial{
            
            return nil
            
        }else{
            
            return UIImage(data: data!)
        }
    }
    
    
    
    
    
    
}
