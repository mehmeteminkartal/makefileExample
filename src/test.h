#pragma once // Header dosyasının sadece bir kere çalışması için
#include <stdio.h> // standart kütüphaneler

#ifdef __cplusplus // eğer c++ compileri çalışıyor ise
extern "C" { // c++ compilerine bunun c fonksiyonu olduğunu söyle
#endif


void test(); // test() fonksiyonunun prototipi



#ifdef __cplusplus // c++ ise ...
}
#endif
