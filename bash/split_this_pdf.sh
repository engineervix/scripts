#!/bin/bash

# Scenario: You have a scanned pdf file where there are two pages on 1 sheet,
# and you wanna split this sheet into two individual pdf pages.
# mutool comes in handy. Install it on Ubuntu 16.04 via:
# sudo apt-get install mupdf-tools

# For horizontal splits, replace y with x. 
# you can, of course, combine the two for more complex solutions.
mutool poster -y 2 input.pdf output.pdf
