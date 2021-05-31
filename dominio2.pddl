(define (domain dominio_ejercicio2)
    (:requirements :adl :typing :strips)
    
    ;TIPOS --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:types                                                 ;TIPOS
        localizacion elementos recurso - object                 ; Distinguiremos principalmente entre localizaciones, unidades y edificios a lo que llamaremos elementos, y recusos (minerales y gases)
        unidad edificio - elementos                             ; Definimos que los elementos son las unidades y los edificios
        
    )
    
    ;CONSTANTES ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:constants                                             ;CONSTANTES
        vce - unidad                                            ; Las unidades las conoceremos como VCE
        centroDeMando barracones extractor - edificio           ; Podemos tener dos tipos de edificios: los contres de Mando y los barracones que también definiremos como constantes
        minerales gas - recurso                                 ; Dentro de los recursos distinguimos minerales y gase Vespeno
    
    )
    
    ;PREDICADOS ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:predicates                                            ;PREDICADOS
        (En ?c - elementos ?l - localizacion)        ; Determinar si un edificio o unidad está en una localización concreta
        (CaminoEntre ?l1 ?l2 - localizacion)                  ; Representar que existe un camino entre dos localizaciones
        (Construido ?e - edificio)                      ; Determinar si un edificio está construido
        (AsignaNodo ?r - recurso ?l - localizacion)        ; Asignar un nodo de un recurso concreto a una localizacion concreta
        (Extrayendo ?u - unidad ?r - recurso)           ; Indicar si un VCE está extrayendo un recurso
        (obtenerRecurso ?r - recurso)                   ; Crearemos aparte un predicado llamado obtenerRecurso. Este lo usaremos para saber si un recurso ha sido o se está extrayendo. Este será el objetivo (goal) del ejercicio
        (RecursoParaEdificio ?r - recurso ?e - edificio)   ; Definir qué recurso necesita cada edificio para ser construido.
        (RecursoEs ?r1 - recurso ?r2 - recurso)            ; Definiremos el predicado "RecursoEs" para poder reconocer o declarar el tipo de recurso (mineral o gas Vespeno)
        (EdificioEs ?e1 - edificio ?e2 - edificio)         ; También definiremos el predicado "EdificioEs" para poder reconocer o declarar el tipo de edificio (centro de mando, barracones o extractores)
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
    
        ; Para este ejercicio se hace la siguiente ampliación: 
            ; Para poder obtener Gas Vespeno (es decir, asignar un VCE a un nodo de gas vespeno), 
            ; debe existir un edificio Extractor construido previamente sobre dicho nodo de recurso.
	(:action Asignar
	
	    :parameters (?u - unidad ?loc_recurso - localizacion ?r - recurso)
	    
	    :precondition (and
	                    (En ?u ?loc_recurso)                   ; Entendemos que la unidad debe estar en el lugar donde se encuentra el recurso para poder extraerlo  (Si no están en la misma localización, el programa llamará a Navegar)
						(AsignaNodo ?r ?loc_recurso)           ; También el recurso debe encontrarse en una localización concreta, para ello debe ser verdad el predicado AsignaNodo del recurso y la localización parada como parámetro
						(not (Extrayendo ?u ?r))               ; Además, como nos indican que una unidad sólo puede recoger un único recurso en toda la ejecución, tendremos que asegurarno que no ha extraído o está extrayendo ningún otro recurso
                        (OR                                    ; Hacemos diferencia entre los dos tipos de recursos (gas Vespeno y minerales)
                            (and 
                                (RecursoEs ?r gas)                  ; Si el recurso que queremos extraer es gas Vespeno tenemos que construir un edificio de tipo extractor en la misma localización
                                (exists (?e - edificio)             ; para ello utilizamos "exists". "Exists" es esencialmente un parámetro adicional que podemos usarlo en precondiciones entre otras cosas
                                    (and                                ; Por tanto, definimos que exista un edificio ?e. Este edificio tiene que 
                                        (Construido ?e)                     ; Estar construido (y si no está, debe construirse para extraer el recurso)
                                        (EdificioEs ?e extractor)           ; Ser de tipo extrator
                                        (En ?e ?loc_recurso)                ; Y estar construido en la mismo posición que el recurso que queremos extraer
                                   )
                                )
                                
                                
                            )
                            (RecursoEs ?r minerales)                ; Si el recurso es gas, continuamos sin definir nada más
                        )
						
					)

	    :effect (and                                           ; El resultado de esta acción será:
	                (Extrayendo ?u ?r)                              ; Primero declararemos que la unidad está extrayendo el recurso
				    (obtenerRecurso ?r)                             ; Y luego, declararemos que ese recurso ya sido extraído (de forma quealcanzaríamos nuestro objetivo)
				    
				)
	)
	
	
	;Construir: 
	    ; Ordena a un VCE libre que construya un edificio en una localización. 
	    ; En este ejercicio, cada edificio sólo requerirá un único tipo de recurso para ser construido.
        ; Adicionalmente y por simplicidad, en este ejercicio se permite que existan varios edificios en la misma localización.
	(:action Construir
	    
	    :parameters (?u - unidad ?e - edificio ?l - localizacion ?r - recurso)
	    
	    :precondition (and 
                       
                        (not (Extrayendo ?u ?r))    ; Primero, la unidad que se encargue de construir el edificio no puede estar ocupada extrayendo recursos (ya que, cuando una unidad extrae recursos, no puede realizar más acciones)
                        (En ?u ?l)                  ; La unidad está  en el lugar donde se tiene que construir el edificio (si no está donde debe construirse, se tiene que desplazar hasta esa localización)
                        
                        (exists (?u2 - unidad ?r2 - recurso)        ; Luego, tendremos que declarar que haya otra unidad recogiendo el recurso que el edificio necasita para ser construido    
                                (and 
                                    (Extrayendo ?u2 ?r)                 ; La segunda unidad debe estar extrayendo un recurso
                                    (RecursoParaEdificio ?r2 ?e)        ; El recurso que extrae es el que necesita el edificio para ser construido
                                    (RecursoEs ?r ?r2)                  ; Además, este recurso debe ser el mismo que el que tenemos como parámetro (por lo que comprobamos que sean iguales)
                            )
                        )

                        (obtenerRecurso ?r)                 ; Por último, para construir un edificio, necesitamos saber que hemos extraido el recurso que este necesita para ser construido
                       
        )
	    
	    :effect (and 
                    (Construido ?e)                 ; Finalmente el edificio es construido y debe declararse como tal
                    (En ?e ?l)                      ; Además, se asigna la localización donde se construye el edificio
        )
	    
	    
	)



)

