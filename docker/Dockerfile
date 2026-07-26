FROM archlinux:base-devel

# Install build dependencies
RUN pacman -Syu --noconfirm \
    archiso \
    git \
    dosfstools \
    libisoburn \
    make

# Set up working directory
WORKDIR /work

# Copy repo into container
COPY . /work/

# Generate packages and sync theming
RUN bash /work/scripts/gen-packages.sh && \
    bash /work/scripts/sync-theming.sh || true

# Build ISO
RUN mkdir -p /work/out && \
    mkarchiso -v -w /work/work -o /work/out /work/archiso

# Copy artifacts to output
RUN ls -lh /work/out/
