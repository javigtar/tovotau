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
#import "Cancion.h"

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
    
   
   //Bucle que se ejecutara cada 15 segundos llamando a la funcion para llamar al banner
    [NSTimer scheduledTimerWithTimeInterval:15.0f
                                     target:self selector:@selector(cambioImagenTemporal) userInfo:nil repeats:YES];
    
    
    
    // Animación del label de la lista de canciones
    self.proximasCanciones.marqueeType = MLContinuous;
    self.proximasCanciones.scrollDuration = 8.0;
    self.proximasCanciones.fadeLength = 15.0f;
    self.proximasCanciones.leadingBuffer = 40.0f;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"This is a long string, that's also an attributed string, which works just as well!"];    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f] range:NSMakeRange(0,5)];
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
    
    [proximasCanciones appendFormat:@" %@", ((Cancion*)self.listaCanciones[0]).nombreCancion];
    
    for (int i = 1; i < 3; i++) {
        
        [proximasCanciones appendFormat:@" - %@", ((Cancion*)self.listaCanciones[i]).nombreCancion];
    }    
    
    return proximasCanciones;
}


-(void)cambiarImagenBanner
{
 
    //genero un random entre 4 ya que solo tenemos 3 imagenes de ese modo alguna vez no habra banner
    int r = rand() % 4;


    NSString *cancion = [[NSString alloc]initWithFormat:@"%d.jpg",r ];
    //cambio la imagen con efecto de imagen dissolve
    UIImage * toImage = [UIImage imageNamed:cancion];
    [UIView transitionWithView:self.banner
                      duration:5.0
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.banner.image = toImage;
                    } completion:nil];
    
    
    

}

-(void)cambioImagenTemporal{//Creo un hilo de proceso nuevo para no perjudicar a la vista cada vez que llame a la funcion cambiarImagen.
 
    NSThread* ThreadMonstruo2 = [[NSThread alloc] initWithTarget:self
                                                        selector:@selector(cambiarImagenBanner)
                                                          object: nil];
    
    
    
    [ThreadMonstruo2 start];
    
    
    
}

@end
