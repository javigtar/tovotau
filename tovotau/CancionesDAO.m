//
//  CancionesDAO.m
//  BaseDeDatos
//
//  Created by alumno on 21/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "CancionesDAO.h"
#import "Cancion.h"

@interface CancionesDAO()

@property (nonatomic,strong) NSMutableArray *listaCanciones;

@end

@implementation CancionesDAO



-(id)init{
    
    self = [super init];
    self.listaCanciones = [self obtenerCanciones];
    return self;
    
}

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


-(NSMutableArray *)obtenerTop5{
    //Esta funcion obtiene las 5 primeras canciones mas votadas
    NSMutableArray *top5 = [[NSMutableArray alloc] init];
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
        
        [top5 addObject:cancion];
        
    }
    return top5;

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
        cancion.id_cancion = [[NSNumber numberWithInt:(int) sqlite3_column_int(sqlStatement, 0)] stringValue];
        cancion.nombreCancion = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        cancion.artista = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        cancion.album = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        //cancion.imagen = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        NSLog(@"%@", [[NSNumber numberWithInt:(int) sqlite3_column_int(sqlStatement, 5)] stringValue]);
        cancion.votos = [NSNumber numberWithInt:(int) sqlite3_column_int(sqlStatement, 5)];
        cancion.duracion = [NSNumber numberWithInt:(int) sqlite3_column_int(sqlStatement, 6)];
        
        [listaCanciones addObject:cancion];
        
    }
    return listaCanciones;
}

//Suma un voto a la canción
-(void)sumarVotoACancion:(NSString*) id_cancion{
    
    //Obtenemos la ruta a la base de datos
    NSString *ubicacionDB = [self obtenerRuta];
    
    //Comprobamos si se puede conectar
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    //Creamos la sentencia sql
    const char *sentenciaSQL = "UPDATE canciones SET votos = ? WHERE id = ?";
    
    //Creamos un statement
    sqlite3_stmt *sqlStatement;
    
    //Preparamos el statement
    if(sqlite3_prepare_v2(bd, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
        NSLog(@"%s", sqlite3_errmsg(bd));
        
    }
    
    sqlite3_bind_int(sqlStatement, 1, 2);
    
    //Añadimos al statement el parametro por el que modificará la canción
    sqlite3_bind_int(sqlStatement, 2    , [id_cancion intValue]);
    
    //Finalizamos el statement
    sqlite3_finalize(sqlStatement);
}

//Quitamos un voto a la canción
-(void)restarVotoACancion:(NSString*) id_cancion{
    
    //Obtenemos la ruta a la base de datos
    NSString *ubicacionDB = [self obtenerRuta];
    
    //Comprobamos si se puede conectar
    if(!(sqlite3_open([ubicacionDB UTF8String], &bd) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    //Creamos la sentencia sql
    const char *sentenciaSQL = "INSERT INTO canciones VALUES votos = votos - 1 WHERE id_cancion = ?";
    
    //Creamos un statement
    sqlite3_stmt *sqlStatement;
    
    //Preparamos el statement
    if(sqlite3_prepare_v2(bd, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
        
    }
    
    //Añadimos al statement el parametro por el que modificará la canción
    sqlite3_bind_int(sqlStatement, 1, [id_cancion intValue]);
    
    //Finalizamos el statement
    sqlite3_finalize(sqlStatement);
}

//Numero de canciones de la base de datos
-(NSUInteger)numeroDeCanciones{
    
    return [self.listaCanciones count];
}

//Devuelve la cancion del indice del Array pasado como parámetro
-(Cancion*) cancionSegunIndice:(NSInteger) indiceDeCancion{
    
    return [self.listaCanciones objectAtIndex:indiceDeCancion];
}

//


@end
