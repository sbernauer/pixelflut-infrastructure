#!/usr/bin/env python3

import sys
import signal
import time
import socket
import json

if (len(sys.argv) != 4):
    print("Must have 3 arguments: Pixelflut address to crawl, Pixelflut port to crawl, " \
        + "file to write prometheus statistics to")
    sys.exit(-1)

HOST = sys.argv[1]
PORT = int(sys.argv[2])
FILE = sys.argv[3]

def sigterm_handler(_signo, _stack_frame):
    sys.exit(0)

signal.signal(signal.SIGTERM, sigterm_handler)

print(f"Crawling from {HOST} at port {PORT} to file {FILE}")
while True:
    try:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            s.connect((HOST, PORT))
            
            data = s.recv(1024)
            s.close()

            statistics = json.loads(data)

            text = "pixelflut_bytes " + str(statistics['traffic']['bytes']) + "\n" \
            + "pixelflut_pixels " + str(statistics['traffic']['pixels']) + "\n" \
            + "pixelflut_connections " + str(statistics['connections']) + "\n" \
            + "pixelflut_fps " + str(statistics['fps']) + "\n"
            
            myfile = open(FILE, 'w')
            myfile.write(text)
            myfile.close()
    except:
        print(f"Cant crawl from {HOST} at port {PORT} to file {FILE}")
        text = "pixelflut_bytes 0\n" \
        + "pixelflut_pixels 0\n" \
        + "pixelflut_connections 0\n" \
        + "pixelflut_fps 0\n"
        
        myfile = open(FILE, 'w')
        myfile.write(text)
        myfile.close()

    time.sleep(5)
