#include <jni.h>
#include <android/log.h>
#include "mymath.h"

#define LOGI(...) __android_log_print(ANDROID_LOG_INFO, "NDK", __VA_ARGS__)

extern "C"

JNIEXPORT jint JNICALL
Java_com_example_myndkapp_MainActivity_addFromNDK(
    JNIEnv *env,
    jobject obj,
    jint a,
    jint b
){
    int c = add(a,b);
    LOGI("Addition : %d + %d = %d", a, b, c);
    return c;
}


