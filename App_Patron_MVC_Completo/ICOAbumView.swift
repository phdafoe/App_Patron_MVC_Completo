//
//  ICOAbumView.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 21/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit

class ICOAbumView: UIView {
    
    //añadimos las variables y deberan ser privadas por que nadie fuera de esta clase necesita saber la existencia de estas propiedades que solo se utilizan en la implementacion interna de la clase
    
    //caratula Album representa la portada del album
    private var caratulaAlbumFinal : UIImageView?
    
    //esto se coloca para hacer entender un proceso de descarga
    private var activityIndicator : UIActivityIndicatorView?
    
    //inicializador de la clase
    // este inicializador solo se usa cuando no temos control del StoryBoard, es decir siempre tenemos que AppDelegate determina el arranque de los controladores pero esta clase extiende de UIView y debe ser codificada por NSCoder o clase abstracta
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inicializadorComun()
    }
    
    init(frame: CGRect, caratulaAlbum: String) {
        super.init(frame: frame)
        inicializadorComun()
        
        /****************=========================**********************/
        
        //PATRON NOTIFICACION
        
        //esta linea envia una notificacion a traves de NSnotificacionCenter (singleton) la informacion de dicha notificacion contiene un ImageView (caratulaAlbumFinal) y la direccion url (caratulaAlbum) esta es toda la informacion que necesita para realizar la descraga de las imagenes (esto se lo debemos notificar a ICOLibraryAPI)
        
        NSNotificationCenter.defaultCenter().postNotificationName("ICODescargaImagenesNotificacion",
            object: self,
            userInfo: ["imageView": caratulaAlbumFinal!, "urlCaratula": caratulaAlbum])
        
        
        /****************=========================**********************/
  
    }
    
    //establece esta funcion valores predeterminados para la vista del album, se establece un fondo negro, un pequeño margen de 5 pixeles
    //y se introduce el activity Indicator
    func inicializadorComun(){
        backgroundColor = UIColor.blackColor()
        caratulaAlbumFinal = UIImageView(frame: CGRectMake(5, 5, frame.size.width - 10, frame.size.height - 10))
        addSubview(caratulaAlbumFinal!)
        
        /****************=========================**********************/
        
        //PATRON NOTIFICACION KVO (Key Value Observer)
        //permite que un objeto observe los cambios de una propiedad, en este caso vamos a observar los cambios de "imagen" caracteristica de UIImageView, esto se suma como UNO MISMO al registro como OBSERVADOR a la caracteristica "image" de caratulaAlbumFinal
        caratulaAlbumFinal?.addObserver(self, forKeyPath: "image", options: [], context: nil)
        
        /****************=========================**********************/
        
        
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.center = center
        activityIndicator?.activityIndicatorViewStyle = .Gray
        activityIndicator?.startAnimating()
        addSubview(activityIndicator!)
        
        
        
    }
    
    /****************=========================**********************/
     
     //PATRON NOTIFICACION KVO (Key Value Observer)
    deinit{
        caratulaAlbumFinal?.removeObserver(self, forKeyPath: "image")
    }
    
    /****************=========================**********************/
     
     
    //MARK: - UTILS
     
    //Añadimos esta funcion para que resalte la caratula del album que se haya seleccionado, es decir, esto cambiara el fondo de la caratula a blanco si esta seleccionada y negro cuando no
    func highligthAlbum (didHighlightView view: Bool){
        
        if view{
            backgroundColor = UIColor.whiteColor()
        }else{
            backgroundColor = UIColor.blackColor()
        }
        
    }
    
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        if keyPath == "image"{
            activityIndicator?.stopAnimating()
        }
    }
}






