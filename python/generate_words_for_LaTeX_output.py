#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""

Introduction
-------------

This script is used to generate some LaTeX output consisting of
a number of words given as an argument to the script.
It's like "Lorem Ipsum", but with a specified number of words.

This output will then be injected into a LaTeX document, which has already
been defined elsewhere.

NOTE:
    Text in Headings is not counted

Purpose
--------

The generated LaTeX output is meant to be used in determining roughly
how many pages will constitute the given number of words. This is for my
academic assignments, where lecturers typically specify how many words
our essays should be.

How it works
-------------

When you run the script, pass an arg which represents No. of words
to be generated.

The script then

0. defines 4 fixed headings (level 0 to 3)
1. generates the number of words
2. divides those into some roughly equal parts,
   "LaTeXizes" the text and
   groups them by headings defined in 0.
3. spits out LaTeX code into a file

TODO
----

- Instead of hard-coding the parts as I've done, let the script 'decide'
  the number of roughly equal parts based on
  the number of words to be generated
- Introduce other features such as tables, graphicx and so on

"""

import os
import argparse
from titlecase import titlecase
from faker import Faker
from faker.providers import lorem

__author__ = "Victor Miti"
__copyright__ = "Copyright (C) 2019, Victor Miti"
__credits__ = ['']
__license__ = "MIT"
__version__ = "0.1"
__maintainer__ = "Victor Miti"
__email__ = "victormiti@gmail.com"
__status__ = "Development"


fake = Faker()
fake.add_provider(lorem)

# Step 0: Four fixed Headings

fake_h1 = fake.sentence(nb_words=8, variable_nb_words=True, ext_word_list=None)
fake_h2 = fake.sentence(nb_words=7, variable_nb_words=True, ext_word_list=None)
fake_h3 = fake.sentence(
    nb_words=10,
    variable_nb_words=True,
    ext_word_list=None)
fake_h4 = fake.sentence(nb_words=9, variable_nb_words=True, ext_word_list=None)

cleaned_up_h1 = (titlecase(fake_h1)).strip('.')
cleaned_up_h2 = (titlecase(fake_h2)).strip('.')
cleaned_up_h3 = (titlecase(fake_h3)).strip('.')
cleaned_up_h4 = (titlecase(fake_h4)).strip('.')

h1 = "\\chapter{%s}" % cleaned_up_h1
h2 = "\\section{%s}" % cleaned_up_h2
h3 = "\\subsection{%s}" % cleaned_up_h3
h4 = "\\subsubsection{%s}" % cleaned_up_h4

# Step 1: Generate the given number of words

parser = argparse.ArgumentParser(
    description='generates the given number of words.')
parser.add_argument('number', metavar='N', type=int,
                    help='the number of words you wanna generate')
args = parser.parse_args()

if args.number and args.number < 500:
    parser.error("Minimum number is 500")
else:
    words = fake.words(nb=args.number, ext_word_list=None, unique=False)


# Step 2: Divide the generated words list into specified number of parts,
#         and apply custom LaTeX formatting / styling to some words


def split_list(a, n):
    """
    Splits a given list {a} into {n} roughly equal parts

    Credits:
        https://stackoverflow.com/a/2135920

    Arguments:
        a {list} -- list of words
        n {int} -- number of parts to split into
    """
    k, m = divmod(len(a), n)
    return (a[i * k + min(i, m):(i + 1) * k + min(i + 1, m)] for i in range(n))


parts = list(split_list(words, 11))


def manipulate_strings(part, start, stop, operation):
    """
    Here we wanna get part of the string (a group of words)
    and apply custom LaTeX formatting / styling. The point is
    that we don't want just plain text

    Arguments:
        part {list} -- one of the parts split earlier
        start {int} -- starting word to include in the group of words
        stop {int} -- ending word to include in the group of words
        operation {string} -- the custom formatting we wanna apply

    Returns:
        string -- a string with formatted substrings
    """
    custom_words = part[start:stop]
    custom_string = " ".join(custom_words)
    s = " ".join(part).capitalize()

    if operation == 'bold':
        t = s.replace(custom_string, "\\textbf{%s}" % custom_string)
        return t
    elif operation == 'italic':
        t = s.replace(custom_string, "\\textit{%s}" % custom_string)
        return t
    elif operation == 'emph':
        t = s.replace(custom_string, "\\textbf{\\textit{%s}}" % custom_string)
        return t
    elif operation == 'itemize':
        temp_latex_list = list(split_list(custom_words, 4))
        latex_list = [" ".join(y).capitalize() for y in temp_latex_list]
        replacement_list = ""
        for item in latex_list:
            replacement_list += "\\item{%s}\n" % item
        t = s.replace(
            custom_string +
            " ",
            "\n\n\\begin{itemize}[label={\\Snowflake}] \n%s\\end{itemize}\n\n" %
            replacement_list)
        return t
    else:
        return s


p1 = manipulate_strings(parts[0], 12, 24, "italic") + '.\n\n' + manipulate_strings(parts[1], 9, 12, "emph") + '.\n\n' + manipulate_strings(parts[2], 23, 30, "bold") + ".\n\n"
p2 = manipulate_strings(parts[3], 9, 38, "itemize") + '.\n\n' + manipulate_strings(parts[4], 33, 39, "bold") + ".\n\n"
p3 = manipulate_strings(parts[5], 7, 12, "emph") + '.\n\n' + manipulate_strings(parts[6], 16, 43, "itemize") + '.\n\n' + manipulate_strings(parts[7], 3, 9, "italic") + ".\n\n"
p4 = manipulate_strings(parts[8], 21, 26, "bold") + '.\n\n' + manipulate_strings(parts[9], 9, 40, "itemize") + '.\n\n' + manipulate_strings(parts[10], 32, 39, "emph") + ".\n\n"

# Step 3: spit out the generated LaTeX code into a file

latex_file = str(args.number).zfill(4) + "_words_dummy_essay.tex"

# before writing to file, let's remove the file if it exists
try:
    os.remove(latex_file)
except OSError:
    pass

print(h1 + '\n', file=open(latex_file, "a"))
print(p1, file=open(latex_file, "a"))

print(h2 + '\n', file=open(latex_file, "a"))
print(p2, file=open(latex_file, "a"))

print(h3 + '\n', file=open(latex_file, "a"))
print(p3, file=open(latex_file, "a"))

print(h4 + '\n', file=open(latex_file, "a"))
print(p4, file=open(latex_file, "a"))
