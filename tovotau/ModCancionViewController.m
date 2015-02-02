//
//  ModCancionViewController.m
//  BaseDeDatos
//
//  Created by alumno on 26/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "ModCancionViewController.h"

@interface ModCancionViewController ()

@end

@implementation ModCancionViewController


@synthesize etqNombre;
@synthesize etqArtista;
@synthesize etqAlbum;
@synthesize txtNombre;
@synthesize txtArtista;
@synthesize txtAlbum;
@synthesize imagen;
@synthesize dao;
@synthesize cancion;

-(void) touchesBegan :(NSSet *) touches withEvent:(UIEvent *)event{
    
    
    [txtNombre resignFirstResponder];
    [txtAlbum resignFirstResponder];
    [imagen resignFirstResponder];
    [txtArtista resignFirstResponder];
    
    [super touchesBegan:touches withEvent:event ];
    
    
    
}



- (IBAction)ocultarTeclado:(id)sender{
    
    
    
}



- (void)viewDidLoad

{

    [txtNombre setText:cancion.nombreCancion];
    [txtAlbum setText:[NSString stringWithFormat:@"%@", cancion.album]];
    [txtArtista setText:[NSString stringWithFormat:@"%@", cancion.artista]];
    


    dao = [[CancionesDAO alloc] init];

    [super viewDidLoad];

}
@end

