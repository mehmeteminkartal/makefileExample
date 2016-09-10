CC =clang
C+ =clang++

CFLAGS = -Wall
CPFLAGS = -Wall

INCLUDES = -I. -I./src/
LIBS = -lm 
#-lwiringPi

CPPFILES = $(wildcard src/*.cpp)
CFILES = $(wildcard src/*.c)

CPPOBJECTS = $(filter-out build/main.cpp.o, $(addprefix build/, $(notdir $(addsuffix .o,$(CPPFILES)))))
COBJECTS = $(addprefix build/, $(notdir $(addsuffix .o, $(CFILES))))

MAIN = app

debug: CFLAGS += -g 
debug: CPFLAGS += -g
 
all: build/$(MAIN)


run: build/$(MAIN)
	@echo "Running..."
	@./build/$(MAIN) makerun
	@echo ""

debug: clean
	gdb build/$(MAIN)
	

build/$(MAIN): build build/archive.a src/main.cpp
	@echo "(C+) main.cpp archive.a -> build/$(MAIN)" 
	@$(C+) $(CPFLAGS) -o build/$(MAIN) src/main.cpp build/archive.a $(INCLUDES) $(LIBS)

build/archive.a: $(CPPOBJECTS) $(COBJECTS)
	@echo "(ar) $(CPPOBJECTS) $(COBJECTS)"
	@ar rc build/archive.a $(CPPOBJECTS) $(COBJECTS) 

build:
	@echo "(mkdir) build"
	@mkdir -p build


$(CPPOBJECTS): build/%.o: src/%
	@echo "(C+) $<"
	@$(C+) $(CPPFLAGS) $(INCLUDES) -c $< -o $@


$(COBJECTS): build/%.o: src/%
	@echo "(CC) $<"
	@$(CC) $(CFLAGS) $(INCLUDES) -c $< -o $@


clean: clear build/$(MAIN)


clear:
	@echo "(rm) build"
	@rm -r build

#depend: $(CSRCS) $(CPPSRCS)
#	makedepend $(INCLUDES) $^
