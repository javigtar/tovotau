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

@interface CancionesDAO : NSObject{
    sqlite3* bd;
    
}
- (NSMutableArray *) obtenerCanciones;
- (NSMutableArray *) obtenerTop5;

- (NSString *) obtenerRuta;

-(NSUInteger) numeroDeCanciones;
-(Cancion*) cancionSegunIndice:(NSInteger) indiceDeCancion;

-(void)sumarVotoACancion:(NSString*) id_cancion;

@end
