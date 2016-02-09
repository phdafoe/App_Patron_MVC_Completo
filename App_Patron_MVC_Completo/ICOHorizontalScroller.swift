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
    var icoDelegate : ICOHorizontalScrollerDelegate?
    
    
    //MARK: - VARIABLES LOCALES GLOBALES
    //1 -> Definimos constantes para que sea facil de modificar el diseño, las dimensiones de la vista seran de 100 x 100 con un margen de 10 puntos de su propio rectangulo que se encierra
    private let VIEW_PADDING = 10
    private let VIEW_DIMENSIONS = 100
    private let VIEW_OFF_SET = 100
    
    //2 -> cremos la vista de desplazamiento que contendra las subVistas
    private var desplazador: UIScrollView!
    
    //3 -> creamos una coleccion que contendra todas las portadas de las vistas
    var miArrayDeVistas = [UIView]() //alloc init

    //4 -> inicializador ya que es una clase abstracta
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        inicializaScrollView() // metodo propio en UTILS O AUXILIARES
        
    }
    
    /*override init(frame: CGRect) {
        super.init(frame: frame)
        inicializaScrollView() // metodo propio en UTILS O AUXILIARES
    }*/
    
    //MARK: - UTILS O AUXILIARES
    func inicializaScrollView(){
        
        //1 -> cronstruimos un nuevo ScrollView y lo añadimos a la vista Padre
        desplazador = UIScrollView() // alloc init
        addSubview(desplazador)
        
        //2 -> apagamos el tamaño automatico de mascaras, para poder aplicar nuestras propias limitaciones o constrains
        desplazador.translatesAutoresizingMaskIntoConstraints = false
        
        
        //3 -> Aplicamos restricciones al ScrollView
        self.addConstraint(NSLayoutConstraint(item: desplazador, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: desplazador, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: desplazador, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1.0, constant: 0.0))
        
        self.addConstraint(NSLayoutConstraint(item: desplazador, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0))
        
        //4 -> creamos un gesto de reconocimiento (GRIFO) este debe reconocer toques en al pantallaen la vista del scroller o de desplazador, e identifica si se ha aprovechado el objeto de la caratula si es asi le notificara al DELEGADO
        let gestoDeReconocimientoTipoTap = UITapGestureRecognizer(target: self, action: Selector("desplazadorTocado:"))
        desplazador.addGestureRecognizer(gestoDeReconocimientoTipoTap)
        
        
        
        // DELEGADO ESTO ES LO ULTIMO
        desplazador.delegate = self
    }
    
    
    //el gesto se pasa como un parametro que le permite extraer la ubicacion con "locationInView"
    func desplazadorTocado(reconocimientoGestoTap: UITapGestureRecognizer){
        
        //Devuelve el punto calculado como la ubicación en una vista determinada del gesto representado por el receptor.Un punto en el sistema de coordenadas local de vista que identifica la ubicación del gesto. Si nil se especifica para la vista , el método devuelve la ubicación gesto en la base de la ventana del sistema de coordenadas.
        let ubicacion = reconocimientoGestoTap.locationInView(reconocimientoGestoTap.view)
        
        if let delegate = icoDelegate{
            
            //1 -> invocamos el numero de Vistas en Scroller Horizontal en el delegado, este no tiene informacion lo unico que sabemos es que con seguridad entiende este mensaje(OBJ-C)
            
            for indice in 0..<delegate.numeroVistasEnHorizontalScroller(self){
                
                //por cada vista en la vista del desplazador
                let view = desplazador.subviews[indice]
                
                //comprobacion  de exito para saber si se ha encontrado algo en el instante que se ha pulsado en la pantalla sobre una imagen
                if CGRectContainsPoint(view.frame, ubicacion){
                    
                    delegate.clickEnAlgunaVistaPorIndiceEnHorizontalScroller(self, indice: indice)

                    //2 -> centramos la vista en la vista del ScrollView
                    //Establece el desplazamiento desde el origen de la vista de contenido que corresponde al origen del receptor.
                    //El frame, que describe ubicación y el tamaño de la vista en el sistema de coordenadas de su supervista .
                    
                    /*desplazador!.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2 , y: 0), animated: true)*/
                    
                    desplazador.setContentOffset(CGPoint(x: view.frame.origin.x - self.frame.size.width / 2 + view.frame.size.width / 2 , y: 0), animated: true)
           
                    //break
                    
                }
            }
        }
    }
    
    //Agregamos la siguiente funcion, para acceder a una cubierta del album de nuestro carrusel de imagenes puestas en el ScrollView
    //simplemente nos devuelve la vista a un indice determinado, posteriormente lo utilizaremos para destacar la portada del disco
    func vistaDelIndiceDelObjeto(indice: Int) -> UIView{
        
        
        if miArrayDeVistas.count > indice{
            
            return miArrayDeVistas[indice]
            
        }else{
            
            return miArrayDeVistas[miArrayDeVistas.count - 1]
        }
        
    }
    
    
    //debemos recargar nuestro carrusel de imagenes dentro del Scroll Horizontal (esto se parece a reloadData -> TABLEVIEW)
    func recargaDatosDelHorizontalScroller(){
        
        //1 -> comprobamos si hay "DELEGADO" antes de realizar ninguna carga
        if let delegado = icoDelegate{
            
            //2 -> puesto que estamos limpiando las portadas de discos, tambien es necesario para restablecer el array sino tenemos un monton de vistas que se acumulan
            miArrayDeVistas = []
            let vistas : NSArray = desplazador!.subviews
            
            
            //3 -> retiramos todas las subvistas previamente añadido la vista de desplazador
            for vista in vistas{
                vista.removeFromSuperview()
            }
            
            //4 -> Valorx es el punto de partida de las vistas al interior del desplazador
            var valorX = VIEW_OFF_SET
            
            for indice in 0..<delegado.numeroVistasEnHorizontalScroller(self){
                
                //5 -> el Horizontal Scroller pide a su delegado la vista de uno en uno y se los pone uno al lado del otro horizontalmente con el relleno previamente definido -> añadimos una vista a la posicion de la derecha
                
                valorX += VIEW_PADDING
                
                let vista = delegado.vistaPorIndiceEnHorizontalScroller(self, indice: indice)
                vista.frame = CGRectMake(CGFloat(valorX), CGFloat(VIEW_PADDING), CGFloat(VIEW_DIMENSIONS), CGFloat(VIEW_DIMENSIONS))
                desplazador.addSubview(vista)
                
                //6 -> guardamos la vista del array para hacer un seguimiento de todas las vistas en la vista de desplazamiento
                miArrayDeVistas.append(vista)
                
                valorX += VIEW_OFF_SET + VIEW_PADDING
                
                //7 -> Una vez que todos los puntos de vista están en su lugar , establecer el contenido de desplazamiento por la vista de desplazamiento para permitir al usuario desplazarse por todas las portadas álbumes // Aqui limitamos el estiramiento del escroller y le digo que como maximo  tope debe tener 100 puntos de OFFSET
                //contentSize -> ANCHO Y ALTO
                self.desplazador.contentSize = CGSizeMake(CGFloat(valorX  + self.VIEW_OFF_SET) , frame.size.height)
                
                
                
                //8 -> Horizontal Scroller (LA PROPIA CLASE) -> comprueba si su delegado implementa "vistaInicialPorIndice" esta comprobacion es necesaria debido a que hemos definido que es de tipo "optional dentro del Protocolo" si el delegado no implemeta este metodo por defecto es "0" y establece al desplazador centrar la vista inicial definida por el delegado
                if let vistaInicial = icoDelegate?.vistaInicialPorIndice(self){
                    
                    desplazador!.setContentOffset(CGPoint(x: CGFloat(vistaInicial) * CGFloat((VIEW_DIMENSIONS + (2 * VIEW_PADDING))), y: 0), animated: true)

                    //desplazador.setContentOffset(CGPoint(x: CGFloat(vistaInicial), y: 0), animated: true)
                }
            }
        }
    }
    
    
    //Cuando los datos hayan cambiado
    // Se llama a una vista cuando se añade a otra vista como subvista, aqui es el momento adecuado para recargar datos
    override func didMoveToSuperview() {
        recargaDatosDelHorizontalScroller()
    }
    
    // Esta es la ultima pieza del rompecabezas que asegura de que el album que estamos viendo siempre en el centro del carrusel de desplazamiento, y es necesario realizar calculos  cuando el usuario arrastra la vista con el desplazamiento del dedo

    
    func centrarVistaActualAlbumMusical(){
        
        // Este metodo tiene en cuenta el desplazamiento del "desplazador" y las dimensiones y el relleno de las subvistas actuales con el fin de calcular la distancia de la vista actual del centro -> contentOffset solo tiene "X"  "Y"
                                                                    //50 le coloco esto para que cuando haga el scroll en el eje horizontal, me mantenga un limite maximo de 70 puntos en el momento de centrar la imagen y nunca deberia pasar lo que le he metido en OFF_SET
        
        var puntoCentroFinal = Int(desplazador.contentOffset.x) + VIEW_OFF_SET / 2
        
                                    // 50  / 100 + 20 -> .5 le coloco esto para asegurarme que la vista va a centrarse  en el plano de coordenadas justo en la mitad un poco menos del rango del array de objetos total de un lado y de otro
        let vistaIndice = puntoCentroFinal / (VIEW_OFF_SET + (2 * VIEW_PADDING))
        
                                    // 50  *  100 + 20 -> .7 -> aqui me aseguro que el rango sea ligeramente superior
        puntoCentroFinal = vistaIndice * (VIEW_OFF_SET + (2 * VIEW_PADDING))
        
        desplazador.setContentOffset(CGPoint(x: puntoCentroFinal, y: 0), animated: true)
        
        
        //la ultima linea del metodo es que una vez se centra la vista, se le informa al delegado que la vista seleccionada ha cambiado
        if let delegate = icoDelegate{
            delegate.clickEnAlgunaVistaPorIndiceEnHorizontalScroller(self, indice: Int(vistaIndice))
        }
    }
}


//para detectar que el usuario termina el arrastre dentro de la vista de desplazamiento, tenemos que extender metodos delegados de ScrollViewDelegate

extension ICOHorizontalScroller: UIScrollViewDelegate{
    
    //1 -> informa al delegado cuando el usuario termina arrastrando, el parametro desacelarar es verdadero si la vista no se llegado a parar completamente, cuando la accion de desplazamiento termina se centrará la vista actual y por ultimo debemos establecer el "delegado" -> dentro de "inicializaScrollView"
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate{
            centrarVistaActualAlbumMusical()
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        centrarVistaActualAlbumMusical()
    }
}










