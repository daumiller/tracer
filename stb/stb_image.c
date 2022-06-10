// clang -c stb_image.c -o stb_image.o
// ar -rc ../stb_image.a stb_image.o

#define STB_IMAGE_IMPLEMENTATION 1
#include "./stb_image.h"

#define STB_IMAGE_WRITE_IMPLEMENTATION 1
#include "./stb_image_write.h"
