# Use the pre-built base image for A0
# FROM agent-zero-base:local
# FROM agent0ai/agent-zero-base:testing
FROM agent0ai/agent-zero-base:latest

# Check if the argument is provided, else throw an error
ARG BRANCH
RUN if [ -z "$BRANCH" ]; then echo "ERROR: BRANCH is not set!" >&2; exit 1; fi
ENV BRANCH=$BRANCH

# Copy filesystem files to root
COPY ./fs/ /

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
# The base image's scipy 1.17 + numpy 2.x causes:
#   ValueError: All ufuncs must have type `numpy.ufunc`
RUN /opt/venv-a0/bin/pip install --no-cache-dir --force-reinstall \
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
