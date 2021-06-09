(define (domain dominio_ejercicio7)
    (:requirements :adl :typing :strips :fluents)
    
    ;TIPOS --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:types                                                 ;TIPOS
        localizacion elementos recurso - object                 ; Distinguiremos principalmente entre localizaciones, unidades y edificios a lo que llamaremos elementos, y recusos (minerales y gases)
        unidad edificio - elementos                             ; Definimos que los elementos son las unidades y los edificios
        tipoUnidad - unidad
        tipoEdificio - edificio
        tipoRecurso - recurso
    )
    
    ;CONSTANTES ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:constants                                             ;CONSTANTES
        vce marines segadores - tipoUnidad                                            ; Las unidades las conoceremos como VCE
        centroDeMando barracones extractor - tipoEdificio                     ; Podemos tener dos tipos de edificios: los contres de Mando y los barracones que también definiremos como constantes
        minerales gas - tipoRecurso                                 ; Dentro de los recursos distinguimos minerales y gase Vespeno
    
    )
    
    ;PREDICADOS ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:predicates                                            ;PREDICADOS
        (En ?c - elementos ?l - localizacion)                   ; Determinar si un edificio o unidad está en una localización concreta
        (CaminoEntre ?l1 ?l2 - localizacion)                    ; Representar que existe un camino entre dos localizaciones
        (Construido ?e - edificio ?l - localizacion)                              ; Determinar si un edificio está construido
        (AsignaNodo ?r - tipoRecurso ?l - localizacion)             ; Asignar un nodo de un recurso concreto a una localizacion concreta
        (Extrayendo ?u - unidad ?r - tipoRecurso)                   ; Indicar si un VCE está extrayendo un recurso
        (obtenerRecurso ?r - tipoRecurso)                           ; Crearemos aparte un predicado llamado obtenerRecurso. Este lo usaremos para saber si un recurso ha sido o se está extrayendo. Este será el objetivo (goal) del ejercicio
        (AsignaUnidadARecurso ?u - unidad ?tr - tipoRecurso)
        (UnidadEs ?u - unidad ?tu - tipoUnidad)
        (RecursoEs ?r - recurso ?tr - tipoRecurso)
        (EdificioEs ?e - edificio ?te - tipoEdificio)
        (RecursoParaEdificio ?tr - tipoRecurso ?te - tipoEdificio)
        (TipoDeRecurso ?tr1 - tipoRecurso ?tr2 - tipoRecurso)
        (RecursoParaUnidad ?tr - tipoRecurso ?tu - tipoUnidad)
        (ReclutadoEn ?tu - tipoUnidad ?te - tipoEdificio)
        (UnidadAsignada ?u - unidad) 
        (UnidadReclutada ?u - unidad ?l - localizacion)
        (Recolectar ?r - recurso)
    )                                                   
    
    ;FUNCIONES -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:functions
        (limiteRecurso ?tr - tipoRecurso)
        (cantidadRecurso ?tr - tipoRecurso)
        (cantidadRecursoNecesario ?c - elementos ?tr - tipoRecurso)
        (cantidadUnidadesExtrayendo ?tr - tipoRecurso)

        (velocidadUnidad ?tu - tipoUnidad)
        (tiempoConsumidoUnidad ?tu - tipoUnidad)
        (tiempoConsumidoEdificio ?te - tipoEdificio)
        (TiempoTotal)
    )
    
    ;ACCIONES -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   
    ;NAVERGAR:
        ; Mueve a una unidad entre dos localizaciones.
    (:action Navegar
    
        :parameters (?u - unidad ?origen ?destino - localizacion)
        
        :precondition (and 
                        (En ?u ?origen)                         ; La única precondicion necesaria es que la unidad se encuentre en la localización de origen
                        (caminoEntre ?origen ?destino)
                        (not (UnidadAsignada ?u))
                        )   
        :effect (and                                            ; La finalidad de la acción será que:
                    (En ?u ?destino)                                ; La unidad se encuentre en la localización de destino
                    (not (En ?u ?origen))                           ; Y también tenemos que declarar que la unidad ya no se encuentra en la localización de origen

                    (when (UnidadEs ?u vce)
                        (increase (TiempoTotal)
                            (velocidadUnidad vce)
                        )
                    )  

                    (when (UnidadEs ?u marines)
                        (increase (TiempoTotal)
                            (velocidadUnidad marines)
                        )
                    )  

                    (when (UnidadEs ?u segadores)
                        (increase (TiempoTotal)
                            (velocidadUnidad segadores)
                        )
                    )  
            )
                     
    )
    
    
    ;ASIGNAR:
        ; Asigna un VCE a un nodo de recurso. Por simplicidad en esta práctica, un VCE asignado a un nodo de recurso ya no podrá hacer nada más el resto de la ejecución
        ; puesto que no se implementará ninguna acción para desasignarlo. Además, en este ejercicio será suficiente asignar un único VCE a un nodo de recursos de 
        ; un tipo (minerales o gas vespeno) para tener ilimitados recursos de ese tipo
	(:action Asignar
	
	    :parameters (?u - unidad ?loc_recurso - localizacion ?tr - tipoRecurso)
	    
	    :precondition (and
	                    (En ?u ?loc_recurso)                   ; Entendemos que la unidad debe estar en el lugar donde se encuentra el recurso para poder extraerlo  (Si no están en la misma localización, el programa llamará a Navegar)
						(UnidadEs ?u vce)
						(not (Extrayendo ?u ?tr))
						(AsignaNodo ?tr ?loc_recurso)
						
						(imply 
						    (AsignaNodo gas ?loc_recurso)
						    
						       (exists (?e - edificio)
                                    (and
                                        (En ?e ?loc_recurso)
                                        (EdificioEs ?e extractor )
                                    )
						        )
						    
						)
						(UnidadEs ?u vce)
						(not (UnidadAsignada ?u))
						
					)

	    :effect (and                                           ; El resultado de esta acción será:
	                (Extrayendo ?u ?tr)                              ; Primero declararemos que la unidad está extrayendo el recurso
				    (obtenerRecurso ?tr)                             ; Y luego, declararemos que ese recurso ya sido extraído (de forma quealcanzaríamos nuestro objetivo)
				    (UnidadAsignada ?u)

                    (increase(cantidadUnidadesExtrayendo ?tr) 1)
				    
				)
	)

