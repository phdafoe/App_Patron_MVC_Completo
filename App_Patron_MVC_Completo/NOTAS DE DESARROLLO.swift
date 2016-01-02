//
//  NOTAS DE DESARROLLO.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 21/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//


/***************===================================================*********************/

                                //FASE 1 DE PROYECTO

/***************===================================================*********************/


/*
    Proceso de desarrollo de esta aplicacion, en dondes conoceremos los patrones de diseño de cocoa mas comunes

1. Creacional -> Singleton
2. Estructural -> MVC, decorador, Adaptador, Fachada
3. Comportamiento -> Observador y Memento

Siempre que se crea un proyecto nuevo en Xcode en su codigo ya esta implemetandose los patrones de diseño
MVC, Delegado, Singleton etc

1. Para empezar debemos crear dos clases, una para "conservar" y otra para "mostrar" los datos del album
    -> esta es la clase ICOAlbumModel que tiene 5 variables y un constructor o inicializador designado
2. Crearemos la clase ICOAlbumView que extiende UIView
    -> aqui dentro declaramos dos variables y es necesarios escribir los inicializadores de esa clase 
    -> implementar una funcion inicializadorComun()

MVC EL REY
1. Modelo: -> el objeto que contiene los datos de la aplización y define como manipularlo (ICOAlbumModel)
2. Vista: -> los objetos que estan a cargo de la representacion visual del modelo y de los controles con el que el usuario puede interactuar (ICOAlbumView)
3. Controlador: -> es la clase mediadora que coordina todo el trabajo, este accede a los datos del modelo y la muestra de manera sincronizada en la vista, escucha los eventos y manipula los datos segun sea necesario (ViewController)

COMO USAR EL PATRON MVC



1. PATRON SINGLETON
    -> garantiza que solo exista "una instancia de una clase determinada" y por lo general utiliza una carga lenta por lo que solo es necesario utilizarla la primera vez (para entenderlo es como tener un fichero de configuracion con todos lo parametros posibles y no tener un fichero de configuracion por cada parametro es costoso a nivel de recurso computaiconal y de gestion de programacion)
    -> Vamos a implementar este patron mediante la creacion de una clase Singleton para gestionar todos los datos del Album
    -> Si usamos mal los singleton podriamos tener un codigo absolutamente inmanejable, pero si se usa bien es una herramienta bastante util
    -> "SOLO PUEDE HABER UNO" (PARA AHORRAR MEMORIA)
    -> default, standard, shared (la convecion de nomenclatura de COCOA) es decir siempre que veas un metodo de clase que inicie con estas palabras nos quiere decir que en el fondo es un "singleton"
2. Creamos pues dos clases dentro de una carpeta que se llamara API
    1. LibraryAPI (NSObject)
    2. PersistencyManager (NSObject)



PATRON DE DISEÑO FACHADA
1. Aqui le damo razon de ser tanto a LibraryAPI como a PersistencyManager
Actualmente tenemos "PersistencyManager" para guardar los datos del album a nivel local y HTTPClient de manera remota, las otras clases del proyecto no deben ser concientes de esta logica, ya que se esconden tras la fachada de LibraryAPI, para implementar este modelo solo LibraryAPI debe mantener instancias de "PersistencyManager y HTTPCLient, por tanto LibraryAPI expondra una API simple apara cceder a esos servicios
2. Debemos implemetar variables y metodos dentro de LibraryAPI




PATRON DECORADOR O DISEÑO
1. Este patron añade dinamicamente resposabilidades a un objeto sin modificar su codigo, (EXTENSIONES, DELEGADO)
    -> EXTENSIONES: es un potente mecanismo que permite añadir nuevas funcionalidades de clases existentes, estructuras, enumeraciones, pero ademas se puede extender codigo al cual no tenemos acceso y mejorar la funcionalidad.
2. Como Utiliar extensiones
    -> imaginemos que tenemos un album musical de objeto dentro de nuestro modelo y deseo presentar dicha informacion denro de una vista de tabla

3. DELEGACION -> este patron actua en "nombre de" o en "coordinacion con" 

4. Añadimos extensiones siempre despues de terminar la clase y nos saldran errores pues el compilador para poder continuar nos dira que necesita los metodos de data source para continuar, esto se escribe en el controlador que es el gestor, administrador y sincronizador de la lista de objetos




/***************===================================================*********************/
                               
                                        //FASE 1 DE PROYECTO

/***************===================================================*********************/

PATRON DE DISEÑO ADAPTADOR
1. vamos a construir un desplazador Horizontal y va a tener la arquitectura de un table View con delegados propios
    -> debemos crear una clase ICOHorizontalScroller que contendra protocolos propios Delegados para su posterior implementacion y extiende de UIView, por tanto deberia estar dentro de la carpeta "VIEW"
2. ya habiendo contruido nuestro propio componente ICOHorizontalScroller debemos implementar los metodos delegados dentro del ViewController y asi podemos ver el trabajo realizado anteriormente en la clase ICOHorizontalScroller, pero eso no quiere decir que esta completo aun, por que vamos a ver que las imagenes no se estan cargando, peri si que vemos el contenedor de dicha portadas y el UIActivityIndicator, es cierto que aun no se implementa el codigo para descargar las portadas todavia, para hacer eso tenemos que tener una manera de descargar imagenes, dado que todo el acceso a los servicios pasa por ICOLIbraryAPI.
    2.1 ICOAlbumView no debe trabajar directamente con ICOLibraryAPI, no debemos mezclar vista logica con la logica de la comunicacion (OJO)
    2.2 por la misma razon ICOLibraryAPI no debe saber de ICOAlbumView
    2.3 ICOLibraryAPI necesita informar a ICOAlbumView una vez que las portadas de los dicos hayan sido descargargadas desde ICOAlbumView ya que este tiene el cometido de enseñarmelas, para eso usamos el PATRON OBSERVADOR


PATRON OBSERVADOR (NOTIFICACIONES)

1. en este patron un objeto "notifica" a otros objetos de cualquier cambio de estado, los objetos involucrados no necesitan saber el uno del otro, favoreciendo haciendo un diseño desacoplado.
2. COCOA -> implementa el patron observador de dos formas 
    1. Notificaciones
    2. Observacion de Key-Value (MKV) -> proceso automatizado de notificaciones

PATRON NOTIFICAIONES

esto no debemos confundirlo con push Notification (locales o remotas -> CMS), el patron de NOTIFICACIONES se basan en un modelo de subscripcion y publicacion para enviar mensajes a otros objetos (los abonados/los oyentes)
-> Un ejemplo de la utilizacion de Notificaciones en Apple es cunado se muestre el teclado y ocultarlo el sistema envia una
    "UIKeyboardWillShowNotification/UIkeyboardWillHideNotification"
-> otro ejemplo es cuando se pasa a un segundo plano el sistema envia un
    "UIApplicationDidEnterBackgroundNotification"
1. debemos ir ICOAlbumView y meter la notificacion al final del ini(frame: caratula:)
2. debemos notificar a la clase ICOLibraryAPI y darle de baja como observador
3. Ademas vamos a guardar las imagenes de manera local con una persistencia basica
4. y despues a la funcion que nos comunica la notificacion es la que nos dara las imagenes que primero se descargara mandera asincrona y despues nos mostrara las imagenes que se ha descargado localmente por tanto no notariamos lentitud en la visualizacion de las imagenes
5. vemos tambien qie el Activity Indicator no para pues usaremos otra NOTIFICAION eso lo notificamos en ICOAlbumView













*/
