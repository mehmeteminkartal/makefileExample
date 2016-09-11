#include <stdio.h>
#include <stdlib.h>
// Standart kütüphaneleri dahil et
#include <test.h>
// test fonksyonun tanımları için header dosyasını dahil et

int main() {			      // ana fonksiyon bloğu
	int a = 10;		      // a = 10 :P
	printf("deneme\n");	   // deneme yaz
	for (int i = 0; i < a; i++) { // a kere yap
		test();		      // Test fonkesyonunu çağır
		system("sleep 0.1");    // 100 milisaniye bekle
	}
	return 0; // bitti
}
