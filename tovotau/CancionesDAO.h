//
//  CancionesDAO.h
//  BaseDeDatos
//
//  Created by alumno on 21/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Cancion.h"

@interface CancionesDAO : NSObject
    
-(NSMutableArray *) obtenerCanciones;
-(NSMutableArray *) obtenerTop5;

-(Cancion*) cancionSegunIndice:(NSInteger) indiceDeCancion;

-(void)modificarVotosCancion:(NSString*)id_cancion votosCancion:(NSInteger)votos;
-(void)eliminarVotos:(NSInteger)id_cancion votosCancion:(NSInteger)votos;
-(NSNumber*)DuracionTop1;

-(NSString*)DevuelveTop1Cancion;
@end
