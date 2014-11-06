//
//  ViewController.h
//  Data URL image extractor
//
//  Created by Nicolas Mahe on 06/11/14.
//  Copyright (c) 2014 Nicolas Mahe. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController

- (IBAction)tapButtonChooseFile:(id)sender;
- (IBAction)tapButtonLauchAnalyze:(id)sender;
- (IBAction)tapButtonChooseExportFolder:(id)sender;
@property (weak) IBOutlet NSTextField *labelFileChoosed;
@property (weak) IBOutlet NSButton *buttonLauchAnalyze;
@property (weak) IBOutlet NSProgressIndicator *loadingIndicator;
@property (weak) IBOutlet NSTextField *labelInProgress;
@property (weak) IBOutlet NSTextField *labelExportFolder;
@property (weak) IBOutlet NSTextField *labelUrlFolder;
@property (weak) IBOutlet NSTextField *textfieldUrlFolder;
@property (weak) IBOutlet NSButton *buttonChooseFile;
@property (weak) IBOutlet NSButton *buttonExportFolder;

@end

