//
//  ListaCancionesTableViewController.m
//  BaseDeDatos
//
//  Created by alumno on 21/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "ListaCancionesTableViewController.h"

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
    
    //Guardamos las canciones en un array
    self.canciones = [self.listaCanciones obtenerCanciones];
    
    //Ponemos como delegado del search bar a esta clase
    self.searchBar.delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    
    //Sumamos un voto a la cancion con ese id en la base de datos
    [self.listaCanciones modificarVotosCancion:id_cancion.text votosCancion:[numVotos.text intValue] + votos];
    
    //Ponemos en el label los votos nuevos
    numVotos.text = [[NSString alloc] initWithFormat:@"%ld", [numVotos.text intValue] + votos];
    
    
}


/*
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    //[self filterContentForSearchText:searchString scope:[[self. scopeButtonTitles]
                                                         //objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
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


@end