;Construir: 
	    ; Ordena a un VCE libre que construya un edificio en una localización. 
	    ; En este ejercicio, cada edificio sólo requerirá un único tipo de recurso para ser construido.
	    ; Adicionalmente y por simplicidad, en este ejercicio se permite que existan varios edificios en la misma localización.
	(:action Construir
	    
	    :parameters (?u - unidad ?e - edificio ?l - localizacion )
	    
	    :precondition (and 
                       
                     (En ?u ?l) 

                    (forall (?r - tipoRecurso)
                        (not (Extrayendo ?u ?r))
                    )

                    (not (exists (?e2 - edificio)
                        (En ?e2 ?l))
                    )

                    (forall (?r - tipoRecurso)
					
                        (exists (?te - tipoEdificio)
                            (and
                                
                                (EdificioEs ?e ?te)
                                
                                (imply (RecursoParaEdificio ?r ?te) 
                                    (and
                                     (exists (?u2 - unidad) 
                                            (and
                                                (Extrayendo ?u2 ?r) 
                                                (UnidadEs ?u2 vce)
                                            )
                                            
                                        )
                                   ;  (>= (cantidadRecurso ?r) (cantidadRecursoNecesario ?te ?r))
                                    )
                                       
                                )
                                (imply
                                    (RecursoParaEdificio ?r ?te)
                                    (>= (cantidadRecurso ?r) (cantidadRecursoNecesario ?te ?r))
                                    
                                )
                            )
                        )
                    )
                    (UnidadEs ?u vce)
                    (forall (?l2 - localizacion)
                        (not (Construido ?e ?l2))
                    )

                    (not (UnidadAsignada ?u))
                
                    
                    
        )
	    
	    :effect (and 
                    (Construido ?e ?l)                 ; Finalmente el edificio es construido y debe declararse como tal
                    (En ?e ?l)                      ; Además, se asigna la localización donde se construye el edificio

                    (when (EdificioEs ?e barracones)
                        (and
                            (decrease (cantidadRecurso gas) 
                                (cantidadRecursoNecesario barracones gas)
                            )
                            (decrease (cantidadRecurso minerales) 
                                (cantidadRecursoNecesario barracones minerales)
                            )
                            (increase (TiempoTotal) 
                                (tiempoConsumidoEdificio barracones)
                            )
                        )
                    )

                    (when (EdificioEs ?e extractor)
                        (and
                            (decrease (cantidadRecurso gas) 
                                (cantidadRecursoNecesario extractor gas)
                            )
                            (decrease (cantidadRecurso minerales) 
                                (cantidadRecursoNecesario extractor minerales)
                            )
                            (increase (TiempoTotal) 
                                (tiempoConsumidoEdificio extractor)
                            )
                        )
                    )

                    
        )
	    
	    
	)
	
	(:action Reclutar
        :parameters (?e - edificio ?u - unidad ?l - localizacion)

        :precondition (and 
            (forall (?l2 - localizacion)
                (not (En ?u ?l2))
            )
            (exists (?tu - tipoUnidad )
               
                (and
                    (forall (?r - tipoRecurso )
                        (and
                        
                            (UnidadEs ?u ?tu)
                        
                            (imply 
                                (RecursoParaUnidad ?r ?tu) 
                                    (exists (?u2 - unidad ?l2 - localizacion) 
                                    (and
                                        (Extrayendo ?u2 ?r) 
                                        (unidadEs ?u2 vce)
                                        (En ?u2 ?l2)
                                    )
                                )
                            )
                            
                            (exists ( ?te - tipoEdificio )        
                                        (and 
                            ;               (UnidadEs ?u ?tu)
                                            (ReclutadoEn ?tu ?te)                
                                            (EdificioEs ?e ?te)
                                        ;   (En ?e ?l)
                                            (Construido ?e ?l)
                                          (imply
                                             (RecursoParaEdificio ?r ?te)
                                             (>= (cantidadRecurso ?r) (cantidadRecursoNecesario ?te ?r))
                                             
                                         )
                                                                    
                                        )
                            )
                        )
                    )

                     
                   
                )
                

            )
           ; (exists (?u3 - unidad )
         ;   (and
                ;(UnidadEs ?u3 vce)
          ;      (Construido ?e ?l)
            ;    (En ?u3 ?l2)
         ;   )
                
           ; )
                    


        )
        :effect (and 
                    (En ?u ?l)

                    (when (UnidadEs ?u vce)
                        (and
                            (decrease (cantidadRecurso gas) 
                                (cantidadRecursoNecesario vce gas)
                            )
                            (decrease (cantidadRecurso minerales) 
                                (cantidadRecursoNecesario vce minerales)
                            )
                            (increase (TiempoTotal) 
                                (tiempoConsumidoUnidad vce)
                            )
                        )
                    )

                    (when (UnidadEs ?u marines)
                        (and
                            (decrease (cantidadRecurso gas) 
                                (cantidadRecursoNecesario marines gas)
                            )
                            (decrease (cantidadRecurso minerales) 
                                (cantidadRecursoNecesario marines minerales)
                            )
                            (increase (TiempoTotal) 
                                (tiempoConsumidoUnidad marines)
                            )
                        )
                    )

                    (when (UnidadEs ?u segadores)
                        (and
                            (decrease (cantidadRecurso gas) 
                                (cantidadRecursoNecesario segadores gas)
                            )
                            (decrease (cantidadRecurso minerales) 
                                (cantidadRecursoNecesario segadores minerales)
                            )
                            (increase (TiempoTotal) 
                                (tiempoConsumidoUnidad segadores)
                            )
                        )
                    )
                        
                    
                )
        )

    
	(:action Recolectar
        :parameters (?tr - tipoRecurso ?l - localizacion)

        :precondition (and 
            (exists (?u - unidad )               ;Existe una unidad que extrae el recurso. Sólo habrá una asignada a ese recurso, ya que, una vez asignada, esta no puede hacer más cosas
                                                 ; sólo habrá una unidad asignada a este tipo de recurso y por tanto es la que se encargará de recolectarlo
                (and
                    (UnidadAsignada ?u)
                    (Extrayendo ?u ?tr)
                    (En ?u ?l)
                )
            )

        
            (and
                
                (<=
                    (+
                    (cantidadRecurso ?tr)
                        (*
                            10
                            (cantidadUnidadesExtrayendo ?tr)
                        )
                    )
                    (limiteRecurso ?tr)
                )              ;sea límite menos 10      

            )


        )
        :effect (and 
                (increase (cantidadRecurso ?tr) 
                    (*
                        10
                        (cantidadUnidadesExtrayendo ?tr)
                    )
                )
                
                (increase (TiempoTotal)
                     10
                )
                     
            
            
        )
    )
    



)




