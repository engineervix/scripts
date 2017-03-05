#!/usr/bin/env python
# -*- coding: utf-8 -*-


"""
This script grabs files of given extensions from a given URL 
and saves them in a specified folder. The links are saved to a file on disk.
Your System must have GNU Wget installed.
The script uses the following
    * `GNU Wget <https://www.gnu.org/software/wget/>`_ 
      via os.system('wget ...'), 
    * `Requests <http://docs.python-requests.org/en/master/>`_ and
    * `BeautifulSoup4 <https://www.crummy.com/software/BeautifulSoup/>`_  
to accomplish this task.

The same thing can be accomplished **purely using GNU Wget** as follows:
``wget -r -A comma,separated,list,of,extensions http://website.com`` [see below:]
``wget -r -A pdf,docx,doc,jpg,png,xls,xlsx,csv http://website.com``

**TODO**: make a more robust command-line interface by:
    - letting ``url``, ``file_types``, ``output_dir`` to be passed as *args
    - providing default ``file_types``

**CHANGELOG**:
    - 2016-Dec-29-Thur: Added ``urlparse`` import to allow 
      extraction of domain from a given URL.

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
import requests
from bs4 import BeautifulSoup, SoupStrainer
from urlparse import urlparse

__author__ = "Victor Miti"
__copyright__ = "Copyright (C) 2016 Victor Miti"
__credits__ = ['http://stackoverflow.com/questions/34632838/']
__license__ = "GPL"
__version__ = "1.0"
__maintainer__ = "Victor Miti"
__email__ = "victormiti@gmail.com"
__status__ = "Production/Stable"


# url= 'https://www.nzta.govt.nz/resources/motsam/part-2/motsam-2.html'
url= 'http://www.bcanotes.com/Sad.html'
parsed_uri = urlparse(url)
domain = '{uri.scheme}://{uri.netloc}/'.format(uri=parsed_uri)

# path to output folder, '.' or '' uses current folder
output_dir = '.'

file_types = ['.pdf', '.doc', '.docx', '.xls', '.xlsx', '.csv']

for file_type in file_types:

    response = requests.get(url)

    for link in BeautifulSoup(response.content, 'html.parser', parse_only=SoupStrainer('a')):
        if link.has_attr('href'):
            if file_type in link['href']:
                with open('wget_file_links.log', 'a') as f:
                    print >>f,link['href']                    
                if link['href'].startswith('http'):
                    full_path = link['href'].replace(" ", "%20")
                    os.system('wget --tries=3 -c %s -P %s' % (full_path, output_dir)) 
                else:
                    full_path = domain + link['href'].replace(" ", "%20")
                    os.system('wget --tries=3 -c %s -P %s' % (full_path, output_dir)) 