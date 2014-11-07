//
//  Extractor.m
//  Data URL image extractor
//
//  Created by Nicolas Mahe on 07/11/14.
//  Copyright (c) 2014 Nicolas Mahe. All rights reserved.
//

#import "Extractor.h"
#import "Base64.h"
#import <CommonCrypto/CommonDigest.h>

@implementation Extractor

-(void)extractWithFile:(NSString*)sourceFile exportFolder:(NSString*)exportFolder url:(NSString*)url successFunction:(void (^)(NSString*))successFunction
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
        NSString *nowString = [format stringFromDate:[NSDate date]];
        
        NSString* fileToAnalyze = sourceFile;
        NSString* fileToAnalyzeExt = [fileToAnalyze pathExtension];
        
        NSString* fileToSave = [exportFolder stringByAppendingString:[NSString stringWithFormat:@"/export - %@.%@", nowString, fileToAnalyzeExt]];
        
        NSError* error;
        NSString* fileContents = [NSString stringWithContentsOfFile:fileToAnalyze encoding:NSUTF8StringEncoding error:&error];
        
        if(error != nil) {
            NSLog(@"error: %@", error);
        } else {
            NSString* folderToSave = [exportFolder stringByAppendingString:@"/images/"];
            [[NSFileManager defaultManager] createDirectoryAtPath:folderToSave withIntermediateDirectories:YES attributes:nil error:nil];
            
            NSString* newFile = [self replaceImageInString:fileContents withUrl:url saveInFolder:folderToSave];
            [self saveString:newFile toFile:fileToSave];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(){
            if(successFunction != nil) {
                successFunction(@"success");
            }
        });
    });
    
}

-(NSString*)replaceImageInString:(NSString*)string withUrl:(NSString*)urlFolder saveInFolder:(NSString*)folderToSave
{
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([\"'])data:image/(png|jpeg|gif);base64,([a-zA-Z0-9/;+=]*)[\"']" options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Couldn't create regex with given string and options");
        return nil;
    }
    
    NSString* stringCopy = [string copy];
    
    NSRange range = NSMakeRange(0, string.length);
    NSArray* matches = [regex matchesInString:string options:0 range:range];
    int rangeDecalage = 0;
    
    for (NSTextCheckingResult* match in matches) {
        //quote type
        NSRange group0 = [match rangeAtIndex:1];
        NSString* quoteType = [string substringWithRange:group0];
        
        //image type
        NSRange group1 = [match rangeAtIndex:2];
        NSString* imageType = [string substringWithRange:group1];
        
        //image data
        NSRange group2 = [match rangeAtIndex:3];
        NSString* matchText = [string substringWithRange:group2];
        
        NSData* image = [self convertFromBase64ToImage:matchText];
        NSString* md5 = [self md5:matchText];
        
        if([imageType isEqualToString:@"jpeg"]) {
            imageType = @"jpg";
        }
        
        NSString* nomFichierImage = [NSString stringWithFormat:@"%@.%@", md5, imageType];
        
        if(folderToSave != nil) {
            [self saveData:image toFile:[folderToSave stringByAppendingString:nomFichierImage]];
        }
        
        if([[urlFolder substringFromIndex:[urlFolder length] - 1] isEqualToString:@"/"]) {
            urlFolder = [urlFolder substringToIndex:urlFolder.length-1];
        }
        
        NSString* replaceByString = [NSString stringWithFormat:@"%@%@/%@%@", quoteType, urlFolder, nomFichierImage, quoteType];
        
        NSString* stringStart = [stringCopy substringToIndex:[match range].location - rangeDecalage];
        NSString* stringEnd = [stringCopy substringFromIndex:[match range].location + [match range].length - rangeDecalage];
        stringCopy = [stringStart stringByAppendingString:[replaceByString stringByAppendingString:stringEnd]];
        rangeDecalage += [match range].length - [replaceByString length];
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
