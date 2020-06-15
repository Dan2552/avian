#include <Foundation/Foundation.h>

const char * game_resource_path(char *filename, char *filetype) {
    NSString *fontPathObjC = [NSBundle pathForResource:@(filename)
                                                ofType:@(filetype)
                                           inDirectory:@"game_resources"];
    return [fontPathObjC cStringUsingEncoding:NSUTF8StringEncoding];
}
