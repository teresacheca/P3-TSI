; TERESA DEL CARMEN CHECA MARABOTTO
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

(define (domain dominio_ejercicio1)
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
        centroDeMando barracones - tipoEdificio                  ; Podemos tener dos tipos de edificios: los contres de Mando y los barracones que también definiremos como constantes
        minerales gas - tipoRecurso                              ; Dentro de los recursos distinguimos minerales y gase Vespeno
    
    )
    
    ;PREDICADOS ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:predicates                                            ;PREDICADOS
        (En ?c - elementos ?l - localizacion)                   ; Determinar si un edificio o unidad está en una localización concreta
        (CaminoEntre ?l1 ?l2 - localizacion)                    ; Representar que existe un camino entre dos localizaciones
        (Construido ?e - edificio)                              ; Determinar si un edificio está construido
        (AsignaNodo ?r - tipoRecurso ?l - localizacion)         ; Asignar un nodo de un recurso concreto a una localizacion concreta
        (Extrayendo ?u - unidad ?r - tipoRecurso)               ; Indicar si un VCE está extrayendo un recurso
        (obtenerRecurso ?r - tipoRecurso)                       ; Crearemos aparte un predicado llamado obtenerRecurso. Este lo usaremos para saber si un recurso ha sido o se está extrayendo. Este será el objetivo (goal) del ejercicio           
        (UnidadAsignada ?u - unidad)                            ; Declararemos otro predicado para saber si una unidad ha sido asignada a un recurso o no, independientemente del tipo de recurso al que está asignada, de esta forma, podremos evitar hacer forall cuando queramos saber si una unidad está extrayendo y no sepamos el tipo de recurso que extrae
        (UnidadEs ?u - unidad ?tu - tipoUnidad)                 ; Declaramos un predicado llamado UnidadEs, de esta forma podremos saber qué tipo de unidad es una unidad en concreto
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
	(:action Asignar
	
	    :parameters (?u - unidad ?loc_recurso - localizacion ?r - tipoRecurso)
	    
	    :precondition (and
	                    (En ?u ?loc_recurso)                   ; Entendemos que la unidad debe estar en el lugar donde se encuentra el recurso para poder extraerlo  (Si no están en la misma localización, el programa llamará a Navegar)
                        (not (Extrayendo ?u ?r))               ; Por otro lado, debemos asegurarno que la unidad que vamos a asignar no puede estar extrayendo ese recurso
                        (not (UnidadAsignada ?u))              ; ni puede estar ya asignada a otro recurso
                        (AsignaNodo ?r ?loc_recurso)           ; Además, debemos asegurarnos que la localización (en la que vamos a asignar y donde se encuentra la unidad), es donde está el recurso asignado
						
					)

	    :effect (and                                           ; El resultado de esta acción será:
	                (Extrayendo ?u ?r)                              ; Primero declararemos que la unidad está extrayendo el recurso
                    (obtenerRecurso ?r)                             ; Luego, declararemos que ese recurso ya sido extraído (de forma quealcanzaríamos nuestro objetivo)
                    (UnidadAsignada ?u)                             ; Por último, declararemos que hemos asignada la unidad a un nodo con "unidadAsignada", de esta forma, podemos controlar las 
                                                                    ; unidades que están asignadas a un nodo y las que no, ya que, una vez que asignemos una unidad a un nodo, esta no ppuede realizar más acciones
				)
	)



)

