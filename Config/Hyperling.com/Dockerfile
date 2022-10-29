# 2022-10-29 Hyperling
# Create website in node container and run it.

FROM node

# Dependencies
RUN apt update && apt install sudo

# Install website
RUN git clone https://github.com/Hyperling/www www

# Run website
RUN www/run.sh
