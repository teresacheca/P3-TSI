(define (domain dominio_ejercicio2)
    (:requirements :adl :typing :strips)
    
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
        vce - tipoUnidad                                            ; Las unidades las conoceremos como VCE
        centroDeMando barracones extractor - tipoEdificio                     ; Podemos tener dos tipos de edificios: los contres de Mando y los barracones que también definiremos como constantes
        minerales gas - tipoRecurso                                 ; Dentro de los recursos distinguimos minerales y gase Vespeno
    
    )
    
    ;PREDICADOS ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:predicates                                            ;PREDICADOS
        (En ?c - elementos ?l - localizacion)                   ; Determinar si un edificio o unidad está en una localización concreta
        (CaminoEntre ?l1 ?l2 - localizacion)                    ; Representar que existe un camino entre dos localizaciones
        (Construido ?e - edificio)                              ; Determinar si un edificio está construido
        (AsignaNodo ?r - tipoRecurso ?l - localizacion)             ; Asignar un nodo de un recurso concreto a una localizacion concreta
        (Extrayendo ?u - unidad ?r - tipoRecurso)                   ; Indicar si un VCE está extrayendo un recurso
        (obtenerRecurso ?r - tipoRecurso)                           ; Crearemos aparte un predicado llamado obtenerRecurso. Este lo usaremos para saber si un recurso ha sido o se está extrayendo. Este será el objetivo (goal) del ejercicio
        (AsignaUnidadARecurso ?u - unidad ?tr - tipoRecurso)
        (UnidadEs ?u - unidad ?tu - tipoUnidad)
        (RecursoEs ?r - recurso ?tr - tipoRecurso)
        (EdificioEs ?e - edificio ?te - tipoEdificio)
        (RecursoParaEdificio ?tr - tipoRecurso ?te - tipoEdificio)
        (TipoDeRecurso ?tr1 - tipoRecurso ?tr2 - tipoRecurso)
    )                                                   
    
    ;ACCIONES -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   
    ;NAVERGAR:
        ; Mueve a una unidad entre dos localizaciones.
    (:action Navegar
    
        :parameters (?u - unidad ?origen ?destino - localizacion)
        
        :precondition (and 
                        (En ?u ?origen)                         ; La única precondicion necesaria es que la unidad se encuentre en la localización de origen
                        (caminoEntre ?origen ?destino)
                        
                        )   
        :effect (and                                            ; La finalidad de la acción será que:
                    (En ?u ?destino)                                ; La unidad se encuentre en la localización de destino
                    (not (En ?u ?origen))                           ; Y también tenemos que declarar que la unidad ya no se encuentra en la localización de origen
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
						
					)

	    :effect (and                                           ; El resultado de esta acción será:
	                (Extrayendo ?u ?tr)                              ; Primero declararemos que la unidad está extrayendo el recurso
				    (obtenerRecurso ?tr)                             ; Y luego, declararemos que ese recurso ya sido extraído (de forma quealcanzaríamos nuestro objetivo)
				   
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
					; existe un tipo de edificio
					(exists (?te - tipoEdificio)
						(and
							; que es el que vamos a construir
							(EdificioEs ?e ?te)
							; si ese edificio necesita el recurso, se tiene que estar extrayendo
							(imply (RecursoParaEdificio ?r ?te) 
                                    (exists (?u2 - unidad) 
                                        (Extrayendo ?u2 ?r) 
                                    )
							)
						)
					)
				)
                    
        )
	    
	    :effect (and 
                    (Construido ?e)                 ; Finalmente el edificio es construido y debe declararse como tal
                    (En ?e ?l)                      ; Además, se asigna la localización donde se construye el edificio
        )
	    
	    
	)



)



