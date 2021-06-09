(define (problem problema_ejercicio6)
    (:domain dominio_ejercicio6)
    (:objects 
        LOC11 LOC12 LOC13 LOC14 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 - localizacion          ; Creamos un mapa de 3x4 (empezando pos la localización 11 y acabando por la 34)
        
        CentroDeMando1 extractor1 barracones1 - edificio             ; También nos indica que necesitamos un centro de mando y un extractor que son de tipo edificio
        VCE1 VCE2 VCE3 Marine1 Marine2 Segador1 - unidad                               ; Es importante declarar nuestras unidades, pues serán las que recogan los recursos y construyan los edificios necesarios
     )
    
    ;Partimos del ejercicio 4
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

        ; Declararemos el tipo de edificio que es "centroDeMando1"
        (EdificioEs centroDeMando1 centroDeMando)

        ; También es necesario que inicialicemos las localizaciones en las que se encuentran las unidades VCE1 
        ; no declararemos las demás, ya que el ejercicio nos indica que sólo tenemos VCE1 y si necesitamos de VCE2 y VCE3 esta deberán ser reclutadas
        (En VCE1 LOC11)
    

        ; Si declararemos el tipo de unidades que son VCE1, VCE2 y VCE3, que son de tipo vce, ya que, necesitamos diferenciar el tipo de unidades
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


         ; Delcararemos el máximo de gas y minerales en 60
        (= (limiteRecurso gas) 60)              
        (= (limiteRecurso minerales) 60)

        ; Declararemos las cantidades necesarios de tipos de recursos que necesitan los tipo de edificio
        (= (cantidadRecursoNecesario barracones minerales) 50)
        (= (cantidadRecursoNecesario barracones gas) 20)

        (= (cantidadRecursoNecesario extractor minerales) 33)
        (= (cantidadRecursoNecesario extractor gas) 0)

        ; Declararemos las cantidades necesarios de tipos de recursos que necesitan los tipo de unidades
        (= (cantidadRecursoNecesario vce minerales) 10)
        (= (cantidadRecursoNecesario vce gas) 0)

        (= (cantidadRecursoNecesario marines minerales) 20)
        (= (cantidadRecursoNecesario marines gas) 10)

        (= (cantidadRecursoNecesario segadores minerales) 30)
        (= (cantidadRecursoNecesario segadores gas) 30)

        ; Inicializaremos la cantidad de minerales y gas a 0
        (= (cantidadRecurso minerales) 0 )
        (= (cantidadRecurso gas) 0)

        ; Inicializaremos la cantidad de unidades que están extrayendo gases y minerales a 0
        (=(cantidadUnidadesExtrayendo minerales) 0)
        (=(cantidadUnidadesExtrayendo gas)0)
    )
    
    (:goal
        (and
              ; El objetivo del programa será disponer de un marine (Marine1) en la localización LOC31,
            ; otro marine (Marine2) en la localización LOC24, y un segador (Segador1) en la localización LOC12.

            (En marine1 LOC31)
            (En marine2 LOC24)
            (En segador1 LOC12)

             (En barracones1 LOC32)          ; Además debemos tener en cuenta que del ejercicio 3, se deduce que barracones1 debe estar construido en LOC32
        
        
        )
    
    
    
    
    
    )







)