# **Optimization problems**
Finding the shortest path between given stops and finding the shortest cycle containing given stops on real data from Wroclaw public transport using different cost functions.

Finding the shortest path was implemented using two algorithms - Dijkstra and A*, with two main cost functions - travel time and number of transfers. To implement A* I tested several heuristics and finally stopped at a simple Euclidean distance. The distance was easy to calculate by transforming from geographic coordinates to a two-dimensional Cartesian coordinate system.

Finding the shortest cycle was implemented using Tabu Search. I used the Dijkstra algorithm implemented earlier to find the shortest paths between two stops.

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
./Project1.exe
```

## Usage
**TODO**
