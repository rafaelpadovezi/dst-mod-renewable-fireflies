FROM alpine:latest

# Install Lua
RUN apk add --no-cache lua5.3 lua5.3-dev

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Set Lua path to include our modules
ENV LUA_PATH="/app/?.lua;/app/?/init.lua;;"

# Default command runs tests
CMD ["lua5.3", "tests/run_tests.lua"]