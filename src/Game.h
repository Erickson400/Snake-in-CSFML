#pragma once
#include "SFML/Graphics.h"
#include <stdio.h>
#include <stdlib.h>

typedef unsigned char	uint8;
typedef char			sint8;
typedef unsigned short	uint16;
typedef short			sint16;
typedef unsigned int	uint32;
typedef int				sint32;

#define MAP_SIZE 50 // 50*50 = 2,500
#define SEED 234960123

static uint8 UpPressed		= 0;
static uint8 LeftPressed	= 0;
static uint8 DownPressed	= 0;
static uint8 RightPressed	= 0;

enum Direction {
	Up,
	Left,
	Down,
	Right
};

typedef struct {
	uint8 x;
	uint8 y;
	uint8 MovingDir; // Direction enum
} SnakePlayer;

typedef struct {
	uint8 x;
	uint8 y;
} Food;

typedef struct {
	uint8 x;
	uint8 y;
} SnakeTail;

static uint8 cycleRate = 10; // The length of a cycle (less is faster)
static uint8 cycleRate_Normal = 10;
static uint8 cycleRate_Boost = 2;
static uint32 cycleCount = 0; // Increases by one every frame
static uint8 b_isPaused = 0;

static SnakePlayer player = { MAP_SIZE / 2,MAP_SIZE / 2 ,Right};
static SnakeTail tail[MAP_SIZE*MAP_SIZE];
static uint16 tailIndex = 0; // The current size of the snake
static uint8 b_hasMoved = 0; // For preventing the snake from doing a 180 turn
static Food food1, food2;

// Misc render variables
static sfImage* map; // 3 possible values (empty, snake, food)
static sfTexture* texture;
static sfSprite* sprite;

// Tail functions
static void addTail(); // When eating Food
static void shiftTails(); //Every move cycle

// Food functions
static void food_randomLocation(Food* p_food);
static void food_checkIfOnSnake(Food* p_food);

// Misc functions
static void snake_checkIfTouchedTail();
static void Restart();

void Game_Setup();
void Game_Draw(sfRenderWindow* window);
void Game_Input(sfEvent* event);
void Game_Destroy();

