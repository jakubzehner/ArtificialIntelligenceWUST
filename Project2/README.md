# **Game tree**

Solving Reversi game tree with Minimax algorithm and Alpha-beta pruning algorithm using various heuristics. 

Heuristic used in the project are:
* **coin parity** - advantage in disks over an enemy
* **corner owned** - advantage in claiming corners
* **corner closeness** - advantage in claiming positions near corners
* **current mobility** - advantage in available moves
* **potential mobility** - advantage in free positions near enemy disks
* **weights** - weights table made by korman
* **korman** - korman heuristic but without stability
* **adapt** - trained by genetic algorithm heuristic build with first 5 heuristics

## Requirements
* **V** 0.3.3

## Building
In root directory run:
```sh
v run .
```
It will build and run project extremely fast, but without any optimizations, so it will run painfully slow *(still faster than python solutions 😎)*.

For well optimize build run in root directory:
```sh
v -prod .
```
This command will produce executable file, then just run this file with:

```sh
./Project2.exe
```

## Usage
```sh
./Project2.exe --help
``` 