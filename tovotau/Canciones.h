//
//  Canciones.h
//  BaseDeDatos
//
//  Created by alumno on 21/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Canciones : NSObject{
    NSInteger cod_cancion;
    NSString *nombreCancion;
    NSString *artista;
    NSString *album;
    NSString *imagen;
}
@property (nonatomic) NSInteger cod_cancion;
@property (nonatomic) NSString *nombreCancion;
@property (nonatomic) NSString *artista;
@property (nonatomic) NSString *album;
@property (nonatomic) NSString *imagen;


@end
