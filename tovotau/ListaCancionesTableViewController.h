//
//  ListaCancionesTableViewController.h
//  BaseDeDatos
//
//  Created by alumno on 21/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CancionesDAO.h"
#import "ModCancionViewController.h"

@interface ListaCancionesTableViewController : UITableViewController{
    CancionesDAO* dao;
    NSMutableArray* canciones;
}
@property (nonatomic, strong) NSMutableArray *canciones;
@property (nonatomic, strong) CancionesDAO* dao;


@end
