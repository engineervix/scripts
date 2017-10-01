#!/bin/bash

# reference: https://askubuntu.com/a/179420/
# To actually crop something away, use negative values in the argument for crop.
# If you wish to crop a pdf with left, top, right and bottom margins of 
# 10, 20, 10, and 20 pt (points), then run
pdfcrop --margins '10 20 10 10' input.pdf output.pdf

