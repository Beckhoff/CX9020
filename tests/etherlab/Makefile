ECAT_DIR ?= ../../ethercat
ECAT_LIB_DIR = $(ECAT_DIR)/include/
ECAT_LIB = $(ECAT_DIR)/lib/.libs/libethercat.a

example.bin: example.cpp $(ECAT_LIB)
	$(CROSS_COMPILE)$(CXX) -v
	$(CROSS_COMPILE)$(CXX) $^ -I$(ECAT_LIB_DIR) -std=c++11 -Wall -pedantic -lpthread -o $@

clean:
	rm -f *.o *.bin
