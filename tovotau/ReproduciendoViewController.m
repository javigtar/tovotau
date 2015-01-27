//
//  ReproduciendoViewController.m
//  tovotau
//
//  Created by alumno on 27/01/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "ReproduciendoViewController.h"

@interface ReproduciendoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *proximasCanciones;

@end

@implementation ReproduciendoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.proximasCanciones.text = @"Cancion 1, Cancion 2, Cancion 3, Cancion 4, Cancion 5, Cancion 6, Cancion 7, Cancion 8, Cancion 9, Cancion 10";
    
    [self labelAnimation];
    [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(labelAnimation)
                                   userInfo:nil
                                    repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)labelAnimation
{
    [UIView animateWithDuration:7.0f delay:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
        self.proximasCanciones.frame = CGRectMake(-320, self.proximasCanciones.frame.origin.y, self.proximasCanciones.frame.size.width, self.proximasCanciones.frame.size.height);
    } completion:^(BOOL finished)
     {
         self.proximasCanciones.frame = CGRectMake(320, self.proximasCanciones.frame.origin.y, self.proximasCanciones.frame.size.width, self.proximasCanciones.frame.size.height);
     }];
    
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
