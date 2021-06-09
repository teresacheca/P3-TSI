(define (problem problema_ejercicio7)
    (:domain dominio_ejercicio7)
    (:objects 
        LOC11 LOC12 LOC13 LOC14 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 - localizacion          ; Creamos un mapa de 3x4 (empezando pos la localización 11 y acabando por la 34)
        
        CentroDeMando1 extractor1 barracones1 - edificio             ; También nos indica que necesitamos un centro de mando y un extractor que son de tipo edificio
        VCE1 VCE2 VCE3 Marine1 Marine2 Segador1 - unidad                               ; Es importante declarar nuestras unidades, pues serán las que recogan los recursos y construyan los edificios necesarios
      ;  mineral1 mineral2 gas1 - recurso                 ; También tenemos dos recursos que sean minerales y un recurso que sea gas (el tipo se declarará en el init)
    )
    
    ;Partimos del ejercicio 6
    (:init
    
        ; Declaramos todos los caminos (o conexiones) existentes entre todas las localizaciones del mapa
        
        (CaminoEntre LOC11 LOC12)
        (CaminoEntre LOC11 LOC21)
        
        (CaminoEntre LOC12 LOC11)
        (CaminoEntre LOC12 LOC22)
        
        (CaminoEntre LOC13 LOC14)
        (CaminoEntre LOC13 LOC23)
        
        (CaminoEntre LOC14 LOC13)
        (CaminoEntre LOC14 LOC24)
        
        (CaminoEntre LOC21 LOC11)
        (CaminoEntre LOC21 LOC31)
        
        (CaminoEntre LOC22 LOC12)
        (CaminoEntre LOC22 LOC32)
        (CaminoEntre LOC22 LOC23)
        
        (CaminoEntre LOC23 LOC22)
        (CaminoEntre LOC23 LOC13)
        
        (CaminoEntre LOC24 LOC14)
        (CaminoEntre LOC24 LOC34)
        
        (CaminoEntre LOC31 LOC21)
        (CaminoEntre LOC31 LOC32)
        
        (CaminoEntre LOC32 LOC31)
        (CaminoEntre LOC32 LOC22)
        
        (CaminoEntre LOC33 LOC34)
        
        (CaminoEntre LOC34 LOC33)
        (CaminoEntre LOC34 LOC24)

        ; Inicializamos la localización en la que se encuentra el centro de Mando 
        (En CentroDeMando1 LOC11)      
        ; Declararemos también que el centro de mando está construido
        (Construido CentroDeMando1 LOC11) 

        ; También es necesario que inicialicemos las localizaciones en las que se encuentran las unidades VCE1 y VCE2
        (En VCE1 LOC11)
      ;  (UnidadReclutada VCE1 LOC11)
        ;(En VCE2 LOC11)
       ; (En VCE3 LOC11)

        (UnidadEs VCE1 vce)
        (UnidadEs VCE2 vce)
        (UnidadEs VCE3 vce)
                      
        
        ; Asignaremos también los nodos de los recursos (mineral1, mineral2 y gas1) a unas localizaciones concretas para saber dónde se encuentran en el mapa
        (AsignaNodo minerales LOC23)     
        (AsignaNodo minerales LOC33)
        (AsignaNodo gas LOC13)

        ; Declararemos el tipo de recurso que es cada uno para poder diferenciarlos 
        ; (necesario sobre todo para cuando vayamos a construir un edificio que necesita un recusro concreto):
        ; mineral1 y mineral2 son recursos de tipo mineral
    ;    (RecursoEs mineral1 minerales)          
    ;    (RecursoEs mineral2 minerales)
        ; gas1 es un recurso de tipo gas
    ;    (RecursoEs gas1 gas)

        ; Declararemos también el tipo de edificio que es extractor1 (que es de tipo extractor), necesario para sabe cuando necesitamos construirlo
        (EdificioEs extractor1 extractor)

        ; Sabemos que para construir un extractor es necesario tener recursos de tipo mineral.
        ; Por lo que debemos declarar este tipo de relación para nuestro edificio de tipo extractor
        (RecursoParaEdificio minerales extractor)
        
        (EdificioEs barracones1 barracones)

        (RecursoParaEdificio minerales barracones)
        (RecursoParaEdificio gas barracones)

        (UnidadEs Marine1 marines)
        (UnidadEs Marine2 marines)
        (UnidadEs Segador1 segadores)

        (ReclutadoEn vce centroDeMando)
        (ReclutadoEn marines barracones)
        (ReclutadoEn segadores barracones)

        (RecursoParaUnidad minerales vce)
        (RecursoParaUnidad minerales marines)
        (RecursoParaUnidad gas segadores)

        (EdificioEs centroDeMando1 centroDeMando)

        (= (limiteRecurso gas) 60)
        (= (limiteRecurso minerales) 60)

        (= (cantidadRecursoNecesario barracones minerales) 50)
        (= (cantidadRecursoNecesario barracones gas) 20)

        (= (cantidadRecursoNecesario extractor minerales) 33)
        (= (cantidadRecursoNecesario extractor gas) 0)

        (= (cantidadRecursoNecesario vce minerales) 10)
        (= (cantidadRecursoNecesario vce gas) 0)

        (= (cantidadRecursoNecesario marines minerales) 20)
        (= (cantidadRecursoNecesario marines gas) 10)

        (= (cantidadRecursoNecesario segadores minerales) 30)
        (= (cantidadRecursoNecesario segadores gas) 30)

        (= (cantidadRecurso minerales) 0 )
        (= (cantidadRecurso gas) 0)

        (=(cantidadUnidadesExtrayendo minerales) 0)
        (=(cantidadUnidadesExtrayendo gas)0)

        (=(velocidadUnidad vce) 10)
        (=(velocidadUnidad marines) 2)
        (=(velocidadUnidad segadores) 2)

        (=(tiempoConsumidoEdificio barracones) 46)
        (=(tiempoConsumidoEdificio extractor) 21)

        (=(tiempoConsumidoUnidad vce) 12)
        (=(tiempoConsumidoUnidad marines) 18)
        (=(tiempoConsumidoUnidad segadores) 32)
        
        (=(TiempoTotal)0)

    )
    
    (:goal
        (and
            ; El objetivo del programa será recoger recurss de tipo gas Vespeno
            (En barracones1 LOC32)
            (En marine1 LOC31)
            (En marine2 LOC24)
            (En segador1 LOC12)
           ; (=(cantidadRecurso minerales) 20)
        
        )
    
    )

    (:metric minimize (TiempoTotal)
    
    )






)