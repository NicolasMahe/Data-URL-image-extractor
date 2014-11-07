//
//  ViewController.m
//  Data URL image extractor
//
//  Created by Nicolas Mahe on 06/11/14.
//  Copyright (c) 2014 Nicolas Mahe. All rights reserved.
//

#import "ViewController.h"
#import "Extractor.h"

@implementation ViewController

#pragma mark UI

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.labelFileChoosed setStringValue:NSLocalizedString(@"None", nil)] ;
    [self.labelExportFolder setStringValue:NSLocalizedString(@"None", nil)];
    [self.labelInProgress setHidden:YES];
    [self.loadingIndicator setHidden:YES];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];
    
    // Update the view, if already loaded.
}

- (IBAction)tapButtonChooseFile:(id)sender {
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:YES];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setCanChooseDirectories:NO];
    
    if ( [openDlg runModal] == NSModalResponseOK ) {
        NSArray* urls = [openDlg filenames];
        
        for(int i = 0; i < [urls count]; i++ ) {
            NSString* url = [urls objectAtIndex:i];
            
            if(url != nil) {
                [self.labelFileChoosed setStringValue:url];
                [self checkIfAnalyzeIsReady];
            }
        }
    }
}


- (IBAction)tapButtonChooseExportFolder:(id)sender {
    
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    [openDlg setCanChooseFiles:NO];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setCanCreateDirectories:YES];
    
    if ( [openDlg runModal] == NSModalResponseOK ) {
        NSArray* urls = [openDlg filenames];
        
        for(int i = 0; i < [urls count]; i++ ) {
            NSString* url = [urls objectAtIndex:i];
            
            if(url != nil) {
                [self.labelExportFolder setStringValue:url];
                [self checkIfAnalyzeIsReady];
            }
        }
    }
}


- (IBAction)tapButtonLaunchAnalyze:(id)sender {
    [self launchExtraction];
}



#pragma mark analyze


-(BOOL)checkIfAnalyzeIsReady
{
    if([[self.labelFileChoosed stringValue] isEqualToString:NSLocalizedString(@"None", nil)]) {
        [self.labelInProgress setHidden:NO];
        [self.labelInProgress setStringValue:NSLocalizedString(@"Please choose the file to analyze", nil)];
    } else if([[self.labelExportFolder stringValue] isEqualToString:NSLocalizedString(@"None", nil)]) {
        [self.labelInProgress setHidden:NO];
        [self.labelInProgress setStringValue:NSLocalizedString(@"Please choose an export folder", nil)];
    } else if([[self.textfieldUrlFolder stringValue] isEqualToString:@""]) {
        [self.labelInProgress setHidden:NO];
        [self.labelInProgress setStringValue:NSLocalizedString(@"Please enter the url", nil)];
    } else {
        return YES;
    }
    
    return NO;
}

-(void)launchExtraction
{
    if(![self checkIfAnalyzeIsReady]) {
        return;
    }
    
    [self.labelInProgress setHidden:NO];
    [self.loadingIndicator setHidden:NO];
    [self.loadingIndicator startAnimation:self];
    
    [self.buttonChooseFile setEnabled:NO];
    [self.buttonExportFolder setEnabled:NO];
    [self.textfieldUrlFolder setEnabled:NO];
    [self.buttonLaunchAnalyze setEnabled:NO];
    [self.labelInProgress setStringValue:NSLocalizedString(@"Extraction in progress", nil)];
    
    Extractor* extractor = [[Extractor alloc] init];
    [extractor extractWithFile:[self.labelFileChoosed stringValue] exportFolder:[self.labelExportFolder stringValue] url:[self.textfieldUrlFolder stringValue] successFunction:^(NSString*status) {
        NSLog(@"status: %@", status);
        [self.buttonChooseFile setEnabled:YES];
        [self.buttonExportFolder setEnabled:YES];
        [self.textfieldUrlFolder setEnabled:YES];
        [self.loadingIndicator setHidden:YES];
        [self.labelInProgress setStringValue:NSLocalizedString(@"Finish", nil)];
        [self.buttonLaunchAnalyze setEnabled:YES];
    }];
    
}


@end
