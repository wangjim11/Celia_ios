//
//  RBLocalSessionManager.m
//  VideoBroadcast
//
//  Created by Lin Zhou on 2/14/16.
//  Copyright © 2016 Lin Zhou. All rights reserved.
//

#import "RBLocalSessionManager.h"
#import <AVFoundation/AVFoundation.h>

@interface RBLocalSessionManager () <AVCaptureAudioDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureSession              *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *localPreviewLayer;
@property (nonatomic, strong) NSMutableArray                *samples;
@property (nonatomic, strong) NSMutableArray                *overlappingSamples;
@property (nonatomic, assign) CMTime                        samplesTimeStamp;
@property (nonatomic, assign) CMTime                        overlappingTimeStamp;
@property (nonatomic, assign) BOOL                          overlappingEnabled;
@end

@implementation RBLocalSessionManager

+ (instancetype)sharedInstance {
    static RBLocalSessionManager *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RBLocalSessionManager alloc] init];
    });
    return sharedInstance;
}

- (void)prepare {
    _samples = [NSMutableArray array];
    _overlappingSamples = [NSMutableArray array];
    
    if (_captureSession == nil) {
        // Start a session
        _captureSession = [[AVCaptureSession alloc] init];
        
        [_captureSession beginConfiguration];
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
        
        // Add device
        NSArray<AVCaptureDevice *> *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        AVCaptureDevice *videoDevice = nil;
        for (AVCaptureDevice *device in videoDevices) {
            // Use front camera by default
            if (device.position == AVCaptureDevicePositionFront) {
                videoDevice = device;
                break;
            }
        }
        
        if (videoDevice == nil) {
            videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        }
        
        // Video Input
        AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        [_captureSession addInput:videoInput];
        
        // Video Output
        AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc] init];
        videoOutput.videoSettings = @{(NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA)};
        [_captureSession addOutput:videoOutput];
        
        // Audio Input
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        AVCaptureDeviceInput *audioInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:nil];
        [_captureSession addInput:audioInput];
        
        // Audio output
        AVCaptureAudioDataOutput *audioOutput = [[AVCaptureAudioDataOutput alloc] init];
        
        dispatch_queue_t queue = dispatch_queue_create("local-audio", DISPATCH_QUEUE_SERIAL);
        [audioOutput setSampleBufferDelegate:self queue:queue];
        
        [_captureSession addOutput:audioOutput];
        
        // Preview Layer
        _localPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        _localPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [_captureSession commitConfiguration];
    }
}

- (void)startRunning {
    if (_captureSession.isRunning == NO) {
        [_captureSession startRunning];
        [self showPreview];
    }
}

- (void)stopRunning {
    if (_captureSession.isRunning == YES) {
        [_captureSession stopRunning];
        [self hidePreview];
    }
}

- (void)showPreview {
    _localPreviewLayer.frame = _localSessionView.bounds;
    [_localSessionView.layer addSublayer:_localPreviewLayer];
}

- (void)hidePreview {
    [_localPreviewLayer removeFromSuperlayer];
}


#pragma mark - AVCaptureAudioDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CMTime timeStamp = CMSampleBufferGetOutputDuration(sampleBuffer);
    
    if (_samples.count == 0) {
        _samplesTimeStamp = timeStamp;
    } else {
        _samplesTimeStamp.value += timeStamp.value;
        //        NSLog(@"%f", CMTimeGetSeconds(_samplesTimeStamp));
    }
    
    [self activateOverlappingIfNeeded];
    [self changeOverlappingSamplesTimeStamp:timeStamp];
    
    CMBlockBufferRef blockBufferRef = CMSampleBufferGetDataBuffer(sampleBuffer);
    
    size_t length = CMBlockBufferGetDataLength(blockBufferRef);
    
    NSMutableData *data = [NSMutableData dataWithLength:length];
    CMBlockBufferCopyDataBytes(blockBufferRef, 0, length, data.mutableBytes);
    
    SInt16 *samples = (SInt16 *)data.mutableBytes;
    CMItemCount sampleCount = CMSampleBufferGetNumSamples(sampleBuffer);
    
    static int channelCount = 1;
    for (int i = 0; i < sampleCount; i++) {
        SInt16 left = *samples++;
        
        SInt16 right = 0;
        if (channelCount == 2) {
            right = *samples++;
        }
        
        SInt16 maxInChannels = MAX(left, right);
        [_samples addObject:@(maxInChannels)];
        [self addToOverlappingSamples:@(maxInChannels)];
    }
    
