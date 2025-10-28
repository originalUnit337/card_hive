FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    FLUTTER_HOME=/opt/flutter \
    PATH=/opt/flutter/bin:/opt/flutter/bin/cache/dart-sdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip xz-utils zip libglu1-mesa clang cmake ninja-build \
    libgtk-3-0 libdbus-1-3 ca-certificates build-essential \
 && rm -rf /var/lib/apt/lists/*

RUN git clone --depth 1 https://github.com/flutter/flutter.git -b stable ${FLUTTER_HOME} \
 && flutter doctor -v || true

WORKDIR /app
COPY pubspec.* /app/

RUN flutter pub get

COPY . /app

RUN flutter config --enable-linux-desktop || true
RUN flutter build linux --release || true

CMD ["/bin/bash"]
