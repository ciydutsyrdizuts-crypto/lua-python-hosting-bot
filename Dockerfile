FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV LUA_CPATH="/usr/local/lib/lua/5.3/?.so;/usr/lib/x86_64-linux-gnu/lua/5.3/?.so;;"

# System tools and native dependencies for TDLib, tdlua, Python and Lua 5.3.
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates git cmake build-essential gperf php-cli zlib1g-dev libssl-dev \
    lua5.3 liblua5.3-dev python3 python3-pip python3-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Build and install TDLib first, so tdlua's CMake find_package(Td) can find it.
WORKDIR /tmp/build
RUN git clone --depth 1 https://github.com/tdlib/td.git tdlib-src \
    && cmake -S tdlib-src -B tdlib-src/build \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_INSTALL_PREFIX=/usr/local \
    && cmake --build tdlib-src/build --target install --parallel 2 \
    && ldconfig

# Build the Lua binding against the installed TDLib.
RUN git clone --recursive --depth 1 https://github.com/tgMember/tdlua.git tdlua-src \
    && cmake -S tdlua-src -B tdlua-src/build \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_PREFIX_PATH=/usr/local \
       -DTD_DIR=/usr/local \
    && cmake --build tdlua-src/build --parallel 2 \
    && cmake --install tdlua-src/build \
    && ldconfig

WORKDIR /app
COPY requirements.txt ./requirements.txt
RUN python3 -m pip install --no-cache-dir -r requirements.txt
COPY main.py ./main.py

CMD ["python3", "-u", "main.py"]
