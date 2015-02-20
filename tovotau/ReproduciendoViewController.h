//
//  ReproduciendoViewController.h
//  tovotau
//
//  Created by alumno on 27/01/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReproduciendoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *banner;
@property (weak, nonatomic) IBOutlet UILabel *labelCancionPrincipal;
-(void) modificarLabelAnimado:(NSString*) cadena;
@property (weak, nonatomic) IBOutlet UIImageView *imagenCancion;
@property (weak, nonatomic) IBOutlet UILabel *tituloCancion;



@end
