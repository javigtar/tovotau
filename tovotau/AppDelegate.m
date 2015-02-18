//
//  AppDelegate.m
//  prueba
//
//  Created by alumno on 14/1/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UITabBarController* barController = (UITabBarController*)self.window.rootViewController;
    UITabBarItem *itemUno = barController.tabBar.items[0];
    [itemUno setTitle:@"Reproduciendo"];
    [itemUno setImage:[UIImage imageNamed:@"reproducir.jpg"]];//setImage MODIFICA LA IMAGEN DEL ITEM
    [itemUno setSelectedImage:[UIImage imageNamed:@"champagne.png"]];//CAMBIA LA IMAGEN CUANDO EL ITEM ES SELECCIONADO
    UITabBarItem *itemDos = barController.tabBar.items[1];
    [itemDos setTitle:@"Lista"];
    [itemDos setImage:[UIImage imageNamed:@"list.png"]];
    UITabBarItem *itemTres = barController.tabBar.items[2];
    [itemTres setTitle:@"Perfil"];
    [itemTres setImage:[UIImage imageNamed:@"perfil.png"]];
    UITabBarItem *itemCuatro = barController.tabBar.items[3];
    [itemCuatro setTitle:@"Vota ya"];
    [itemCuatro setImage:[UIImage imageNamed:@"qr.png"]];
    
    [[UITabBar appearance] setTintColor:[UIColor redColor]]; //ESTO CAMBIARÍA EL COLOR DEL ITEM SELECCIONADO
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"backgroundImg.jpg"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"superpuesta.png"]];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