#ifdef QUICKBLOX
    if (CMTimeGetSeconds(_samplesTimeStamp) >= 5) {
        NSArray *samples = [self downSample:[_samples copy] originalSampleRate:44100 downsampleRate:8000];
        dispatch_async(dispatch_get_main_queue(), ^{
            LEOPythonUtilsPredictResult predict = [self.samplesQueue addSamplesAndPredict:samples];
            NSLog(@"Main Samples - Alarm Predict: %ld (%ld)", (long)predict, (unsigned long)samples.count);
            [self.delegate localCaptureSessionService:self didPredictAlarmWithResult:predict];
        });
        _samples = [NSMutableArray array];
    }
#endif
    
    [self checkOverlappingSamples];
}

- (NSArray *)downSample:(NSArray<NSNumber *> *)originalSamples originalSampleRate:(NSUInteger)originalSampleRate downsampleRate:(NSUInteger)downsampleRate {
    /**
     This is a very simple downsampling algorithm. Nth sample is taken. Step is float so here we're making floor and ceil to get proper index and select sample that is louder. Results are pretty good.
     */
    NSMutableArray *samples = [NSMutableArray array];
    
    Float32 step = originalSampleRate / (downsampleRate * 1.0);
    
    for (Float32 i = 0; i < originalSamples.count; i += step) {
        NSUInteger leftIdx = floorf(i);
        NSUInteger rightIdx = ceilf(i);
        
        SInt16 selectedSample = 0;
        if (leftIdx > 0 && rightIdx < originalSamples.count) {
            selectedSample = MAX(originalSamples[leftIdx].integerValue, originalSamples[rightIdx].integerValue);
            
        } else if (leftIdx > 0) {
            selectedSample = originalSamples[leftIdx].integerValue;
            
        } else if (rightIdx < originalSamples.count) {
            selectedSample = originalSamples[rightIdx].integerValue;
        }
        
        [samples addObject:@(selectedSample)];
    }
    
    return samples;
}


#pragma mark - Overlaping samples

- (void)activateOverlappingIfNeeded {
    if(!_overlappingEnabled && CMTimeGetSeconds(_samplesTimeStamp) >= 2.5) {
        _overlappingEnabled = YES;
    }
}

- (void)changeOverlappingSamplesTimeStamp:(CMTime)timeStamp {
    if(_overlappingEnabled) {
        if (_overlappingSamples.count == 0) {
            _overlappingTimeStamp = timeStamp;
        } else {
            _overlappingTimeStamp.value += timeStamp.value;
        }
    }
}

- (void)addToOverlappingSamples:(NSNumber *)value {
    if(_overlappingEnabled) {
        [_overlappingSamples addObject:value];
    }
}

- (void)checkOverlappingSamples {
    if (_overlappingEnabled && CMTimeGetSeconds(_overlappingTimeStamp) >= 5) {
#ifdef QUICKBLOX
        NSArray *samples = [self downSample:[_overlappingSamples copy] originalSampleRate:44100 downsampleRate:8000];
        dispatch_async(dispatch_get_main_queue(), ^{
            LEOPythonUtilsPredictResult predict = [self.overlappingSamplesQueue addSamplesAndPredict:samples];
            NSLog(@"Overlapping Samples - Alarm Predict: %ld (%ld)", (long)predict, (unsigned long)samples.count);
            [self.delegate localCaptureSessionService:self didPredictAlarmWithResult:predict];
        });
        _overlappingSamples = [NSMutableArray array];
#endif
    }
}

@end
