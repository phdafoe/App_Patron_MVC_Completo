//
//  ICOHorizontalScroller.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 27/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit

//PROTOCOLOS DELEGADOS PROPIOS
//con la palabra reservada "protocol" definimos los metodos que se usaran posteriormente
//Algunos son requeridos y otros son opcionales
protocol ICOHorizontalScrollerDelegate{
    //1
    //pedimos al DELEGADO el numero de elementos que se quieren presentar en la vista
    func numeroVistasEnHorizontalScroller(scroller: ICOHorizontalScroller) -> Int
    //2
    //pedimos al DELEGADO el objeto que debe aparecer segun el indice
    func vistaPorIndiceEnHorizontalScroller(scroller: ICOHorizontalScroller, indice: Int) -> UIView
    //3
    //informar al DELEGADO cuando se haya hecho click en una vista
    func clickEnAlgunaVistaPorIndiceEnHorizontalScroller(scroller: ICOHorizontalScroller, indice: Int)
    //4
    //pedimos al DELEGADO nos muestre la vista inicial del indice (0) este metodo o funcion es opcional y por defecto va a 0 sino esta implementado por el delegado
    func vistaInicialPorIndice(scrolle: ICOHorizontalScroller) -> Int
  
}

class ICOHorizontalScroller: UIView {
    
    //MARK: - VARIBALE DELEGADO
    var icoDelegate = ICOHorizontalScrollerDelegate?()
    
    
    //MARK: - VARIABLES LOCALES GLOBALES
    //1 -> Definimos constantes para que sea facil de modificar el diseño, las dimensiones de la vista seran de 100 x 100 con un margen de 10 puntos de su propio rectangulo que se encierra
    private let VIEW_PADDING = 10
    private let VIEW_DIMENSIONS = 100
    private let VIEW_OFF_SET = 100
    
    //2 -> cremos la vista de desplazamiento que contendra las subVistas
    private var desplazador: UIScrollView!
    
    //3 -> creamos una coleccion que contendra todas las portadas de las vistas
    var miArrayDeVistas = [UIView]() //alloc init
    
    
    
    
    //4 -> inicializadores ya que es una clase abstracta
    override init(frame: CGRect) {
        super.init(frame: frame)
        inicializaScrollView() // metodo propio en UTILS O AUXILIARES
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inicializaScrollView() // metodo propio en UTILS O AUXILIARES
        
    }
    
    //MARK: - UTILS O AUXILIARES
    
    func inicializaScrollView(){
        
        //1 -> cronstruimos un nuevo ScrollView y lo añadimos a la vista
        desplazador = UIScrollView() // alloc init
        addSubview(desplazador)
        
        //2 ->
        desplazador.translatesAutoresizingMaskIntoConstraints = false
        
        
        //3 -> Aplicamos restricciones al ScrollView
        self.addConstraint(NSLayoutConstraint(item: desplazador, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: desplazador, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: desplazador, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: desplazador, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        //4 -> creamos un gesto de reconocimiento (GRIFO) este debe reconocer toques en al pantallaen la vista del scroller o de desplazador, e identifica si se ha aprovechado el objeto de la caratula si es asi le notficara al DELEGADO
        let gestoDeReconocimientoTipoTap = UITapGestureRecognizer(target: self, action: Selector("desplazadorTocado:"))
        desplazador.addGestureRecognizer(gestoDeReconocimientoTipoTap)
        
        // DELEGADO
        desplazador.delegate = self
    }
    
    
    //el gesto se pasa como un parametro que le permite extraer la ubicacion con "locationInView"
    func desplazadorTocado(reconocimientoGestoTap: UITapGestureRecognizer){
        
        let ubicacion = reconocimientoGestoTap.locationInView(reconocimientoGestoTap.view)
        if let delegate = icoDelegate{
            
            //1 -> invocamos el numero de Vistas en Scroller Horizontal en el delegado
            for indice in 0..<delegate.numeroVistasEnHorizontalScroller(self){
                let view = desplazador.subviews[indice]
                if CGRectContainsPoint(view.frame, ubicacion){
                    delegate.clickEnAlgunaVistaPorIndiceEnHorizontalScroller(self, indice: indice)

                    //2 -> centramos la vista en la vista del ScrollView
                    desplazador.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width/2 + view.frame.size.width/2 , y: 0), animated: true)
           
                    break
                    //
                }
            }
        }
    }
    
    //Agregamos la siguiente funcion, para acceder a una cubierta del album de nuestro carrusel de imagenes puestas en e ScrolView
    //simplemente nos devuelve la vista a un indice determinado, posteriormente lo utilizaremos para destacar la portada del disco
    func vistaDelIndiceDelObjeto(indice: Int) -> UIView{
        return miArrayDeVistas[indice]
    }
    
