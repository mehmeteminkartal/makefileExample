#include <stdio.h>
#include <stdlib.h>
#include <test.h>

int main() {
	int a = 10;
	printf("deneme\n");
	for(int i = 0; i < a; i++) {
		test();
		system("sleep 1");
	}
	return 0;
}
