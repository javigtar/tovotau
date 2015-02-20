//
//  ControladorVotos.m
//  tovotau
//
//  Created by Javi on 20/02/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "ControladorVotos.h"

@interface ControladorVotos()



@end


@implementation ControladorVotos


//Creamos un metodo singleton que nos devolverá un objeto de tipo ControladorVotos si existe, si no existe lo instancia
+(ControladorVotos*)instanciaControladorVotos{
    
    //Creamos una variable estatica del tipo de esta clase
    static ControladorVotos *controladorVotos;
    
    //Comprobamos si la variable es nula
    if (!controladorVotos) {
        
        //Instanciamos la variable
        controladorVotos = [[ControladorVotos alloc] init];
        
    }
    
    return controladorVotos;
    
}


- (id)init {
    
    //Ponemos por defecto 0 votos restantes
    self.votosRestantes = [[NSNumber alloc] initWithInt:0];
    
    return self;
}


//Actualiza los vostos del usuario
-(void)actualizarVotos:(NSInteger)numVotos{
    
    //Ponemos los votos pasados como parámetro
    self.votosRestantes = [NSNumber numberWithInteger:numVotos];
    
}


@end