    //debemos recargar nuestro carrusel de imagenes dentro del Scroll Horizontal (esto se parece a reloadData -> TABLEVIEW)
    func recargaDatosDelHorizontalScroller(){
        //1 -> comprobamos si hay "DELEGADO" antes de realizar ninguna carga
        if let delegado = icoDelegate{
            
            //2 -> puesto que estamos limpiando las portadas de discos, tambien es necesario para restablecer el array sino tenemos un monton de vistas que se acumulan
            miArrayDeVistas = []
            let vistas : NSArray = desplazador.subviews
            
            //3 -> retiramos todas las subvistas previamente añadido la vista de desplazador
            for vista in vistas{
                vista.removeFromSuperview()
            }
            //4 -> todas las vistas se colocan a partir del OFF_SET dado (100)
            var valorX = VIEW_OFF_SET
            
            for indice in 0..<delegado.numeroVistasEnHorizontalScroller(self){
                
                //5 -> el Horizontal Scroller pide a su delegado la vista de uno en uno y se los pone uno al lado del otro horizontalmente con el relleno previamente definido
                valorX = valorX + self.VIEW_PADDING
                let vista = delegado.vistaPorIndiceEnHorizontalScroller(self, indice: indice)
                vista.frame = CGRectMake(CGFloat(valorX), CGFloat(VIEW_PADDING), CGFloat(VIEW_DIMENSIONS), CGFloat(VIEW_DIMENSIONS))
                desplazador.addSubview(vista)
                
                //6 -> guardamos la vista del array para haer un seguimiento de todas las vistas en la vista de desplazamiento
                miArrayDeVistas.append(vista)
                
                valorX = valorX + self.VIEW_DIMENSIONS + self.VIEW_PADDING
                
                //7 -> una vez que todas las vistas estan en su lugar esteblecemos el OFF_SET para el desplazador para permitir al usuario desplazarse a traves de todos los albumes
                self.desplazador.contentSize = CGSizeMake(CGFloat(valorX + self.VIEW_OFF_SET), frame.size.height)
                
                //8 -> Horizontal Scroller (LA PROPIA CLASE) -> comprueba si su delefado implementa "vistaInicialPorIndice" esta comprobacion es necesaria debido a que hemos definido que es de tipo "optional dentro del Protocolo" si el delegado no implemeta este metodo por defecto es "0" y establece al desplazador centrar la vista inicial definida por el delegado
                
                if let vistaInicial = icoDelegate?.vistaInicialPorIndice(self){
                    desplazador.setContentOffset(CGPoint(x: CGFloat(vistaInicial) * CGFloat((VIEW_DIMENSIONS + (2 * VIEW_PADDING))), y: 0), animated: true)
                }
            }
        }
    }
    
    // Se llama a una vista cuando se añade a otra vista como subvista, aqui es el momento adecuado para recargar datos
    override func didMoveToSuperview() {
        recargaDatosDelHorizontalScroller()
    }
    
    // Esta es la ultima pieza del rompecabezas que asegura de que el album que estamos viendo siempre en el centro del carrusel de desplazamiento, y es necesario realizar calculos  cuando el usuario arrastra la vista con el desplazamiento del dedo
    
    // Este metodo tiene en cuenta el desplazamiento del "desplazador" y las dimensiones y el relleno de las subvistas actuales con el fin de calcular a distancia de la vista actual del centro, la ultima linea del metodo es que una vez se centra la vista, se le informa al delegado que la vista seleccionada ha cambiado
    
    
    func centrarVistaActualAlbumMusical(){
        
        var puntoCentroFinal = Int(desplazador.contentOffset.x) + (VIEW_OFF_SET / 2) + VIEW_PADDING
        let vistaIndice = puntoCentroFinal / (VIEW_DIMENSIONS + (2 * VIEW_PADDING))
        puntoCentroFinal = vistaIndice * (VIEW_DIMENSIONS + (2 + VIEW_PADDING))
        desplazador.setContentOffset(CGPoint(x: puntoCentroFinal, y: 0), animated: true)
        
        if let delegate = icoDelegate{
            delegate.clickEnAlgunaVistaPorIndiceEnHorizontalScroller(self, indice: Int(vistaIndice))
        }
    }
}


extension ICOHorizontalScroller: UIScrollViewDelegate{
    //1 -> informa al delegado cuando el usuario termina arrastrando, el parametro desacelarar es verdadero si la vista no se llegado a parar completamente, cuando la ccion de desplazamiento termina se centrará la vista actual y por ultimo debemos establecer el "delegado" -> dentro de "inicializaScrollView"
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            centrarVistaActualAlbumMusical()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centrarVistaActualAlbumMusical()
    }
}










