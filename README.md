# Docker Container for a terraform Jenkins build agent


To build locally

    docker build \
                -t jenkins-terraform-ci:latest \
                .

To build for release

    docker build \
                -t jenkins-terraform-ci:latest \
                --no-cache=true --force-rm=true --compress \
                .

To run

    docker run -t -i --rm jenkins-terraform-ci:latest
