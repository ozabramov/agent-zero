# Use the pre-built base image for A0
# FROM agent-zero-base:local
# FROM agent0ai/agent-zero-base:testing
FROM agent0ai/agent-zero-base:latest

# Branch to clone (default: main)
ARG BRANCH=main
ENV BRANCH=$BRANCH

# Copy filesystem files to root
COPY docker/run/fs/ /

# pre installation steps
RUN bash /ins/pre_install.sh $BRANCH

# install A0
RUN bash /ins/install_A0.sh $BRANCH

# install additional software
RUN bash /ins/install_additional.sh $BRANCH

# cleanup repo and install A0 without caching, this speeds up builds
ARG CACHE_DATE=none
RUN echo "cache buster $CACHE_DATE" && bash /ins/install_A02.sh $BRANCH

# Fix: Force-reinstall scipy/scikit-learn to ensure ABI compatibility.
# scipy 1.17.0 has a ufunc bug with numpy 2.x; pin to 1.15.1 which is stable.
# Keep numpy 2.x from the base image since torch etc. are compiled against it.
RUN /opt/venv-a0/bin/pip install --no-cache-dir --force-reinstall \
    scipy==1.15.1 \
    scikit-learn==1.6.1

# post installation steps
RUN bash /ins/post_install.sh $BRANCH

# Expose ports (8000 for Railway, 22 for SSH, 9000+ for services)
EXPOSE 22 8000 9000-9009

RUN chmod +x /exe/initialize.sh /exe/run_A0.sh /exe/run_searxng.sh /exe/run_tunnel_api.sh

# initialize runtime and switch to supervisord
CMD ["/exe/initialize.sh", "$BRANCH"]
