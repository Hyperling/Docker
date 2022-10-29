# 2022-10-29 Hyperling
# Create website in node container and run it.

FROM node

RUN git clone https://github.com/Hyperling/www www

RUN apt update && apt install sudo

RUN www/run.sh
