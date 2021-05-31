(define (domain dominio_ejercicio1)
    (:requirements :adl :typing :strips)
    
    ;TIPOS --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:types                                                 ;TIPOS
        localizacion elementos recurso - object                 ; Distinguiremos principalmente entre localizaciones, unidades y edificios a lo que llamaremos elementos, y recusos (minerales y gases)
        unidad edificio - elementos                             ; Definimos que los elementos son las unidades y los edificios
        
    )
    
    ;CONSTANTES ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:constants                                             ;CONSTANTES
        vce - unidad                                            ; Las unidades las conoceremos como VCE
        centroDeMando barracones - edificio                     ; Podemos tener dos tipos de edificios: los contres de Mando y los barracones que también definiremos como constantes
        minerales gas - recurso                                 ; Dentro de los recursos distinguimos minerales y gase Vespeno
    
    )
    
    ;PREDICADOS ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:predicates                                            ;PREDICADOS
        (En ?c - elementos ?l - localizacion)                   ; Determinar si un edificio o unidad está en una localización concreta
        (CaminoEntre ?l1 ?l2 - localizacion)                    ; Representar que existe un camino entre dos localizaciones
        (Construido ?e - edificio)                              ; Determinar si un edificio está construido
        (AsignaNodo ?r - recurso ?l - localizacion)             ; Asignar un nodo de un recurso concreto a una localizacion concreta
        (Extrayendo ?u - unidad ?r - recurso)                   ; Indicar si un VCE está extrayendo un recurso
        (obtenerRecurso ?r - recurso)                           ; Crearemos aparte un predicado llamado obtenerRecurso. Este lo usaremos para saber si un recurso ha sido o se está extrayendo. Este será el objetivo (goal) del ejercicio

        
    
    )                                                   
    
    ;ACCIONES -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   
    ;NAVERGAR:
        ; Mueve a una unidad entre dos localizaciones.
    (:action Navegar
    
        :parameters (?u - unidad ?origen ?destino - localizacion)
        
        :precondition (and 
                        (En ?u ?origen)                         ; La única precondicion necesaria es que la unidad se encuentre en la localización de origen
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
	
	    :parameters (?u - unidad ?loc_recurso - localizacion ?r - recurso)
	    
	    :precondition (and
	                    (En ?u ?loc_recurso)                   ; Entendemos que la unidad debe estar en el lugar donde se encuentra el recurso para poder extraerlo  (Si no están en la misma localización, el programa llamará a Navegar)
						(AsignaNodo ?r ?loc_recurso)           ; También el recurso debe encontrarse en una localización concreta, para ello debe ser verdad el predicado AsignaNodo del recurso y la localización parada como parámetro
						(not (Extrayendo ?u ?r))               ; Además, como nos indican que una unidad sólo puede recoger un único recurso en toda la ejecución, tendremos que asegurarno que no ha extraído o está extrayendo ningún otro recurso
					)

	    :effect (and                                           ; El resultado de esta acción será:
	                (Extrayendo ?u ?r)                              ; Primero declararemos que la unidad está extrayendo el recurso
				    (obtenerRecurso ?r)                             ; Y luego, declararemos que ese recurso ya sido extraído (de forma quealcanzaríamos nuestro objetivo)
				    
				)
	)



)

