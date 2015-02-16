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
- (IBAction)validarVotos:(id)sender;

@end

@implementation ListaCancionesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listaCanciones = [[CancionesDAO alloc] init];
    
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

    // Return the number of rows in the section.
    return [self.listaCanciones numeroDeCanciones];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
    Cancion *cancion=[[Cancion alloc]init];
    static NSString *CellIdentifier = @"celda";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSLog(@"%ld",(long)indexPath.row);
    cancion =[canciones objectAtIndex:indexPath.row];
    cell.textLabel.text =cancion.nombreCancion;
     */
    
    //Obtenemos la canción según el índice de la tabla
    Cancion *cancion = [self.listaCanciones cancionSegunIndice:indexPath.row];
    
    //Obtenemos la referencia a la celda
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cancion" forIndexPath:indexPath];
    
    //Asigna a nombre el UILabel de la vista con la etiqueta 2
    UILabel *artista = (UILabel*)[self.view viewWithTag:2];
    artista.text = cancion.artista;
    
    //Asigna a nombre el UILabel de la vista con la etiqueta 3
    UILabel *tituloCancion = (UILabel*)[self.view viewWithTag:3];
    tituloCancion.text = cancion.nombreCancion;
    
    //Asigna a nombre el UILabel de la vista con la etiqueta 4
    UILabel *album = (UILabel*)[self.view viewWithTag:4];
    album.text = cancion.album;
    
    return cell;
    

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Obtenemos la referencia a la celda
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    //Comprobamos si la celda tiene el checkmark para ponerlo. Si lo tiene lo quitamos
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
}

- (IBAction)validarVotos:(id)sender{
    
    
}

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
