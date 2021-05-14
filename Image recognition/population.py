from copy import deepcopy
from random import randint, sample

from config import *
from individual import Individual


# population represents one generation of individuals
class Population:
    size = 0
    individuals = list()
    fittest_individual = None

    def __init__(self, size, new_individuals=None):
        self.size = size
        if new_individuals is None:
            for i in range(size):
                self.individuals.append(Individual())
        else:
            for i in range(size):
                self.individuals.append(new_individuals[i])

    def __str__(self):
        ret = ''
        for i in self.individuals:
            ret += '-------\n'
            for p in i.pixels:
                ret += str(p) + '\n'
        return ret

    def get_fittest(self):
        alpha_male = Individual()
        for individual in self.individuals:
            if alpha_male.fitness + alpha_male.bonus < individual.fitness + individual.bonus:
                alpha_male = deepcopy(individual)
        return alpha_male

    def select_individuals(self, count):
        selected = list()
        while len(selected) < count:
            round_participants = sample(self.individuals, PARTICIPATION_CNT)

            winner = Individual()
            winner.fitness = 0

            for participant in round_participants:
                if participant.fitness + participant.bonus > winner.fitness + winner.bonus and participant not in selected:
                    winner = deepcopy(participant)
            selected.append(winner)
        return selected

    def sort(self):
        self.individuals = sorted(self.individuals, reverse=True)

    def top_k(self, k):
        elite = list()
        self.sort()
        for i in range(0, k):
            elite.append(deepcopy(self.individuals[i]))
        return elite

    def replace(self, new):
        my_size = len(self.individuals)
        for i in new:
            self.individuals[randint(0, my_size - 1)] = deepcopy(i)
