//
//  ListaCancionesTableViewController.m
//  BaseDeDatos
//
//  Created by alumno on 21/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "ListaCancionesTableViewController.h"
#import "ControladorVotos.h"

@interface ListaCancionesTableViewController ()

@property (nonatomic,strong) CancionesDAO *listaCanciones;

@property (nonatomic,strong) NSArray *canciones;
@property (nonatomic,strong) NSArray *cancionesFiltradas;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)votarCancion:(UIButton *)sender;
- (IBAction)quitarVotoCancion:(UIButton *)sender;

@end

@implementation ListaCancionesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listaCanciones = [[CancionesDAO alloc] init];
    [self.listaCanciones cargarListaCanciones];
    
    //Ponemos como delegado del search bar a esta clase
    self.searchBar.delegate = self;
    
}

//Se llamara a este metodo cada vez que aparezca la vista
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //Guardamos las canciones en un array
    self.canciones = [self.listaCanciones obtenerCanciones];
    
    //Recargamos el table view para que muestre los votos correctos
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //Comprobamos si el array de canciones filtradas no es nulo para que muestre tantas filas como el total de canciones
    //o como canciones filtradas haya
    if(self.cancionesFiltradas){
        
        return self.cancionesFiltradas.count;
        
    }
    
    return self.canciones.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Obtenemos la referencia a la celda con ese identificador
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cancion" forIndexPath:indexPath];
    
    //Creamos un objeto cancion
    Cancion *cancion;
    
    //Obtenemos la referencia al label con la etiqueta 1 que corresponde a la imagen
    UIImageView *imagen = (UIImageView*)[self.view viewWithTag:1];
    //Obtenemos la referencia al label con la etiqueta 2 que corresponde al artista
    UILabel *artista = (UILabel*)[self.view viewWithTag:2];
    //Obtenemos la referencia al label con la etiqueta 3 que corresponde al nombre de la canción
    UILabel *nombreCancion = (UILabel*)[self.view viewWithTag:3];
    //Obtenemos la referencia al label con la etiqueta 4 que corresponde al álbum
    UILabel *album = (UILabel*)[self.view viewWithTag:4];
    //Obtenemos la referencia al label con la etiqueta 5 que corresponde al id de la cancion
    //No se visualiza nada, solo es para utilizarlo a la hora de votar
    UILabel *id_cancion = (UILabel*)[self.view viewWithTag:5];
    //Obtenemos la referencia al label con la etiqueta 6 que corresponde a los votos
    UILabel *votos = (UILabel*)[self.view viewWithTag:6];
    
    //Comprobamos si el array de canciones filtradas no es nulo para obtener la cancion del array de todas las canciones
    //o del array de las canciones filtradas
    if (self.cancionesFiltradas) {
        
        cancion = [self.cancionesFiltradas objectAtIndex:indexPath.row];
        
    } else {
        
        cancion = [self.canciones objectAtIndex:indexPath.row];
    }
    
    //Rellenamos los datos de la canción
    artista.text = cancion.artista;
    nombreCancion.text = cancion.nombreCancion;
    album.text = cancion.album;
    id_cancion.text = cancion.id_cancion;
    votos.text = [cancion.votos stringValue];    
    
    
    //get a dispatch queue
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);    
   
    //Descargamos la imagen en background
    dispatch_async(concurrentQueue, ^{
        
        NSData *imagenData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:cancion.imagenUrl]];
        
        //Cuando finaliza la descarga asiganmos la imagen al UIImageView
        dispatch_async(dispatch_get_main_queue(), ^{
            imagen.image = [UIImage imageWithData:imagenData];
        });
    });
    
    return cell;
}

