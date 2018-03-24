#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
This script adds ID3 tag info into a bunch of related mp3 files (say, an album)
based on:
	* User-provided info such as Artist, Album, etc
	* info obtained from the filename following a specified RegEx pattern
The script uses the following
    * `eyeD3 v 0.8.4 <https://eyed3.readthedocs.io/en/latest/>`_
to accomplish this task.
**TODO**: improve the script by:
    - adding some verbosity to inform the user what's going on
    - dynamically specify artist without hardcoding
**CHANGELOG**:
    - YYYY-MMM-DD-ddd: Description here.

In a nutshell, this is how it works:
1. Select source directory containing subdirectories represnting albums
2. Define constants for Artist, Album and any other common ID3 tag info
3. For each mp3 File in the directory:
   - Define (by extracting from filename using regex or something) the track number
   - Define (by extracting from filename using regex or something) the track title
   - add the ID3 tag info

=====================================================================
This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.
This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.
You should have received a copy of the GNU General Public License
along with this program; if not, see <http://www.gnu.org/licenses/>.
=====================================================================
"""

import os
import datetime
import time
import eyed3

__author__ = "Victor Miti"
__copyright__ = "Copyright (C) 2018 Victor Miti"
__credits__ = []
__license__ = "GPL"
__version__ = "1.0"
__maintainer__ = "Victor Miti"
__email__ = "victormiti@gmail.com"
__status__ = "Production/Stable"


start_time = time.time()

# current directory
current_dir = os.getcwd()

# a list of subdirectories in the current directory
sub_dirs = next(os.walk(current_dir))[1]

for d in sub_dirs:
    the_artist = u"PageCXVI"
    the_album  = unicode(d, "utf-8")
    files_dir = os.path.join(current_dir, d)
    for mp3_file in os.listdir(files_dir):
    	track_number = int(mp3_file[:2])  # get the first 2 chars
    	track_title = str(mp3_file[3:])   # get all chars after (above+space)

        audiofile = eyed3.load(os.path.join(current_dir, d, mp3_file))
        audiofile.initTag()

        audiofile.tag.artist = the_artist
        audiofile.tag.album = the_album
        audiofile.tag.album_artist = the_artist
        audiofile.tag.track_num = track_number
        audiofile.tag.title = unicode(track_title[:-4], "utf-8")  # strip off the ".mp3"

        audiofile.tag.save()

print "\nProcessing Time: %s seconds" % (time.time() - start_time)
print "\n ===================================================================="
