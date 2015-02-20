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
#import "ControladorVotos.h"

@interface ReproduciendoViewController ()

@property (weak, nonatomic) IBOutlet MarqueeLabel *proximasCanciones;
@property (nonatomic, strong) NSMutableArray *listaCanciones;
@property (weak, nonatomic) IBOutlet UILabel *votosRestantes;
@property (nonatomic, assign) BOOL reproduciendo;
@end

@implementation ReproduciendoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.reproduciendo=YES;
    //Instanciamos la clase engargada de obtener las canciones de la BD
    CancionesDAO *cancionesDAO = [[CancionesDAO alloc] init];
    
    //Añadimos las canciones de la BD a una MutableArray
    self.listaCanciones = [cancionesDAO obtenerCanciones];

 
   //Bucle que se ejecutara cada 15 segundos llamando a la funcion para llamar al banner
    [NSTimer scheduledTimerWithTimeInterval:15.0f
                                     target:self selector:@selector(cambioImagenTemporal) userInfo:nil repeats:YES];
    
   [NSTimer scheduledTimerWithTimeInterval:20.0f//pongo 20 segundos para la exposicion ya que por ahora no tenemos el tiempo de cada cancion real
                                  target:self selector:@selector(reproducirCanciones) userInfo:nil repeats:YES];
   
    
    [self mostrarTop5Canciones];
}

//Se llamara a este metodo cada vez que aparezca la vista
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Ponemos el valor de los votos restantes
    self.votosRestantes.text = [[[ControladorVotos instanciaControladorVotos] votosRestantes]stringValue];
    
    [self mostrarTop5Canciones];

}

-(void)reproducirCanciones{
 CancionesDAO *cancionDAO = [[CancionesDAO alloc] init];
    //obtengo el que mas votos tiene
   NSString* top1 = [cancionDAO DevuelveTop1Cancion];
    //cambio los votos a 0 ya que la cancion ya s eha reproducido
 [cancionDAO modificarVotosCancion:top1 votosCancion:0];
  //vuelvo a hacer un select de los 5 primeros.
   [self mostrarTop5Canciones];
  
}


-(void)modificarLabelAnimado:(NSString*) cadena{
   // NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cadena];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:cadena];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Helvetica-Bold" size:18.0f] range:NSMakeRange(0,0)];
    [attributedString addAttribute:NSBackgroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(10,11)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,attributedString.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Light" size:18.0f] range:NSMakeRange(21, attributedString.length - 21)];
    
    self.proximasCanciones.attributedText = attributedString;
    
    // Animación del label de la lista de canciones
    self.proximasCanciones.marqueeType = MLContinuous;
    self.proximasCanciones.scrollDuration = 20.0;
    self.proximasCanciones.fadeLength = 15.0f;
    self.proximasCanciones.leadingBuffer = 40.0f;
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
                      duration:5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.banner.image = toImage;
                    } completion:nil];
    
    
    

}

-(void)cambioImagenTemporal{//Creo un hilo de proceso nuevo para no perjudicar a la vista cada vez que llame a la funcion cambiarImagen.
 
    NSThread* HiloImagen = [[NSThread alloc] initWithTarget:self
                                                        selector:@selector(cambiarImagenBanner)
                                                          object: nil];
    
    
    
    [HiloImagen start];
    
    
    
}



-(void)mostrarTop5Canciones{//esta clase mostrara tanto la cancionq ue se esta reproduciendo como las 4 restantes en el label de abajo
    NSMutableString* strRR=[[NSMutableString alloc]init];//la pondremos en el label
    
    NSMutableArray *top5Canciones = [[NSMutableArray alloc ]init];
    CancionesDAO *miscancionesdao = [[CancionesDAO alloc]init ];
    
    top5Canciones = [miscancionesdao obtenerTop5];
    
    //midiante el select obtengo las 5 mas votadas
    for (int i=1; i<=4; i++) {
        //las recorro y relleno el mutablestring
        Cancion *CancionTop = [[Cancion alloc] init];
        CancionTop = [top5Canciones objectAtIndex: i];
        NSString* nombreTop1 = CancionTop.nombreCancion;
        NSString* artista = CancionTop.artista;
        NSString *numeroCancion =[NSString stringWithFormat:@"%d",i+1];
        [strRR appendString:numeroCancion];
        [strRR appendString:@" : "];
        [strRR appendString:nombreTop1];
        [strRR appendString:@"  -  "];
        [strRR appendString:artista];
        [strRR appendString:@"          "];
    }
    
    Cancion *top1Cancion = [top5Canciones objectAtIndex: 0];
    NSMutableString* nombreTop1=[[NSMutableString alloc]init];
    [nombreTop1 appendString:top1Cancion.nombreCancion];
    [nombreTop1 appendString:@" - "];
    [nombreTop1 appendString:top1Cancion.artista];
    
    NSString *ImageURL = top1Cancion.imagenUrl;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:ImageURL]];
    self.imagenCancion.image = [UIImage imageWithData:imageData];
    
    [self.labelCancionPrincipal setText:nombreTop1];
    [self modificarLabelAnimado:strRR];
}


@end
