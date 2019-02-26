#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NNNetwork.h"
#import "NNSessionManager.h"
#import "NNSessionManagerConfiguration.h"

FOUNDATION_EXPORT double NNNetworkVersionNumber;
FOUNDATION_EXPORT const unsigned char NNNetworkVersionString[];

