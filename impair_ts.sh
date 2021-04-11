#!/bin/bash
ffmpeg -f lavfi -re \
-i smptebars=duration=6000:size=1280x720:rate=30 \
-f lavfi -re \
-i sine=frequency=1000:duration=6000:sample_rate=44100 \
-pix_fmt yuv420p        \
-c:v libx264 -b:v 1000k \
-g 30 -keyint_min 120 \
-profile:v baseline        \
-preset veryfast \
-f mpegts "udp://127.0.0.1:7000?&pkt_size=1316" | tsp -I ip 7000  \
    -P filter --pid 256 --set-label 0 \
    -P filter --only-label 0 --every 2 -O file capture.ts