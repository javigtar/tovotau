//
//  TabBarController.m
//  tovotau
//
//  Created by alumno on 18/2/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "TabBarController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITabBar *tabBar=self.tabBar;
    UITabBarItem *itemUno = tabBar.items[0];
    [itemUno setTitle:@"Reproduciendo"];
    [itemUno setImage:[UIImage imageNamed:@"icono.png"]];//setImage MODIFICA LA IMAGEN DEL ITEM
    [itemUno setSelectedImage:[UIImage imageNamed:@"champagne.png"]];//CAMBIA LA IMAGEN CUANDO EL ITEM ES SELECCIONADO
    UITabBarItem *itemDos = tabBar.items[1];
    [itemDos setTitle:@"Lista"];
    [itemDos setImage:[UIImage imageNamed:@"list.png"]];    
    UITabBarItem *itemCuatro = tabBar.items[2];
    [itemCuatro setTitle:@"Vota ya"];
    [itemCuatro setImage:[UIImage imageNamed:@"qr.png"]];
    
    [[UITabBar appearance] setTintColor:[UIColor greenColor]]; //ESTO CAMBIARÍA EL COLOR DEL ITEM SELECCIONADO
   UIImage* tabBarBackground = [UIImage imageNamed:@"fondonegro.jpg"];
    [[UITabBar appearance] setBackgroundImage:tabBarBackground];
    //[[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"backgroundImg.jpg"]];
    //[[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"superpuesta.png"]];
    [[UITabBar appearance] setBackgroundColor:[UIColor blackColor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
