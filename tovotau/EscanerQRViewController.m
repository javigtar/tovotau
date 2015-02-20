//
//  EscanerQRViewController.m
//  tovotau
//
//  Created by alumno on 9/2/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "EscanerQRViewController.h"
#import "CancionesDAO.h"
#import "ControladorVotos.h"

@interface EscanerQRViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    
    AVCaptureSession *session;
    AVCaptureDevice *device;
    AVCaptureDeviceInput *input;
    AVCaptureMetadataOutput *output;
    AVCaptureVideoPreviewLayer *prevLayer;
    
    UIView *highlightView;
    //UILabel *label;
}


@property (weak, nonatomic) IBOutlet UIView *cameraPreview;
@property (weak, nonatomic) IBOutlet UITextView *codigoQRTexto;
- (IBAction)botonAceptar:(id)sender;



@end

@implementation EscanerQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    highlightView = [[UIView alloc] init];
    highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    highlightView.layer.borderWidth = 3;
    [self.view addSubview:highlightView];
    
    self.codigoQRTexto.textAlignment = NSTextAlignmentCenter;
    
    session = [[AVCaptureSession alloc] init];
    device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (input) {
        [session addInput:input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [session addOutput:output];
    
    output.metadataObjectTypes = [output availableMetadataObjectTypes];
    
    prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    prevLayer.frame = self.cameraPreview.bounds;
    prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:prevLayer];
    
    [session startRunning];
    
    [self.view bringSubviewToFront:highlightView];
    //[self.view bringSubviewToFront:label];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)botonAceptar:(id)sender {
    
    [self comprobarCodigoQR];
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barCodeObject;
    NSString *detectionString = nil;
    NSArray *barCodeTypes = @[AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeQRCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barCodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barCodeObject = (AVMetadataMachineReadableCodeObject *)[prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barCodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
            self.codigoQRTexto.text = detectionString;
            break;
        }        
    }
    
    highlightView.frame = highlightViewRect;
}

-(void)comprobarCodigoQR{
    
    CancionesDAO *bdCanciones = [[CancionesDAO alloc] init];
    
    NSNumber *votos = [NSNumber numberWithInt:[[bdCanciones canjearCodigoQR:self.codigoQRTexto.text] intValue]];
    
    if ([votos intValue] != 0 ) {
        
        [ControladorVotos instanciaControladorVotos].votosRestantes = votos;
        
        //Creamos el mensaje que se mostrará en un alert
        NSString *mensaje = [[NSString alloc]initWithFormat:@"Has ganado %d votos", [votos intValue]];
        
        //Mostramos un alert con el mensaje
        [self mostrarAlertView:@"" mensajeAMostrar:mensaje];
        
    }else{
        
        //Mostramos un alert con el mensaje
        [self mostrarAlertView:@"" mensajeAMostrar:@"Codigo incorrecto"];
        
    }
    
    
}

//Muestra un cuadro de alerta con el titulo y el mensaje pasados como parametro
-(void)mostrarAlertView:(NSString*)titulo mensajeAMostrar:(NSString*)mensaje{
    
    UIAlertView *informacion = [[UIAlertView alloc] initWithTitle:titulo message:mensaje delegate:self cancelButtonTitle:@"Aceptar" otherButtonTitles:nil, nil];
    
    [informacion show];
}

@end
