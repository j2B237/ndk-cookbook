CXX 	:= g++
AR		:= ar 
SRC_DIR	:= .
OBJ_DIR	:= .
TARGET	:= native-lib.a 

CXXFLAGS := -O2 -I$(SRC_DIR)

OBJS := native-lib.o 

# Target par defaut
all: $(TARGET)

# Archive statique
$(TARGET): $(OBJS)
	$(AR) -rcs $@ $^

# Compilation statique
%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@


debug:
	@echo "OBJECTS: " $(OBJS)

clean:
	rm -f *.o *.a

# Commande pour compiler .a pour arm64-v8a avec le NDK
# Compile pour arm64-v8a
# $NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android34-clang -c ./mymath.c -I./include/ -o mymath.o
# Genere la librairie statique qui sera linker plus tard dans native-lib.so
# $NDK_HOME/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar rcs libmymath.a ./mymath.o
