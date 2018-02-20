import urllib.request, urllib.parse, urllib.error
import ssl
import json
import sys
import requests
from requests.exceptions import HTTPError


# Ignore SSL certificate errors
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE


try:
    html = urllib.request.urlopen('http://' + sys.argv[1] + ':8888/v1/chain/get_info', context=ctx).read()
    node = json.loads(html)



    if float(node['participation_rate']) >=  0.5:
        print("OK")
        sys.exit(0)
    else:
        print("FAIL! Node Particiation is less 0.5")
        sys.exit(2)


except HTTPError:
    print("FAIL! HTTPError")
    sys.exit(2)
