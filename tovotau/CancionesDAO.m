//
//  CancionesDAO.m
//  BaseDeDatos
//
//  Created by alumno on 21/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "CancionesDAO.h"
#import "Cancion.h"
#import <sqlite3.h>

@interface CancionesDAO(){
    
    //Creamos un objeto de tipo sqlite3
    sqlite3 *sqliteDB;
    
}

@property (nonatomic, strong) NSString *directorioAplicacion;
@property (nonatomic, strong) NSString *nombreBD;

@property (nonatomic,strong) NSMutableArray *listaCanciones;

-(void)copiarBDalDirectorio;

@end

@implementation CancionesDAO



-(id)init{
    self = [super init];
    
    //self.listaCanciones = [self obtenerCanciones];
    
    
    // Set the documents directory path to the documentsDirectory property.
    NSArray *rutas = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.directorioAplicacion = [rutas objectAtIndex:0];
    
    // Keep the database filename.
    self.nombreBD = @"definitiva.sqlite";
    
    // Copy the database file into the documents directory if necessary.
    [self copiarBDalDirectorio];
    
    [self cargarListaCanciones];
    
    return self;
    
}

//CAMBIAR PARA QUE NO BORRE SIEMPRE LA BD CUANDO LA BD FUNCIONE CORRECTAMENTE


-(void)copiarBDalDirectorio{
    
        //Obtenemos la ruta donde queremos guardar la base de datos
        NSString *rutaDestinoBD = [self.directorioAplicacion stringByAppendingPathComponent:self.nombreBD];
    
        //Obtenemos la ruta donde se guarda el archivo de la base de datos de nuestro proyecto
        NSString *rutaOrigenBD = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.nombreBD];
    
        //String para almacenar los errores
        NSError *error;
    
        //Comprobamos si ya existe el archivo de la base de datos en el directorio de la aplicacion para borrarla
        if([[NSFileManager defaultManager] fileExistsAtPath:rutaDestinoBD] == YES){
            
            [[NSFileManager defaultManager] removeItemAtPath:rutaDestinoBD error:&error];
        }
    
        //Copiamos la base de datos de nuestro proyecto a nuestro directorio de los documentos de nuestra aplicacion
        [[NSFileManager defaultManager] copyItemAtPath:rutaOrigenBD toPath:rutaDestinoBD error:&error];
    
    
        // Comprobamos si ha habido algún error para mostrarlo
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    //}
}

/*
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
 */


-(NSMutableArray *)obtenerTop5{
    //Esta funcion obtiene las 5 primeras canciones mas votadas
    NSMutableArray *top5 = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self rutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &sqliteDB) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    const char *sentenciaSQL = "SELECT * FROM canciones;";
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare_v2(sqliteDB, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
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


/*
//Devuelve un array con las canciones de la base de datos
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
*/

//Devolvemos un string con la ruta de la base de datos
-(NSString*)rutaBD{
    
    return [self.directorioAplicacion stringByAppendingPathComponent:self.nombreBD];
}


//Devolvemos un array con las canciones de la base de datos
- (NSMutableArray *) obtenerCanciones{
    
    return self.listaCanciones;
    
}

//Guarda las canciones de la base de datos en un array
-(void) cargarListaCanciones{
   
    
    //Comprobamos si el array de canciones existe ya para borrar las canciones que existan
    if (self.listaCanciones != nil) {
        [self.listaCanciones removeAllObjects];
        self.listaCanciones = nil;
    }
    
    //Inicializamos el array de canciones
    self.listaCanciones = [[NSMutableArray alloc] init];
    
    //Comprobamos si la base de datos se ha abierto correctamente
    if(sqlite3_open([[self rutaBD] UTF8String], &sqliteDB) != SQLITE_OK){
        
        NSLog(@"No se puede conectar con la BD");
    }
    
    sqlite3_stmt *sqlStatement;
    
    const char *sentenciaSQL = "SELECT * FROM canciones;";
    
    //Cargamos en memoria los datos de la base de datos
    if (sqlite3_prepare_v2(sqliteDB, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        
        NSLog(@"Problema al preparar el statement");
    }
    
    //Recorremos el restultado de la consulta
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
        
        [self.listaCanciones addObject:cancion];
        
    }
    
}

//Suma un voto a la canción
-(void)sumarVotoACancion:(NSString*) id_cancion votosActuales:(NSInteger)votos{
    
    //Comprobamos si se puede conectar
    if((sqlite3_open([[self rutaBD] UTF8String], &sqliteDB) != SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    //Creamos la sentencia sql
    //const char *sentenciaSQL = "UPDATE canciones SET votos = ? WHERE id = ?";
    
    NSString *sql = [NSString stringWithFormat:@"UPDATE canciones SET votos = %ld WHERE id = %d", votos + 1, [id_cancion intValue]];    
    
    const char *sentenciaSQL = [sql UTF8String];
    
    //Creamos un statement
    sqlite3_stmt *sqlStatement;
    
    //Preparamos el statement
    if(sqlite3_prepare_v2(sqliteDB, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
        NSLog(@"%s", sqlite3_errmsg(sqliteDB));
    }
    
    //sqlite3_bind_int(sqlStatement, 1, 2);
    
    //Añadimos al statement el parametro por el que modificará la canción
    //sqlite3_bind_int(sqlStatement, 2, [id_cancion intValue]);
    
    //Ejecutamos el statement
    
    if(sqlite3_step(sqlStatement) != SQLITE_OK){
        
        NSLog(@"%s", sqlite3_errmsg(sqliteDB));
    }
    
    
    //Finalizamos el statement
    sqlite3_finalize(sqlStatement);
    
    //Cerramos la conexion a la BD
    sqlite3_close(sqliteDB);
}

//Quitamos un voto a la canción
-(void)restarVotoACancion:(NSString*) id_cancion{
    
    
    //Comprobamos si se puede conectar
    if(!(sqlite3_open([[self rutaBD] UTF8String], &sqliteDB) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    //Creamos la sentencia sql
    const char *sentenciaSQL = "INSERT INTO canciones VALUES votos = votos - 1 WHERE id_cancion = ?";
    
    //Creamos un statement
    sqlite3_stmt *sqlStatement;
    
    //Preparamos el statement
    if(sqlite3_prepare_v2(sqliteDB, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
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
