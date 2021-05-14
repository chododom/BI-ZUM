from PIL import Image
import os


# class represents an image from the dataset
class Picture:

    def __init__(self, path):
        self.letter = path.split('/')[2].split('.')[0]

        img = Image.open(path).convert('L')   # converts image to 8-bit greyscale
        self.width, self.height = img.size    # returns tuple (16, 16)
        data = list(img.getdata())  # convert image data to a list of integers
        # create a list of lists with pixel rows
        self.pixels = [data[offset: offset + self.width] for offset in range(0, self.width * self.height, self.width)]

    def __str__(self):
        ret = self.letter.capitalize() + ':\n'
        for row in self.pixels:
            ret = ret + ' '.join('{:3}'.format(value) for value in row) + '\n'
        return ret


# class represents the whole dataset of images
class DataSet:

    def __init__(self, dir):
        self.images = list()
        for filename in os.listdir(dir):
            if filename.endswith(".bmp"):
                self.images.append(Picture(dir + '/' + filename))
            else:
                continue

    def __str__(self):
        res = ''
        for img in self.images:
            res = res + str(img) + '\n'
        return res

