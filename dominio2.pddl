; TERESA DEL CARMEN CHECA MARABOTTO
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

(define (domain dominio_ejercicio2)
    (:requirements :adl :typing :strips)
    
    ;TIPOS --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:types                                                 ;TIPOS
        localizacion elementos recurso - object                 ; Distinguiremos principalmente entre localizaciones, unidades y edificios a lo que llamaremos elementos, y recusos (minerales y gases)
        unidad edificio - elementos                             ; Definimos que los elementos son las unidades y los edificios
        tipoUnidad - unidad                                     ; Declararemos también que existen distintos tipo de unidades, edificio y recursos (estos estarán declarados en las constantes)
        tipoEdificio - edificio                                 ; de esta forma podemos declarar predicados generales (para todas las unidades, edificios o recursos) o  bien
        tipoRecurso - recurso                                   ; declarar predicados para un tipo específico (de unidad, edificio o recurso)
    )
    
    ;CONSTANTES ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:constants                                             ;CONSTANTES
        vce - tipoUnidad                                         ; Las unidades las conoceremos como VCE
        centroDeMando barracones extractor - tipoEdificio        ; Podemos tener tres tipos de edificios: los contres de Mando, los barracones y los extractores que también definiremos como constantes
        minerales gas - tipoRecurso                              ; Dentro de los recursos distinguimos minerales y gase Vespeno
    
    )
    
    ;PREDICADOS ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:predicates                                            ;PREDICADOS
        (En ?c - elementos ?l - localizacion)                           ; Determinar si un edificio o unidad está en una localización concreta
        (CaminoEntre ?l1 ?l2 - localizacion)                            ; Representar que existe un camino entre dos localizaciones
        (Construido ?e - edificio)                                      ; Determinar si un edificio está construido
        (AsignaNodo ?r - tipoRecurso ?l - localizacion)                 ; Asignar un nodo de un recurso concreto a una localizacion concreta
        (Extrayendo ?u - unidad ?r - tipoRecurso)                       ; Indicar si un VCE está extrayendo un recurso
        (obtenerRecurso ?r - tipoRecurso)                               ; Crearemos aparte un predicado llamado obtenerRecurso. Este lo usaremos para saber si un recurso ha sido o se está extrayendo. Este será el objetivo (goal) del ejercicio
        (UnidadEs ?u - unidad ?tu - tipoUnidad)                         ; Declaramos un predicado llamado UnidadEs, de esta forma podremos saber qué tipo de unidad es una unidad en concreto
        (RecursoEs ?r - recurso ?tr - tipoRecurso)                      ; Declaramos un predicado llamado RecursoEs, de esta forma podremos saber a qué tipo de recurso corresponde el recurso creado
        (EdificioEs ?e - edificio ?te - tipoEdificio)                   ; Declaramos un predicado llamado EdificioEs, de esta forma podremos saber a qué tipo de edificio corresponde un edificio en concreto
        (RecursoParaEdificio ?tr - tipoRecurso ?te - tipoEdificio)   ; RecursoParaEdificio es el predicado que no indicará el tipo de recurso necesario que debemos de tener extraído para construir un tipo de edificio concreto
        (UnidadAsignada ?u - unidad)                                    ; Declararemos otro predicado para saber si una unidad ha sido asignada a un recurso o no, independientemente del tipo de recurso al que está asignada, de esta forma, podremos evitar hacer forall cuando queramos saber si una unidad está extrayendo y no sepamos el tipo de recurso que extrae
    )                                                   
    
    ;ACCIONES -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
   
    ;NAVERGAR:
        ; Mueve a una unidad entre dos localizaciones.
    (:action Navegar
    
        :parameters (?u - unidad ?origen ?destino - localizacion)
        
        :precondition (and 
                        (En ?u ?origen)                         ; La única precondicion necesaria es que la unidad se encuentre en la localización de origen
                        (caminoEntre ?origen ?destino)          ; Además, tenemos que declarar que existe un camino entre el origen y el destino, de esta forma, cumplirá el mapa 
                                                                ; correspodiente implementado en el problema y además nos aseguraremos de que llame a la acción navegar por cada localización que avance 
                        (not(UnidadAsignada ?u))                ; Debemos declarar que una unidad que ya ha sido asignada a un nodo de un recurso, no puede navegar, ya que, una vez asignemos una unidad a un recurso, esta no podrá realizar más acciones
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
    
        ; Modificación: Para poder obtener Gas Vespeno (es decir, asignar un VCE a un nodo de gas vespeno), debe existir un edificio Extractor construido previamente 
        ; sobre dicho nodo de recurso. No hay cambios para obtener recursos de mineral.
	(:action Asignar
	
	    :parameters (?u - unidad ?loc_recurso - localizacion ?tr - tipoRecurso)
	    
	    :precondition (and
	                    (En ?u ?loc_recurso)                   ; Entendemos que la unidad debe estar en el lugar donde se encuentra el recurso para poder extraerlo  (Si no están en la misma localización, el programa llamará a Navegar)
						(UnidadEs ?u vce)                      ; Debemos asegurarnos también que el tipo de unidad que se asigna a un nodo, es siempre de tipo VCE
						(not (Extrayendo ?u ?tr))              ; Por otro lado, debemos asegurarno que la unidad que vamos a asignar no puede estar extrayendo ese recurso
                        (not (UnidadAsignada ?u))              ; ni puede estar ya asignada a otro recurso
                        (AsignaNodo ?tr ?loc_recurso)          ; Además, debemos asegurarnos que la localización (en la que vamos a asignar y donde se encuentra la unidad), es donde está el recurso asignado
						
						(imply                                 ; Crearemos un imply en el que indicaremos que, cuando el nodo esté asignado a un recurso de tipo gas, 
						                                       ; debe existir un edificio de tipo extractor en la misma localización que el recurso (si no existe el edificio, debe construirse para poder extraer gas)
						    (AsignaNodo gas ?loc_recurso)
						    
						       (exists (?e - edificio)              ; Indicamos que debe existir al menos un edificio (que siempre será como máximo uno ya que en construir hemos indicado que sólo puede haber un edificio por localización)
                                    (and
                                        (En ?e ?loc_recurso)        ; Con esta línea indicaremos que el edificio se encuentra en la misma localización que el recurso
                                        (EdificioEs ?e extractor)   ; Ahora, estamo indicando que el edificio sea de tipo extractor
                                    )
						        )
						    
						)
						
					)

	    :effect (and                                           ; El resultado de esta acción será:
	                (Extrayendo ?u ?tr)                              ; Primero declararemos que la unidad está extrayendo el recurso
				    (obtenerRecurso ?tr)                             ; Y luego, declararemos que ese recurso ya sido extraído (de forma quealcanzaríamos nuestro objetivo)
				    (UnidadAsignada ?u)                              ; Por último, declararemos que hemos asignada la unidad a un nodo con "unidadAsignada", de esta forma, podemos controlar las 
                                                                     ; unidades que están asignadas a un nodo y las que no, ya que, una vez que asignemos una unidad a un nodo, esta no ppuede realizar más acciones
				)
	)

;Construir: 
	    ; Ordena a un VCE libre que construya un edificio en una localización. 
	    ; En este ejercicio, cada edificio sólo requerirá un único tipo de recurso para ser construido.
	    ; Adicionalmente y por simplicidad, en este ejercicio se permite que existan varios edificios en la misma localización.
	(:action Construir
	    
	    :parameters (?u - unidad ?e - edificio ?l - localizacion ?r - recurso)
	    
	    :precondition (and 
                       
                       (En ?u ?l)                  ; Primero, debemos asegurarnos que la unidad está en el lugar donde se tiene que construir el edificio (si no está donde debe construirse, se tiene que desplazar hasta esa localización)
                        
                        (exists (?u2 - unidad ?r2 - tipoRecurso ?te - tipoEdificio)        ; Luego, tendremos que declarar que haya otra unidad recogiendo el recurso que el edificio necesita para ser construido y que exista un tipo de edificio que lo cumpla   
                                (and 
                                    (Extrayendo ?u2 ?r2)                 ; La segunda unidad debe estar extrayendo un recurso
                                    (RecursoParaEdificio ?r2 ?te)        ; El recurso que extrae es el que necesita el tipo de edificio indicado para ser construido
                                    (EdificioEs ?e ?te)                  ; El tipo de edificio debe corressponder con el edificio que queremos construir
                                    
                                )
                        )
                        (not (UnidadAsignada ?u))             ; Por último, debemos asegurarnos que la unidad que construirá el edificio no está ya asignada a un nodo
        )
	    
	    :effect (and 
                    (Construido ?e)                 ; Finalmente el edificio es construido y debe declararse como tal
                    (En ?e ?l)                      ; Además, se asigna la localización donde se construye el edificio
        )
	    
	    
	)



)




