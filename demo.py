#!/usr/bin/env python3
from skinnywms.wmssvr import application
application.run(debug=True, threaded=False, host='0.0.0.0')