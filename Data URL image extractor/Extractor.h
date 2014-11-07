//
//  Extractor.h
//  Data URL image extractor
//
//  Created by Nicolas Mahe on 07/11/14.
//  Copyright (c) 2014 Nicolas Mahe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Extractor : NSObject

-(void)extractWithFile:(NSString*)sourceFile exportFolder:(NSString*)exportFolder url:(NSString*)url successFunction:(void (^)(NSString*))successFunction;
-(NSString*)replaceImageInString:(NSString*)string withUrl:(NSString*)urlFolder saveInFolder:(NSString*)folderToSave;


@end
