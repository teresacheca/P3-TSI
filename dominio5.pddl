; TERESA DEL CARMEN CHECA MARABOTTO
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

(define (domain dominio_ejercicio5)
    (:requirements :adl :typing :strips)
    
    ;TIPOS --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:types                                                 ;TIPOS
        localizacion elementos recurso - object                 ; Distinguiremos principalmente entre localizaciones, unidades y edificios a lo que llamaremos elementos, y recusos (minerales y gases)
        unidad edificio investigacion - elementos                             ; Definimos que los elementos son las unidades, los edificios y las investigaciones
        tipoUnidad - unidad                                     ; Declararemos también que existen distintos tipo de unidades, edificio y recursos (estos estarán declarados en las constantes)
        tipoEdificio - edificio                                 ; de esta forma podemos declarar predicados generales (para todas las unidades, edificios o recursos) o  bien
        tipoRecurso - recurso                                   ; declarar predicados para un tipo específico (de unidad, edificio o recurso)
        tipoInvestigacion - investigacion                       ; Declararemos también que existen tipos de investigaciones 
    )
    
    ;CONSTANTES ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:constants                                             ;CONSTANTES
        vce marines segadores - tipoUnidad                                            ; Las unidades las conoceremos como VCE
        centroDeMando barracones extractor bahiaDeIngenieria - tipoEdificio                     ; Podemos tener cuatro tipos de edificios
        minerales gas - tipoRecurso                                 ; Dentro de los recursos distinguimos minerales y gase Vespeno
        impulsarSegador - tipoInvestigacion                         ; Dentro de las investigaciones, encontramos el tipo impulsarSegador
    )
    
    ;PREDICADOS ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    (:predicates                                            ;PREDICADOS
        (En ?c - elementos ?l - localizacion)                   ; Determinar si un edificio o unidad está en una localización concreta
        (CaminoEntre ?l1 ?l2 - localizacion)                    ; Representar que existe un camino entre dos localizaciones
        (Construido ?e - edificio ?l - localizacion)                              ; Determinar si un edificio está construido
        (AsignaNodo ?r - tipoRecurso ?l - localizacion)             ; Asignar un nodo de un recurso concreto a una localizacion concreta
        (Extrayendo ?u - unidad ?r - tipoRecurso)                   ; Indicar si un VCE está extrayendo un recurso
        (obtenerRecurso ?r - tipoRecurso)                           ; Crearemos aparte un predicado llamado obtenerRecurso. Este lo usaremos para saber si un recurso ha sido o se está extrayendo. Este será el objetivo (goal) del ejercicio
        
        (UnidadEs ?u - unidad ?tu - tipoUnidad)                          ; Declaramos un predicado llamado UnidadEs, de esta forma podremos saber qué tipo de unidad es una unidad en concreto
        (RecursoEs ?r - recurso ?tr - tipoRecurso)                       ; Declaramos un predicado llamado RecursoEs, de esta forma podremos saber a qué tipo de recurso corresponde el recurso creado
        (EdificioEs ?e - edificio ?te - tipoEdificio)                    ; Declaramos un predicado llamado EdificioEs, de esta forma podremos saber a qué tipo de edificio corresponde un edificio en concreto
        (RecursoParaEdificio ?tr - tipoRecurso ?te - tipoEdificio)       ; RecursoParaEdificio es el predicado que no indicará el tipo de recurso necesario que debemos de tener extraído para construir un tipo de edificio concreto
        (UnidadAsignada ?u - unidad)                                     ; Declararemos otro predicado para saber si una unidad ha sido asignada a un recurso o no, independientemente del tipo de recurso al que está asignada, de esta forma, podremos evitar hacer forall cuando queramos saber si una unidad está extrayendo y no sepamos el tipo de recurso que extrae
    
        (RecursoParaUnidad ?tr - tipoRecurso ?tu - tipoUnidad)             ; Declararemos también un predicado para definir el tipo de recurso que necesita un tipo de unidad par ser reclutada
        (ReclutadoEn ?tu - tipoUnidad ?te - tipoEdificio)                   ; Declararemos el predicado "ReclutadoEn" para saber el tipo de edificio en el que se tiene que reclutar un tipo de unidad concreto

        (InvestigacionCreada ?i - investigacion)                                ; Delcararemos un predicado para saber si hemos creado un tipo de investigación o no
        (RecursoParaInvestigacion ?tr - tipoRecurso ?ti - tipoInvestigacion)    ; También necesitaremos saber el tipo de recurso que necesita cada tipo de investigación para ser creada
        (InvestigacionEs ?i - investigacion ?ti - tipoInvestigacion)            ; Declararemos el predicado "investigacionEs", de esta forma podremos saber a qué tipo de investigación corresponde  con una investigación concreta

        
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
    
        ; Modificación del ejercicio 3: Para poder obtener Gas Vespeno (es decir, asignar un VCE a un nodo de gas vespeno), debe existir un edificio Extractor construido previamente 
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
	
        ; Modificación del ejercicio 3: modificar la acción Construir para que tenga en cuenta que un edificio puede requerir más de un tipo 
	    ; de recurso. Esta acción debe inferir por sí misma si se tienevel tipo de recursos necesarios para poder ejecutarse. 
	    ; Además, debe evitar que se construya más de un edificio en la misma localización
		(:action Construir
	    
	    :parameters (?u - unidad ?e - edificio ?l - localizacion )
	    
	    :precondition (and 
                       
                     (En ?u ?l)                         ; Primero, debemos asegurarnos que la unidad está en el lugar donde se tiene que construir el edificio (si no está donde debe construirse, se tiene que desplazar hasta esa localización)

                    (not (exists (?e2 - edificio)       ; Comprobaremos que no hay otro edificio construído en esa localización
                        (En ?e2 ?l))
                    )

                    (forall (?r - tipoRecurso)          ; Luego, comprobaremos que para todos los tipos de recursos, exista un tipo de edificio que corresponda con el edificio que queremos construir
                                                        ; y que, cuando encontremos que ese edificio necesita algún recurso para construirse, este recurso debe haber sido extraido
                        (exists (?te - tipoEdificio)
                            (and
                                (EdificioEs ?e ?te)           ; Con esta línea comprobamos que el tipo de edificio es el mismo que el edificio que queremos construir (para que se dé este predicado, es necesario que esté definico en el problema)
                                (imply (RecursoParaEdificio ?r ?te)         ; Comprobaremos que si existe "recursoParaEdificio" para ese edificio con algún recurso, que esto implicará
                                                                            ; que exista otra unidad (no la misma de la acción), que esté extrayendo ese recurso
                                        (exists (?u2 - unidad)              
                                            (Extrayendo ?u2 ?r) 
                                        )
                                )
                            )
                        )
                    )
                    (UnidadEs ?u vce)                       ; Nos aseguraremos que la unidad que construye en de tipo VCE
                    (forall (?l2 - localizacion)            ; Además, nos declararemos que el edificio que queremos construir no se encuentra ya construído en otro lugar del mapa
                        (not (Construido ?e ?l2))
                    )

                    (not(UnidadAsignada ?u))                ; Por último, debemos asegurarnos que la unidad que construirá el edificio no está ya asignada a un nodo
        )
	    
	    :effect (and 
                    (Construido ?e ?l)                 ; Finalmente el edificio es construido y debe declararse como tal
                    (En ?e ?l)                      ; Además, se asigna la localización donde se construye el edificio
        )
	    
	    
	)
	
	;Reclutar: 
	    ; Esta acción se encargará de reclutar a las distintas unidades, teniendo en cuenta que las unidades necesitan de recursos para 
		; ser reclutadas. Además, cada unidad debe ser reclutada en un tipo de edificio concreto
	
	(:action Reclutar
        :parameters (?e - edificio ?u - unidad ?l - localizacion)

        :precondition (and 
            (forall (?l2 - localizacion)        ; Primero, nos aseguraremos que la unidad que queremos reclutar no se encuentra en el mapa, y por tanto, aún no ha sido reclutada
                (not (En ?u ?l2))
            )

            ; Luego, comprobaremos que existe un tipo de unidad que correcponde con la unidad que queremos reclutar.
            ; Para lo cuál comprobaremos todos los tipos de recursos, si para alguno de ellos existe el predicado "RecursoParaUnidad", esto implicará
            ; que necesitaremos de ese recurso para reclutar a la unidad y que por tanto, este debe haber sido extraído
            ; Además, existirá un tipo de edificio en el cual debe ser reclutada la unidad y por ello, ese edificio debe estar construído

            ; Podremos reclutar sin necesitdad de que haya un VCE donde se encuentra el edificio, y por tanto, la localización ?l representa el lugar donde se
            ; encuentra el edificio en el que debemos reclutar la unidad

            (exists (?tu - tipoUnidad )         
                (and
                    (forall (?r - tipoRecurso )
                        (and
                        
                            (UnidadEs ?u ?tu)               ; Comprobaremos que el tipo de unidad corresponde con la unidad que queremos reclutar
                        
                            (imply 
                                (RecursoParaUnidad ?r ?tu)                          ; Si existe el predicado "RecursoParaUnidad" para un recurso y ese tipo de unidad,
                                                                                    ; debe existir una unidad vce que esté extrayendo el recurso necesario (la localización no tiene porqué ser la misma que la del edificio)
                                    (exists (?u2 - unidad ?l2 - localizacion) 
                                    (and
                                        (Extrayendo ?u2 ?r) 
                                        (unidadEs ?u2 vce)
                                        (En ?u2 ?l2)
                                    )
                                )
                            )
                            
                        )
                    )

                     (exists ( ?te - tipoEdificio )                 ; Comprobamos que exista un tipo de edificio en el cual debemos reclutar a ese tipo de unidad
                        (and 
                            (ReclutadoEn ?tu ?te)                
                            (EdificioEs ?e ?te)
                            (Construido ?e ?l)              ; El edificio debe estar construído en la localización ?l por lo explicado anteriormente
                                                       
                        )
                    )
                   
                )
            )
                   
                    
            ; Ahora, tendremos en cuenta que para construir una unidad de tipo segadores, es necesario tener creada la investigación "impulsarSegador"
            ; Para ello, comprobaremos que si la unidad es de tipo segadores, debe existir una unidad creada de tipo impulsarSegador        
            (imply
                (UnidadEs ?u segadores)
                (InvestigacionCreada impulsarSegador)
            )

        )
        :effect (and 
                    (En ?u ?l)
                )
        )

    ;investigar: 
	    ; Realiza nuevas invertigaciones para la base.
        ; Esta acción creará una investigación. Para las investigaciones necesitaremos tener un edificio de tipo bahía de ingeniería
        ; Además, para algunas investigaciones necesitamos un tipo concreeto de recurso
	
    (:action Investigar
        
        :parameters (?e - edificio ?i - investigacion)

        :precondition (and
                (forall (?r - tipoRecurso)
                    (exists (?ti - tipoInvestigacion)
                        (imply (RecursoParaInvestigacion ?r ?ti)            ; Comprobaremos el tipo de recurso que necesita una investigación para crearse, 
                                                                            ; si se da el predicado "RecursoParaInvestigacion" para un recurso y ese tipo de investigación, necesitaremos una unidad que está extrayendo ese tipo de recurso
                                    (exists (?u2 - unidad) 
                                        (Extrayendo ?u2 ?r) 
                                    )
                                
                            
                        )
                    )
					
				)
                (EdificioEs ?e bahiaDeIngenieria)           ; Debemos comprobar que tenemos una bahia de ingeniería construido
                (exists (?l - localizacion)                 ; Además, el edificio se debe construir en la localización indicada
                    (Construido ?e ?l)
                )
                
                
            
        )

        :effect (and 
            (InvestigacionCreada ?i)            ; Finalmente tendremos creada una investigación
        )
    )
    

)




