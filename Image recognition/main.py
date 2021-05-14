import threading
from copy import deepcopy
from multiprocessing import Process
from random import sample

from dataset import DataSet
from population import Population
from evolution import *

dataset = DataSet('./dataset')
# print(dataset)


def basic_evolution(pop, show, gen=GENERATION_CNT):
    population = pop
    # print(population)

    generation = 0
    alpha = Individual()

    while generation < gen:
        population = test_population(population, dataset)
        fittest = population.get_fittest()

        if alpha.fitness < fittest.fitness:
            if show:
                print('[Basic] New alpha male found: ' + str(fittest.fitness) + ' (generation ' + str(generation) + ')')
            alpha = deepcopy(fittest)

        new_gen = list()
        new_gen.append(fittest)
        while len(new_gen) < POPULATION_SIZE:
            parents = population.select_individuals(2)
            children = crossover(parents[0], parents[1])
            mutate(children)
            if children[0] not in new_gen:
                new_gen.append(children[0])
            if children[1] not in new_gen:
                new_gen.append(children[1])

        population.individuals = new_gen
        level_out(population.individuals)
        generation += 1

    if show:
        print('[Basic] Fittest individual in history: ' + str(alpha.fitness) + ' (generation ' + str(generation) + ')')


def evolution_by_catastrophe(pop, show, gen=GENERATION_CNT):
    population = pop
    # print(population)

    generation = 0
    alpha = Individual()
    progress = list()
    progress_index = 0

    while generation < gen:
        population = test_population(population, dataset)
        fittest = population.get_fittest()

        if progress_index == 200:
            progress.append(alpha.fitness)
            if progress_index != 0 and progress[len(progress) - 1] == progress[len(progress) - 2]:
                if show:
                    print('[Catastrophe] Genocide of generation ' + str(generation) + ' :)')
                perform_genocide(population, fittest)
            progress_index = 0

        if alpha.fitness < fittest.fitness:
            if show:
                print('[Catastrophe] New alpha male found: ' + str(fittest.fitness) + ' (generation ' + str(generation) + ')')
            alpha = deepcopy(fittest)
            progress_index = 0

        new_gen = list()
        new_gen.append(fittest)
        while len(new_gen) < POPULATION_SIZE:
            parents = population.select_individuals(2)
            children = crossover(parents[0], parents[1])
            mutate(children)
            if children[0] not in new_gen:
                new_gen.append(children[0])
            if children[1] not in new_gen:
                new_gen.append(children[1])

        population.individuals = new_gen
        generation += 1
        level_out(population.individuals)
        progress_index += 1

    if show:
        print('[Catastrophe] Fittest individual in history: ' + str(alpha.fitness) + ' (generation ' + str(generation) + ')')


def evolution_by_deterministic_crowding(pop, show, gen=GENERATION_CNT):
    population = pop

    generation = 0
    alpha = Individual()

    while generation < gen:
        population = test_population(population, dataset)
        fittest = population.get_fittest()

        if alpha.fitness < fittest.fitness:
            if show:
                print('[Crowding] New alpha male found: ' + str(fittest.fitness) + ' (generation ' + str(generation) + ')')
            alpha = deepcopy(fittest)

        new_gen = list()
        new_gen.append(fittest)
        while len(new_gen) < POPULATION_SIZE:
            parents = population.select_individuals(2)
            children = crossover(parents[0], parents[1])
            mutate(children)
            children[0] = deepcopy(children[0].determine_best(parents[0], parents[1]))
            children[1] = deepcopy(children[1].determine_best(parents[0], parents[1]))
            new_gen.extend(children)

        population.individuals = new_gen
        level_out(population.individuals)
        generation += 1

    if show:
        print('[Crowding] Fittest individual in history: ' + str(alpha.fitness) + ' (generation ' + str(generation) + ')')


def island_evolution():
    populations = list()
    
    for i in range(0, ISLAND_CNT):
        populations.append(Population(POPULATION_SIZE))

    cycle = 1
    alpha = Individual()
    while cycle < ISLAND_CYCLES:
        for i in range(0, ISLAND_CNT):
            if i % 3 == 0:
                basic_evolution(populations[i], False, 1)
            if i % 3 == 1:
                evolution_by_catastrophe(populations[i], False, 1)
            if i % 3 == 2:
                evolution_by_deterministic_crowding(populations[i], False, 1)

            fittest = populations[i].get_fittest()

            if alpha.fitness < fittest.fitness:
                print('New alpha male found: ' + str(fittest.fitness) + ' (cycle ' + str(cycle) + ')')
                alpha = deepcopy(fittest)

        if cycle % 100 == 0:
            print('current cycle: ' + str(cycle) + ', current fitness: ' + str(alpha.fitness))

        if alpha.fitness == 26:
            break

        if ISLAND_CROSSOVER_RATE > randint(0, 100):
            basic_sample = sample(populations[0].individuals, 5)
            catastrophe_sample = sample(populations[1].individuals, 5)
            crowding_sample = sample(populations[2].individuals, 5)
            populations[0].replace(catastrophe_sample)
            populations[0].replace(crowding_sample)
            populations[1].replace(basic_sample)
            populations[1].replace(crowding_sample)
            populations[2].replace(basic_sample)
            populations[2].replace(catastrophe_sample)

        cycle += 1

    print('Fittest individual in history of all islands: ' + str(alpha.fitness) + ' (cycle ' + str(cycle) + ')')


population = Population(POPULATION_SIZE)

# basic_evolution(population, True)
# evolution_by_catastrophe(population, True)
# evolution_by_deterministic_crowding(population, True)
island_evolution()
