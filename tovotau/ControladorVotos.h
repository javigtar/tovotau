//
//  ControladorVotos.h
//  tovotau
//
//  Created by Javi on 20/02/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ControladorVotos : NSObject

@property (nonatomic,strong) NSNumber *votosRestantes;

+(ControladorVotos*)instanciaControladorVotos;

-(void)actualizarVotos:(NSInteger)numVotos;

@end
