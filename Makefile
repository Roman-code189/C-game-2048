NAME = endgame
CC = clang

# Directories
RAYLIB_DIR = resource/raylib
RAYLIB_A = $(RAYLIB_DIR)/libraylib.a
OBJ_DIR = obj
SRC_DIR = src
INC_DIR = inc

# Flags
# CFLAGS include both your inc and raylib headers
CFLAGS = -std=c11 -Wall -Wextra -Werror -Wpedantic -I$(INC_DIR) -I$(RAYLIB_DIR)

# Libraries (LDFLAGS) - Fixed for Linux as default for Campus
LDFLAGS = $(RAYLIB_A) -lGL -lm -lpthread -ldl -lrt -lX11

# Files
SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(patsubst $(SRC_DIR)/%.c, $(OBJ_DIR)/%.o, $(SRCS))

# --- TARGETS ---

all: $(NAME)

$(NAME): $(RAYLIB_A) $(OBJS)
	$(CC) $(OBJS) -o $(NAME) $(LDFLAGS)
	printf "SUCCESS: $(NAME) created.\n"

$(RAYLIB_A):
	printf "Building Raylib from source...\n"
	make -C $(RAYLIB_DIR) PLATFORM=PLATFORM_DESKTOP RAYLIB_RELEASE_PATH="."

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
	mkdir $(OBJ_DIR)

clean:
	rm -rf $(OBJ_DIR)
	printf "Cleaned objects.\n"

clean_libs:
	make -C $(RAYLIB_DIR) clean RAYLIB_RELEASE_PATH="."
	rm -f $(RAYLIB_A)

uninstall: clean
	rm -f $(NAME)
	make -C $(RAYLIB_DIR) clean RAYLIB_RELEASE_PATH="."
	rm -f $(RAYLIB_A)
	printf "Full uninstall complete.\n"

reinstall: uninstall all

.PHONY: all clean uninstall reinstall clean_libs

