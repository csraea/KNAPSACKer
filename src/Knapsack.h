/**
 * @file
 * @author Oleksandr Korotetskyi <csraea@gmail.com>
 * @date 06/11/2021
 */

#ifndef KNAPSACK_H
#define KNAPSACK_H

#include <algorithm>
#include <iterator>
#include <fstream>
#include <iostream>
#include <map>
#include <string>
#include <vector>
#include <numeric>

#include <stdlib.h>

#include "Common.h"

class Knapsack {

  public:

    int16_t id; // ID of instance
    int32_t B;  // požadovana minimální cena
    uint8_t n;  // počet věcí
    int32_t M;  // kapacita batohu    

    int32_t total = 0;  // sum of all item values
    Item *items = nullptr;

    int32_t precision = 0;

    // auxiliary variables
    std::vector<int> appr_cost;     // approximated cost of all items, needed for FPTAS
    std::vector<bool> solution;    // solution for current items
    std::vector<float> heuristic;  // computed heuristic value (cost/weight)

    /**
     * Constructor. 
     *
     * Checks if given file name exist, parse lines of that file and creates instances.
     */
    Knapsack(uint16_t id, int32_t B, uint8_t n, int32_t M) : id(id), B(B), n(n), M(M) { 
        this->items = new Item[static_cast<int>(this->n)] ();    // allocate array of items of desired size
    };
    /**
     * Destructor.
     *
     * Deallocates members of vector all_instances.
     */
    ~Knapsack() {
        delete[] items;
    };

    /**
     * Compute heuristic for all instance values and sort them in decreasing order.
     */
    void ComputeHeuristic();
    void SetPrecision(int32_t p);
    void SetPrecision(const char *p);
    void PrintKnapsack(); 

};

#endif //INSTANCE_HH
