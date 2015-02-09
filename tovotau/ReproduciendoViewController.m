//
//  ReproduciendoViewController.m
//  tovotau
//
//  Created by alumno on 27/01/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "ReproduciendoViewController.h"
#import "MarqueeLabel.h"
#import "CancionesDAO.h"
#import "Canciones.h"

@interface ReproduciendoViewController ()

@property (weak, nonatomic) IBOutlet MarqueeLabel *proximasCanciones;
@property (nonatomic, strong) NSMutableArray *listaCanciones;

@end

@implementation ReproduciendoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Instanciamos la clase engargada de obtener las canciones de la BD
    CancionesDAO *cancionesDAO = [[CancionesDAO alloc] init];
    
    //Añadimos las canciones de la BD a una MutableArray
    self.listaCanciones = [cancionesDAO obtenerCanciones];
    
    // Animación del label de la lista de canciones
    self.proximasCanciones.marqueeType = MLContinuous;
    self.proximasCanciones.scrollDuration = 8.0;
    self.proximasCanciones.fadeLength = 15.0f;
    self.proximasCanciones.leadingBuffer = 40.0f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[self crearStringProximasCanciones]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f] range:NSMakeRange(0, 21)];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(10,11)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.234 green:0.234 blue:0.234 alpha:1.000] range:NSMakeRange(0,attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f] range:NSMakeRange(21, attributedString.length - 21)];
    self.proximasCanciones.attributedText = attributedString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(void)labelAnimation
{
    [UIView animateWithDuration:7.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        self.proximasCanciones.frame = CGRectMake(-320, self.proximasCanciones.frame.origin.y, self.proximasCanciones.frame.size.width, self.proximasCanciones.frame.size.height);
    } completion:^(BOOL finished)
     {
         self.proximasCanciones.frame = CGRectMake(320, self.proximasCanciones.frame.origin.y, self.proximasCanciones.frame.size.width, self.proximasCanciones.frame.size.height);
     }];
    
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


//Metodo encargado de añadir a un MutableString las proximas canciones
-(NSMutableString*)crearStringProximasCanciones{
    
    NSMutableString *proximasCanciones = [[NSMutableString alloc] init];
    
    [proximasCanciones appendFormat:@" %@", ((Canciones*)self.listaCanciones[0]).nombreCancion];
    
    for (int i = 1; i < 3; i++) {
        
        [proximasCanciones appendFormat:@" - %@", ((Canciones*)self.listaCanciones[i]).nombreCancion];
    }    
    
    return proximasCanciones;
}

@end
