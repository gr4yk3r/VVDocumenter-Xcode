//
//  VVHeaderCommenter.m
//  VVDocumenter-Xcode
//
//  Created by gr4yk3r on 16/6/1.
//  Copyright © 2016年 OneV's Den. All rights reserved.
//

#import "VVHeaderCommenter.h"
#import "VVDocumenterSetting.h"

@implementation VVHeaderCommenter

- (NSString *)document {
    //Regular comment documentation
    NSString *finalString = [NSString stringWithFormat:@"%@%@%@", [self startComment],
                             [self sinceComment],
                             [self endComment]];
    return finalString;
}

-(NSString *) startComment
{
    NSString *header = [NSString stringWithFormat:@"@header <#header#>\n%@%@@brief ",self.emptyLine,self.prefixString];
    return [self startCommentWithDescriptionTag:header];
}

-(NSString *) startCommentWithDescriptionTag:(NSString *)tag {
    NSString *authorInfo = @"";
    NSString *dateInfo = @"";
    
    if ([[VVDocumenterSetting defaultSetting] useAuthorInformation]) {
        NSMutableString *authorCotent = @"".mutableCopy;
        
        if ([[VVDocumenterSetting defaultSetting] authorInformation].length > 0) {
            [authorCotent appendString:[[VVDocumenterSetting defaultSetting] authorInformation]];
        }
        
        if ([[VVDocumenterSetting defaultSetting] useDateInformation]) {
            NSString *formatString = [[VVDocumenterSetting defaultSetting] dateInformationFormat];
            if ([formatString length] <= 0) {
                formatString = @"MM-dd-YYYY HH:MM:ss";
            }
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:formatString];
            
            dateInfo = [formatter stringFromDate:[NSDate date]];
            
            if (authorCotent.length > 0) {
                [authorCotent appendString:@", "];
            }
            
            [authorCotent appendString: dateInfo];
        }
        
        authorInfo = [NSString stringWithFormat:@"%@@author %@\n%@", self.prefixString, authorCotent, self.prefixString];
        
    }
    
    if ([[VVDocumenterSetting defaultSetting] useHeaderDoc]) {
        return [NSString stringWithFormat:@"%@/*!\n%@%@<#Description#>\n%@%@", self.indent, self.prefixString, tag, self.emptyLine, authorInfo];
    } else if ([[VVDocumenterSetting defaultSetting] prefixWithSlashes]) {
        return [NSString stringWithFormat:@"%@%@<#Description#>\n%@%@", self.prefixString, tag, self.emptyLine, authorInfo];
    } else {
        return [NSString stringWithFormat:@"%@/**\n%@%@<#Description#>\n%@%@", self.indent, self.prefixString, tag, self.emptyLine, authorInfo];
    }
}
@end
