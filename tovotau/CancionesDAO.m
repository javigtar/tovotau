//
//  CancionesDAO.m
//  BaseDeDatos
//
//  Created by alumno on 21/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "CancionesDAO.h"
#import "Cancion.h"

@implementation CancionesDAO

- (NSString *) obtenerRuta{
    NSString *dirDocs;
    NSArray *rutas;
    NSString *rutaBD;
    rutas = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dirDocs = [rutas objectAtIndex:0];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    rutaBD = [[NSString alloc] initWithString:[dirDocs stringByAppendingPathComponent:@"definitiva.sqlite"]];
    if([fileMgr fileExistsAtPath:rutaBD] == NO){
        [fileMgr copyItemAtPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"definitiva.sqlite"] toPath:rutaBD error:NULL];
    }
    return rutaBD;
}

- (NSMutableArray *) obtenerCanciones{
    NSMutableArray *listaCanciones = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self obtenerRuta];
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    const char *sentenciaSQL = "SELECT * FROM canciones;";
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare_v2(bd, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
        
    }
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        Cancion *cancion = [[Cancion alloc] init];
        cancion.nombreCancion = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        cancion.artista = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        cancion.album = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        //cancion.imagen = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        
        [listaCanciones addObject:cancion];
        
    }
    return listaCanciones;
}


@end
