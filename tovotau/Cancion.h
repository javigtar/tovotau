//
//  Canciones.h
//  BaseDeDatos
//
//  Created by alumno on 21/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Cancion : NSObject

@property (nonatomic) NSString *id_cancion;
@property (nonatomic) NSString *nombreCancion;
@property (nonatomic) NSString *artista;
@property (nonatomic) NSString *album;
@property (nonatomic) NSString *imagenUrl;
@property (nonatomic) NSNumber *duracion;
@property (nonatomic) NSNumber *votos;

@end
