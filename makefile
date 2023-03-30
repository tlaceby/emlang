CXX = g++
CXXFLAGS = -std=c++17 -Wall -Wextra

# Default to release build
BUILD_TYPE ?= release

# Set the appropriate flags based on the build type
ifeq ($(BUILD_TYPE),debug)
  CXXFLAGS += -g -DDEBUG -w
else
  CXXFLAGS += -O3 -DNDEBUG
endif

# Find all source files recursively
SRCS = $(wildcard *.cpp */*.cpp */*/*.cpp)
OBJS = $(patsubst %.cpp,%.o,$(SRCS))
TARGET = emu

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) -o $@ $^

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

clean:
	rm -f $(OBJS) $(TARGET)
