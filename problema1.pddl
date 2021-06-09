; TERESA DEL CARMEN CHECA MARABOTTO
;------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

(define (problem problema_ejercicio1)
    (:domain dominio_ejercicio1)
    (:objects 
        LOC11 LOC12 LOC13 LOC14 LOC21 LOC22 LOC23 LOC24 LOC31 LOC32 LOC33 LOC34 - localizacion          ; Creamos un mapa de 3x4 (empezando pos la localización 11 y acabando por la 34)
        
        CentroDeMando1 - edificio                   ; También nos indica que necesitamos un centro de mando que es de tipo edificio
        VCE1 - unidad                               ; Es importante declarar nuestra unidad, pues será la que recoga el recurso
                                                  
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
    
        ; Inicializamos la localización en la que se encuentra el centro de Mando y la unidad VCE1
        (En CentroDeMando1 LOC11)       
        (En VCE1 LOC11)  

        ; Declararemos también, que VCE1 es de tipo vce
        (UnidadEs VCE1 vce)               
        
        ; Asignaremos también dos nodos de minerales a unas localizaciones concretas indicadas
        ; no necesitamos declarar objetos de recursos, ya que sólo necesitamos asignar un mineral a un nodo
        (AsignaNodo minerales LOC23)     
        (AsignaNodo minerales LOC33)
    
        
    )
    
    (:goal
        (and
            ; El objetivo del ejercicio es generar recursos de tipo mineral
            ; Como se nos indica, cuando asignamos un VCE a un nodo de recursos (ya sea mineral o gas Vespeno), ya tendremos recursos ilimitamos de este tipo
            ; Por tanto, sólo será necesario recoger alguno de los dos recursos
            ; Además, como solo tenemos una VCE, sólo podemos llegar a uno de los dos recursos que hay en el mapa, puesto que la unidad no podrá hacer nada más el resto de la ejecución
            ; Para ello, utilizaremos un exists, de forma que buscará un único recurso. Como estamos utilizando optimización, la VCE irá al recurso que se encuentre más cercano en el mapa
            (exists (?r - tipoRecurso) 
                (obtenerRecurso ?r))
        
        )
    
    
    
    
    
    )







)