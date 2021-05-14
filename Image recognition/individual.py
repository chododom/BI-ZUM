from random import randint

from config import *


# pixel represented by its [x;y] coordinates in an image
class Pixel:
    def __init__(self, x=-1, y=-1):
        self.x = x
        self.y = y

    def __str__(self):
        return '[' + str(self.x) + ';' + str(self.y) + ']'

    def __eq__(self, other):
        return self.x == other.x and self.y == other.y

    def __hash__(self):
        string = str(self.x) + str(self.y)
        return int(string)


# one individual attempt at finding 5 pixels which distinguish between all images
class Individual:

    def __init__(self):
        self.pixels = []
        self.fitness = 0
        self.bonus = 0
        self.pixels = [Pixel()] * PIXEL_CNT
        cnt = 0
        while cnt != PIXEL_CNT:
            self.pixels[cnt] = Pixel(randint(0, IMG_SIZE), randint(0, IMG_SIZE))

            duplicate = False
            for i in range(cnt):
                if self.pixels[i] == self.pixels[cnt]:
                    duplicate = True
                    break
            if not duplicate:
                cnt += 1

    def __str__(self):
        res = ''
        for p in self.pixels:
            res += str(p) + ' '
        return res

    def __eq__(self, other):
        same_cnt = 0
        for pix in self.pixels:
            for sec in other.pixels:
                if pix == sec:
                    same_cnt += 1
        if same_cnt == 5:
            return True
        else:
            return False

    def calculate_fitness(self, dataset):
        patterns = set()
        for img in dataset.images:
            string = ''
            for pixel in self.pixels:
                if img.pixels[pixel.x][pixel.y] == 255:
                    string += '1'
                else:
                    string += '0'
            patterns.add(string)
        self.fitness = len(patterns)
        return self.fitness

    def repair(self):
        genes = []
        for pixel in self.pixels:
            duplicate = False
            for gene in genes:
                if pixel == gene:
                    duplicate = True
                    break
            if not duplicate:
                genes.append(pixel)

        while len(genes) < 5:
            new_pix = Pixel(randint(0, IMG_SIZE), randint(0, IMG_SIZE))
            duplicate = False
            for gene in genes:
                if new_pix == gene:
                    duplicate = True
                    break
            if not duplicate:
                genes.append(new_pix)
        self.pixels = genes
        return self

    def __lt__(self, other):
        return self.fitness + self.bonus < other.fitness + other.bonus

    def distance(self, other):
        my_set = set()
        other_set = set()
        for pixel in self.pixels:
            my_set.add(pixel)
        for pix in other.pixels:
            other_set.add(pix)

        distance = PIXEL_CNT - len(my_set.intersection(other_set))
        return distance

    def determine_best(self, mum, dad):
        if self.distance(mum) < self.distance(dad):
            if self.fitness + self.bonus < mum.fitness + mum.bonus:
                return mum
            else:
                return self
        else:
            if self.fitness + self.bonus < dad.fitness + dad.bonus:
                return dad
            else:
                return self

