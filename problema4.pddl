; TERESA DEL CARMEN CHECA MARABOTTO
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

(define (problem problema_ejercicio4)
    (:domain dominio_ejercicio4)
    (:objects 
        LOC11 LOC12 LOC13 LOC14 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 - localizacion          ; Creamos un mapa de 3x4 (empezando pos la localización 11 y acabando por la 34)
        
        CentroDeMando1 extractor1 barracones1 - edificio            ; También nos indica que necesitamos un centro de mando, un extractor y unos barracones que son de tipo edificio
        VCE1 VCE2 VCE3 Marine1 Marine2 Segador1 - unidad            ; Es importante declarar nuestras unidades, pues serán las que recogan los recursos y construyan los edificios necesarios
       
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
        
         ; Declararemos que tenemos un edificio llamado "barracones1" que es de tipo barracones
        (EdificioEs barracones1 barracones)

        ; Además, debemos indicar que, para construir barracones, es necesario haber extraído minerales y gas Vespeno
        (RecursoParaEdificio minerales barracones)
        (RecursoParaEdificio gas barracones)

        
        ; Declararemos el tipo de unidad que son las nuevas unidades del problema. Siendo Marine1 y Marine2 de tipo Marines y Segador1 de tipo Segadores
        (UnidadEs Marine1 marines)
        (UnidadEs Marine2 marines)
        (UnidadEs Segador1 segadores)

        ; Por otro lado indicaremos el tipo edificio donde deben ser reclutados los distintos tipos de unidades
        (ReclutadoEn vce centroDeMando)             ; Las VCEs deben ser reclutadas en los centros de mando
        (ReclutadoEn marines barracones)            ; Los Marines deben ser reclutados en los barracones
        (ReclutadoEn segadores barracones)          ; Los Segadores deben ser reclutados en los barracones
        ; Si no tenemos estos tipos de edificios construido, no podemos reclutar a las unidades

        ; Tambiñen sabemos que las distintas unidades necesitan de recursos para ser contruidas, por ello declararemos los siguientes predicados
        (RecursoParaUnidad minerales vce)           ; Las VCE necesitan minerales
        (RecursoParaUnidad minerales marines)       ; Los marines necesitan minerales
        (RecursoParaUnidad minerales segadores)           ; Los segadores necesitan minerales y gas
        (RecursoParaUnidad gas segadores)           



    )
    
    (:goal
        (and
            ; El objetivo del programa será disponer de un marine (Marine1) en la localización LOC31,
            ; otro marine (Marine2) en la localización LOC24, y un segador (Segador1) en la localización LOC12.

        
            (En barracones1 LOC32)          ; Además debemos tener en cuenta que del ejercicio 3, se deduce que barracones1 debe estar construido en LOC32
            (En marine1 LOC31)
            (En marine2 LOC24)
            (En segador1 LOC12)
        
        )
    
    
    
    
    
    )







)