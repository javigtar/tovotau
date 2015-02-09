//
//  EscanerQRViewController.m
//  tovotau
//
//  Created by alumno on 9/2/15.
//  Copyright (c) 2015 alumno. All rights reserved.
//

#import "EscanerQRViewController.h"

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
    
    /*
    label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, self.view.bounds.size.height - 40, self.view.bounds.size.width, 40);
    label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"(none)";
    [self.view addSubview:label];
     */
    
    self.codigoQRTexto.text = @"Escaneando...";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)botonAceptar:(id)sender {
    
    
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
        else
            self.codigoQRTexto.text = @"Escaneando...";
    }
    
    highlightView.frame = highlightViewRect;
}

@end
