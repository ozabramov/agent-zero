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

# Fix: Pin numpy/scipy/scikit-learn AFTER all installs to resolve ABI mismatch.
# The upstream installs scipy 1.17 + numpy 2.x which causes:
#   ValueError: All ufuncs must have type `numpy.ufunc`
# We must fully purge stale .so/.py files before reinstalling, otherwise
# leftover Python files from scipy 1.17 reference symbols missing in 1.13.
RUN /opt/venv-a0/bin/pip uninstall -y scipy numpy scikit-learn && \
    rm -rf /opt/venv-a0/lib/python3.12/site-packages/scipy* \
           /opt/venv-a0/lib/python3.12/site-packages/numpy* \
           /opt/venv-a0/lib/python3.12/site-packages/sklearn* \
           /opt/venv-a0/lib/python3.12/site-packages/scikit_learn* && \
    /opt/venv-a0/bin/pip install --no-cache-dir \
    numpy==1.26.4 \
    scipy==1.13.1 \
    scikit-learn==1.5.2

# post installation steps
RUN bash /ins/post_install.sh $BRANCH

# Expose ports (8000 for Railway, 22 for SSH, 9000+ for services)
EXPOSE 22 8000 9000-9009

RUN chmod +x /exe/initialize.sh /exe/run_A0.sh /exe/run_searxng.sh /exe/run_tunnel_api.sh

# initialize runtime and switch to supervisord
CMD ["/exe/initialize.sh", "$BRANCH"]
