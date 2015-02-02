//
//  ModCancionViewController.h
//  BaseDeDatos
//
//  Created by alumno on 26/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancionesDAO.h"
#import "Canciones.h"

@interface ModCancionViewController : UIViewController{
   
    IBOutlet UILabel *etqNombre;
    IBOutlet UILabel *etqArtista;
    IBOutlet UILabel *etqAlbum;
    
    IBOutlet UITextField *txtNombre;
    IBOutlet UITextField *txtArtista;
    IBOutlet UITextField *txtAlbum;
    IBOutlet UIImageView *imagen;
 
    CancionesDAO *dao;
   
    Canciones *cancion;
  
}


@property (nonatomic, strong) IBOutlet UILabel *etqNombre;
@property (nonatomic, strong) IBOutlet UILabel *etqArtista;
@property (nonatomic, strong) IBOutlet UILabel *etqAlbum;
@property (nonatomic, strong) IBOutlet UITextField *txtNombre;
@property (nonatomic, strong) IBOutlet UITextField *txtAlbum;
@property (nonatomic, strong) IBOutlet UITextField *txtArtista;
@property (nonatomic, strong) IBOutlet UIImageView *imagen;
@property (nonatomic, strong) Canciones *cancion;
@property (nonatomic, strong) CancionesDAO *dao;

- (IBAction) ocultarTeclado:(id)sender;

@end
