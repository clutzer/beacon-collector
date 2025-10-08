from flask import Flask, request
import logging
from logging.handlers import RotatingFileHandler
import os
from datetime import datetime

app = Flask(__name__)

# Configure logging with rotation
log_file = '/logs/beacon.log'
os.makedirs(os.path.dirname(log_file), exist_ok=True)
handler = RotatingFileHandler(log_file, maxBytes=5*1024*1024, backupCount=5)
handler.setFormatter(logging.Formatter('%(asctime)s - %(message)s'))
logger = logging.getLogger('BeaconLogger')
logger.setLevel(logging.INFO)
logger.addHandler(handler)

@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def collect_beacon(path):
    # Capture request details
    client_ip = request.remote_addr
    full_url = request.url
    headers = dict(request.headers)
    
    # Log the details
    log_entry = f"IP: {client_ip}, URL: {full_url}, Headers: {headers}"
    logger.info(log_entry)
    
    # Return empty response
    return '', 204

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)
