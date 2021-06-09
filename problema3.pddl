; TERESA DEL CARMEN CHECA MARABOTTO
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

(define (problem problema_ejercicio3)
    (:domain dominio_ejercicio3)
    (:objects 
        LOC11 LOC12 LOC13 LOC14 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 - localizacion          ; Creamos un mapa de 3x4 (empezando pos la localización 11 y acabando por la 34)
        
        CentroDeMando1 extractor1 barracones1 - edificio             ; También nos indica que necesitamos un centro de mando, un extractor y unos barracones que son de tipo edificio
        VCE1 VCE2 VCE3 - unidad                               ; Es importante declarar nuestras unidades, pues serán las que recogan los recursos y construyan los edificios necesarios
    )
    
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
        (Construido CentroDeMando1) 

        ; También es necesario que inicialicemos las localizaciones en las que se encuentran las unidades VCE1, VCE2 y VCE3
        (En VCE1 LOC11)
        (En VCE2 LOC11)
        (En VCE3 LOC11)

        ; Declararemos también el tipo de unidades que son VCE1, VCE2 y VCE3, que son de tipo vce, ya que, necesitamos diferenciar el tipo de unidades
        ; que son, ya que cada tipo se encargará de realizar acciones distintas
        (UnidadEs VCE1 vce)
        (UnidadEs VCE2 vce)
        (UnidadEs VCE3 vce)
                      
        
        ; Asignaremos también los nodos de recursos indicados en las localizaciones indicadas
        ; no necesitamos declarar objetos de recursos, ya que sólo necesitamos asignar un mineral a un nodo
        (AsignaNodo minerales LOC23)     
        (AsignaNodo minerales LOC33)
        (AsignaNodo gas LOC13)

        ; Declararemos también el tipo de edificio que es extractor1 (que es de tipo extractor), necesario para sabe cuando necesitamos construirlo
        (EdificioEs extractor1 extractor)

        ; Sabemos que para construir un extractor es necesario tener recursos de tipo mineral.
        ; Por lo que debemos declarar este tipo de relación para nuestro edificio de tipo extractor
        (RecursoParaEdificio minerales extractor)
        
        ; Declararemos que tenemos un edificio llamado "barracones1" que es de tipo barracones
        (EdificioEs barracones1 barracones)

        ; Además, debemos indicar que, para construir barracones, es necesario haber extraído minerales y gas Vespeno
        (RecursoParaEdificio minerales barracones)
        (RecursoParaEdificio gas barracones)


    )
    
    (:goal
        (and
            ; El objetivo del programa será construir el edificio "barracones1" en la localización 32 
            ;(teniendo en cuenta que debemos recoger antes los recursos necesarios para su construcción)
            (En barracones1 LOC32)
        
        )
    
    
    
    
    
    )







)