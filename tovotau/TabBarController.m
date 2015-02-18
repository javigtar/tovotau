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
    UITabBarItem *itemTres = tabBar.items[2];
    [itemTres setTitle:@"Perfil"];
    [itemTres setImage:[UIImage imageNamed:@"perfil.png"]];
    UITabBarItem *itemCuatro = tabBar.items[3];
    [itemCuatro setTitle:@"Vota ya"];
    [itemCuatro setImage:[UIImage imageNamed:@"qr.png"]];
    
    [[UITabBar appearance] setTintColor:[UIColor redColor]]; //ESTO CAMBIARÍA EL COLOR DEL ITEM SELECCIONADO
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"backgroundImg.jpg"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"superpuesta.png"]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
