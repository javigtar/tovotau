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
    
    //Obtenemos la ruta al directorio de los documentos de la aplicacion
    NSArray *rutas = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    self.directorioAplicacion = [rutas objectAtIndex:0];
    
    //Nombre de la base de datos
    self.nombreBD = @"definitiva.sqlite";
    
    //Copiamos el archivo de la base de datos al directorio si no existe
    [self copiarBDalDirectorio];
    
    [self cargarListaCanciones];
    
    return self;
    
}


-(void)copiarBDalDirectorio{
    
        //Obtenemos la ruta donde queremos guardar la base de datos
        NSString *rutaDestinoBD = [self.directorioAplicacion stringByAppendingPathComponent:self.nombreBD];
    
        //Obtenemos la ruta donde se guarda el archivo de la base de datos de nuestro proyecto
        NSString *rutaOrigenBD = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.nombreBD];
    
        //String para almacenar los errores
        NSError *error;
    
        //Borra el archivo de la base de datos (En caso de que añadamos o quitemos campos a la tabla)
        //[[NSFileManager defaultManager] removeItemAtPath:rutaDestinoBD error:&error];
    
        //Comprobamos si no existe el archivo de la base de datos en el directorio de la aplicacion
        if([[NSFileManager defaultManager] fileExistsAtPath:rutaDestinoBD] == NO){
            
            //Copiamos la base de datos de nuestro proyecto a nuestro directorio de los documentos de nuestra aplicacion
            [[NSFileManager defaultManager] copyItemAtPath:rutaOrigenBD toPath:rutaDestinoBD error:&error];
            
        }   
    
        // Comprobamos si ha habido algún error para mostrarlo
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    
}

-(NSMutableArray *)obtenerTop5{
    //Esta funcion obtiene las 5 primeras canciones mas votadas
    NSMutableArray *top5 = [[NSMutableArray alloc] init];
    NSString *ubicacionDB = [self rutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &sqliteDB) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    const char *sentenciaSQL = "select * from canciones order by votos desc;";
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare_v2(sqliteDB, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
        
    }
    while(sqlite3_step(sqlStatement) == SQLITE_ROW){
        Cancion *cancion = [[Cancion alloc] init];
        cancion.nombreCancion = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 1)];
        cancion.artista = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
        cancion.album = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
        cancion.imagen = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];
        
        [top5 addObject:cancion];
        
    }
    return top5;

}

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
        cancion.imagen = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];        
        cancion.votos = [NSNumber numberWithInt:(int) sqlite3_column_int(sqlStatement, 5)];
        cancion.duracion = [NSNumber numberWithInt:(int) sqlite3_column_int(sqlStatement, 6)];
        
        [self.listaCanciones addObject:cancion];
        
    }
    
}

//Modifica los votos de una canción
-(void)modificarVotosCancion:(NSString*)id_cancion votosCancion:(NSInteger)votos{
    
    //Comprobamos si se puede conectar
    if((sqlite3_open([[self rutaBD] UTF8String], &sqliteDB) != SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    //Construimos el string de la sentencia
    NSString *sql = [NSString stringWithFormat:@"UPDATE canciones SET votos = %ld WHERE id = %d", votos, [id_cancion intValue]];
    
    //Asignamos el string de la sentencia a esta variable
    const char *sentenciaSQL = [sql UTF8String];
    
    //Creamos un statement
    sqlite3_stmt *sqlStatement;
    
    //Preparamos el statement
    if(sqlite3_prepare_v2(sqliteDB, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
        NSLog(@"%s", sqlite3_errmsg(sqliteDB));
    }
    
    //Ejecutamos el statement
    if(sqlite3_step(sqlStatement) != SQLITE_DONE){
        
        NSLog(@"%s", sqlite3_errmsg(sqliteDB));
    }
    
    sqlite3_changes(sqliteDB);
    
    //Finalizamos el statement
    sqlite3_finalize(sqlStatement);
    
    //Cerramos la conexion a la BD
    sqlite3_close(sqliteDB);
}


//Devuelve la cancion del indice del Array pasado como parámetro
-(Cancion*) cancionSegunIndice:(NSInteger) indiceDeCancion{
    
    return [self.listaCanciones objectAtIndex:indiceDeCancion];
}




-(NSNumber*) DuracionTop1{

    
    
    //Comprobamos si la base de datos se ha abierto correctamente
    if(sqlite3_open([[self rutaBD] UTF8String], &sqliteDB) != SQLITE_OK){
        
        NSLog(@"No se puede conectar con la BD");
    }
    
    sqlite3_stmt *sqlStatement;
    
    const char *sentenciaSQL = "select * from canciones order by votos desc LIMIT 1;";
    
    //Cargamos en memoria los datos de la base de datos
    if (sqlite3_prepare_v2(sqliteDB, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        
        NSLog(@"Problema al preparar el statement");
    }
    Cancion *cancion = [[Cancion alloc] init];

    //Recorremos el restultado de la consulta
        
        cancion.duracion = [NSNumber numberWithInt:(int) sqlite3_column_int(sqlStatement, 6)];
        
    return cancion.duracion;
    
}





-(NSString*) DevuelveTop1Cancion{
    NSString *po;
    //Esta funcion obtiene las 5 primeras canciones mas votadas
    NSString *ubicacionDB = [self rutaBD];
    if(!(sqlite3_open([ubicacionDB UTF8String], &sqliteDB) == SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    const char *sentenciaSQL = "select * from canciones order by votos desc LIMIT 1;";
    sqlite3_stmt *sqlStatement;
    if(sqlite3_prepare_v2(sqliteDB, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
        
    }
    po=@"";
    Cancion *cancion = [[Cancion alloc] init];
   while(sqlite3_step(sqlStatement) == SQLITE_ROW){
       
        cancion.id_cancion = [[NSNumber numberWithInt:(int) sqlite3_column_int(sqlStatement, 0)] stringValue];
       
   }
    
    return cancion.id_cancion;
    
}

/*
-(void)eliminarVotos:(NSInteger)id_cancion votosCancion:(NSInteger)votos{
    
    //Comprobamos si se puede conectar
    if((sqlite3_open([[self rutaBD] UTF8String], &sqliteDB) != SQLITE_OK)){
        NSLog(@"No se puede conectar con la BD");
    }
    
    //Construimos el string de la sentencia
    NSString *sql = [NSString stringWithFormat:@"UPDATE canciones SET votos = %ld WHERE id = %ld", votos,id_cancion];
    
    //Asignamos el string de la sentencia a esta variable
    const char *sentenciaSQL = [sql UTF8String];
    
    //Creamos un statement
    sqlite3_stmt *sqlStatement;
    
    //Preparamos el statement
    if(sqlite3_prepare_v2(sqliteDB, sentenciaSQL, -1, &sqlStatement, NULL) != SQLITE_OK){
        NSLog(@"Problema al preparar el statement");
        NSLog(@"%s", sqlite3_errmsg(sqliteDB));
    }
    
    //Ejecutamos el statement
    if(sqlite3_step(sqlStatement) != SQLITE_DONE){
        
        NSLog(@"%s", sqlite3_errmsg(sqliteDB));
    }
    
    sqlite3_changes(sqliteDB);
    
    //Finalizamos el statement
    sqlite3_finalize(sqlStatement);
    
    //Cerramos la conexion a la BD
    sqlite3_close(sqliteDB);
}
*/


@end
