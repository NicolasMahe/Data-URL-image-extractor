//
//  ViewController.m
//  Data URL image extractor
//
//  Created by Nicolas Mahe on 06/11/14.
//  Copyright (c) 2014 Nicolas Mahe. All rights reserved.
//

#import "ViewController.h"
#import "Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation ViewController

#pragma mark UI

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self.labelFileChoosed setStringValue:@"None"];
    [self.labelExportFolder setStringValue:@"None"];
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


- (IBAction)tapButtonLauchAnalyze:(id)sender {
    [self analyzeAndSave];
}



#pragma mark analyze


-(BOOL)checkIfAnalyzeIsReady
{
    if([[self.labelFileChoosed stringValue] isEqualToString:@"None"]) {
        [self.labelInProgress setHidden:NO];
        [self.labelInProgress setStringValue:@"Ples choose the file to analyze"];
    } else if([[self.labelExportFolder stringValue] isEqualToString:@"None"]) {
        [self.labelInProgress setHidden:NO];
        [self.labelInProgress setStringValue:@"Please choose an export folder"];
    } else if([[self.textfieldUrlFolder stringValue] isEqualToString:@""]) {
        [self.labelInProgress setHidden:NO];
        [self.labelInProgress setStringValue:@"Please enter the url"];
    } else {
        return YES;
    }
    
    return NO;
}

-(void)analyzeAndSave
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
    [self.buttonLauchAnalyze setEnabled:NO];
    [self.labelInProgress setStringValue:@"Analyze in progress"];
    
    
    [self performSelectorInBackground:@selector(analyzeAndSaveInBackground) withObject:nil];
}
-(void)analyzeAndSaveInBackground
{
    
    NSString* fileToSave = [[self.labelExportFolder stringValue] stringByAppendingString:@"/new.sql"];
    
    NSString* fileToAnalyze = [self.labelFileChoosed stringValue];
    
    NSError* error;
    NSString * fileContents = [NSString stringWithContentsOfFile:fileToAnalyze encoding:NSUTF8StringEncoding error:&error];
    
    if(error != nil) {
        NSLog(@"error: %@", error);
    } else {
        //NSLog(@"%@", fileContents);
        
        NSString* newSql = [self replaceImageInString:fileContents];
        
        //NSLog(@"newSql: %@", newSql);
        
        [self saveString:newSql toFile:fileToSave];
    }
    
    
    [self performSelectorOnMainThread:@selector(analyzeAndSaveHasFinish) withObject:nil waitUntilDone:NO];
    
}

-(void)analyzeAndSaveHasFinish
{
    [self.buttonChooseFile setEnabled:YES];
    [self.buttonExportFolder setEnabled:YES];
    [self.textfieldUrlFolder setEnabled:YES];
    [self.loadingIndicator setHidden:YES];
    [self.labelInProgress setStringValue:@"Finish"];
    [self.buttonLauchAnalyze setEnabled:YES];
}

-(NSString*)replaceImageInString:(NSString*)string
{
    NSString* folderToSave = [[self.labelExportFolder stringValue] stringByAppendingString:@"/images/"];
    [[NSFileManager defaultManager] createDirectoryAtPath:folderToSave withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\"data:image/(png|jpeg|gif);base64,([a-zA-Z0-9/;+=]*)\"" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error)
    {
        NSLog(@"Couldn't create regex with given string and options");
        return nil;
    }
    
    // Create a range for it. We do the replacement on the whole
    // range of the text view, not only a portion of it.
    NSRange range = NSMakeRange(0, string.length);
    
    
    // Call the NSRegularExpression method to do the replacement for us
    //NSString *afterText = [regex stringByReplacingMatchesInString:string options:0 range:range withTemplate:@""];
    
    NSString* stringCopy = [string copy];
    
    NSArray* matches = [regex matchesInString:string options:0 range:range];
    
    for (NSTextCheckingResult* match in matches) {
        NSRange group1 = [match rangeAtIndex:1];
        NSString* imageType = [string substringWithRange:group1];
        //NSLog(@"imageType: %@", imageType);
        
        NSRange group2 = [match rangeAtIndex:2];
        NSString* matchText = [string substringWithRange:group2];
        //NSLog(@"match: %@", matchText);
        
        NSData* image = [self convertFromBase64ToImage:matchText];
        NSString* md5 = [self md5:matchText];
        
        if([imageType isEqualToString:@"jpeg"]) {
            imageType = @"jpg";
        }
        
        NSString* nomFichierImage = [NSString stringWithFormat:@"%@.%@", md5, imageType];
        
        [self saveData:image toFile:[folderToSave stringByAppendingString:nomFichierImage]];
        
        NSString* replaceByString = [NSString stringWithFormat:@"\"%@/%@\"", [self.textfieldUrlFolder stringValue], nomFichierImage];
        stringCopy = [stringCopy stringByReplacingOccurrencesOfString:[string substringWithRange:[match range]] withString:replaceByString];
        
        //NSLog(@"stringCopy: %@", stringCopy);
        //NSLog(@"[string substringWithRange:[match range]]: %@", [string substringWithRange:[match range]]);
    }
    
    return stringCopy;
}



#pragma mark others

-(void)saveString:(NSString*)string toFile:(NSString*)file
{
    [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
    [string writeToFile:file atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
-(void)saveData:(NSData*)data toFile:(NSString*)file
{
    [[NSFileManager defaultManager] createFileAtPath:file contents:nil attributes:nil];
    [data writeToFile:file atomically:YES];
}

-(NSData*)convertFromBase64ToImage:(NSString*)imageBase64
{
    NSData* data = [Base64 decode:imageBase64];
    
    return data;
}

- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}
@end