//Método que se ejecutará cada vez que cambie el texto de la barra de busqueda
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    //Comprobamos si se ha escrito algo en la barra de busqueda
    if (searchBar.text.length > 0) {
        
        //Creamos el predicado que utilizaremos para filtrar las canciones
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"nombreCancion CONTAINS[c] %@ OR artista CONTAINS[C] %@ OR album CONTAINS[c] %@", searchBar.text, searchBar.text, searchBar.text];
        
        //Filtramos las canciones según el predicado
        self.cancionesFiltradas = [self.canciones filteredArrayUsingPredicate:resultPredicate];
        
     //Si no hay nada escrito en la barra de busqueda ponemos a nil el array de canciones filtradas para que muestre
     //toda la lista de canciones al recargar el tableview
    }else{
        
        self.cancionesFiltradas = nil;
    }
    
    //Recargamos los datos de la tabla
    [self.tableView reloadData];
    
}

- (IBAction)votarCancion:(UIButton *)sender {
    
    //Animamos el boton al pulsarlo
    [self animarBotonVotos:sender];
    
    //Modificamos los votos de la cancion
    [self modificarVotoCancion:sender.superview votosAModificar:1];
    
}

- (IBAction)quitarVotoCancion:(UIButton *)sender {
    
    //Animamos el boton al pulsarlo
    [self animarBotonVotos:sender];
    
    //Modificamos los votos de la cancion
    [self modificarVotoCancion:sender.superview votosAModificar:-1];

}

-(void)animarBotonVotos:(UIButton*)boton{
    
    //Obtenemos la referencia al imageview del botón
    UIImageView *imagenBoton = boton.imageView;
    
    //Animamos la imagen
    [UIView animateWithDuration: 0.1 delay: 0.0 options: UIViewAnimationOptionAutoreverse animations:^{
        imagenBoton.transform = CGAffineTransformMakeScale(2, 2);
    }completion:^(BOOL finished){
        imagenBoton.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

-(void)modificarVotoCancion:(UIView*)filaCancion votosAModificar:(NSInteger)votos{
    
    //Obtemos la referencia al label del id de la cancion
    UILabel *id_cancion = (UILabel*)[filaCancion viewWithTag:5];
    //Obtenemos la referencia al label con la etiqueta 6 que corresponde a los votos
    UILabel *numVotos = (UILabel*)[filaCancion viewWithTag:6];
    
    //Obtenemos los votos restantes del usuario
    NSNumber *votosRestantes = [[ControladorVotos instanciaControladorVotos] votosRestantes];
    
    //Comprobamos si los votos restantes son mayores que 0
    if ([votosRestantes intValue] > 0) {
        
        //Modificamos los votos de la cancion con ese id en la base de datos
        [self.listaCanciones modificarVotosCancion:id_cancion.text votosCancion:[numVotos.text intValue] + votos];
        
        //Ponemos en el label los votos nuevos
        numVotos.text = [[NSString alloc] initWithFormat:@"%ld", [numVotos.text intValue] + votos];
        
        //Restamos 1 a los votos restantes
        votosRestantes = [NSNumber numberWithInt:[votosRestantes intValue] -1];
        
        //Actualizamos los votos
        [[ControladorVotos instanciaControladorVotos] actualizarVotos:[votosRestantes integerValue]];
        
        //Creamos el mensaje que se mostrará en un alert
        NSString *mensaje = [[NSString alloc]initWithFormat:@"%d\rGracias por participar", [votosRestantes intValue]];
        
        //Mostramos el alert con el mensaje
        [self mostrarAlertView:@"Votos Restantes" mensajeAMostrar:mensaje];
        
    }else{       
        
        //Mostramos el alert con el mensaje
        [self mostrarAlertView:@"Votos Insuficientes" mensajeAMostrar:@"No te quedan mas votos para seguir votando."];
    }
    
}

//Muestra un cuadro de alerta con el titulo y el mensaje pasados como parametro
-(void)mostrarAlertView:(NSString*)titulo mensajeAMostrar:(NSString*)mensaje{
    
    UIAlertView *informacion = [[UIAlertView alloc] initWithTitle:titulo message:mensaje delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    
    [informacion show];
}

@end
