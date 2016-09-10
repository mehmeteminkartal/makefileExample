CC =clang
# Tercih edilen c compileri
C+ =clang++
# Tercih edilen C++ Compileri

CFLAGS = -Wall
CPFLAGS = -Wall
# Tüm uyarıları göster

INCLUDES = -I. -I./src/
# extra Include dizinleri
LIBS = -lm 
# Extra Kütüphaneler -lwiringPi

CPPFILES = $(wildcard src/*.cpp)
CFILES = $(wildcard src/*.c)
# src dizinindeki c/c++ dosyalarını al

CPPOBJECTS = $(filter-out build/main.cpp.o, $(addprefix build/, $(notdir $(addsuffix .o,$(CPPFILES)))))
COBJECTS = $(addprefix build/, $(notdir $(addsuffix .o, $(CFILES))))
# hedef obje dosyalarının adlarına dönüştür

MAIN = app
# ana executable dosya

debug: CFLAGS += -g 
debug: CPFLAGS += -g
# debug hedefi kullanıldıysa compilera sembolleri bırakmasını söyle

ALLSOURCEFILES = $(CPPFILES)
ALLSOURCEFILES += $(CFILES)
ALLSOURCEFILES += $(wildcard src/*.h)
ALLSOURCEFILES += $(wildcard src/*.hpp)

# tüm kaynak dosyaları

all: build/$(MAIN)
# ilk hedef ana executable dosya gereksinimi

run: build/$(MAIN)
# Çalıştır hedefi executable dosyasının olmasını gerektirir
	@echo "Running..."
	@./build/$(MAIN) makerun
# @ işareti çalışan komutu stdout'a yazılmasını engeller
	@echo ""

debug: clean
# debug işlemi için programın sıfırdan inşaası gerekir
	gdb build/$(MAIN)
# gdb programını çağır

build/$(MAIN): build build/archive.a src/main.cpp
# main.cpp dosyasını compile edip arşiv dosyası ile link et. Build dizini, ana arşiv dosyasını ve main.cpp dosyasını gerektirir
	@echo "(C+) main.cpp archive.a -> build/$(MAIN)" 
	@$(C+) $(CPFLAGS) -o build/$(MAIN) src/main.cpp build/archive.a $(INCLUDES) $(LIBS)

build/archive.a: $(CPPOBJECTS) $(COBJECTS)
# ana arşiv dosyası tüm objeleri bir .a dosyasına birleştir c ve c++ objelerini gerektirir
	@echo "(ar) $(CPPOBJECTS) $(COBJECTS)"
	@ar rc build/archive.a $(CPPOBJECTS) $(COBJECTS) 

build:
# build dizinini olştur
	@echo "(mkdir) build"
	@mkdir -p build


$(CPPOBJECTS): build/%.o: src/%
# cpp dosyalarını objelere compile et. Burada "build/%.o: src/%" objeleri kaynakları ile eşleştirmek için kullanılır.
	@echo "(C+) $<"
	@$(C+) $(CPPFLAGS) $(INCLUDES) -c $< -o $@


$(COBJECTS): build/%.o: src/%
# cpp ile aynı. sadece c++ yerine c compiler çalışır
	@echo "(CC) $<"
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@


clean: clear build/$(MAIN)
# temiz build önce temizleyip sonra inşa etmeyi gerektirir

clear:
#temizlemek için direk build dizinini sil
	@echo "(rm) build"
	-@rm -r build
	-@rm -r src/*.old
# "-" işareti oluşan hataların buildi durdurmasını engeller

format:
# clang-format ile $(ALLSOURCEFILES) dosyalarını düzenle 
	@$(foreach var,$(ALLSOURCEFILES), \
		echo "(format) $(var)"; \
		clang-format $(var) -style=file > $(var).formatted; \
		mv $(var) $(var).old; \
		mv $(var).formatted $(var); \
		\
	)
	-@rm -r src/*.old