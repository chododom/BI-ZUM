from copy import deepcopy

from individual import *


# test each individual of current population and show result of fittest one
def test_population(population, dataset):
    for individual in population.individuals:
        individual.fitness = individual.calculate_fitness(dataset)
    return population


def crossover(mum, dad):
    children = list()
    if CROSSOVER_RATE > randint(0, 100):
        children.append(mum)
        children.append(dad)
    else:
        child1 = Individual()
        child2 = Individual()

        crossover_point = randint(1, PIXEL_CNT - 1)
        for i in range(0, crossover_point):
            child1.pixels[i] = deepcopy(mum.pixels[i])
            child2.pixels[i] = deepcopy(dad.pixels[i])
        for i in range(crossover_point, 5):
            child1.pixels[i] = deepcopy(dad.pixels[i])
            child2.pixels[i] = deepcopy(mum.pixels[i])
        children.append(deepcopy(child1.repair()))
        children.append(deepcopy(child2.repair()))
    return children


def mutate(children):
    for child in children:
        for pixel in child.pixels:
            if MUTATION_RATE > randint(0, 100):
                pixel = Pixel(randint(0, IMG_SIZE), randint(0, IMG_SIZE))
                child.bonus = 3
                child.repair()


def perform_genocide(pop, fittest):
    elite = pop.top_k(SURVIVOR_CNT)

    new_individuals = list()
    new_individuals.extend(elite)

    while len(new_individuals) < POPULATION_SIZE:
        new_individuals.append(Individual())
    pop.individuals = new_individuals


def level_out(individuals):
    for x in individuals:
        if x.bonus > 0:
            x.bonus -= 0.3
