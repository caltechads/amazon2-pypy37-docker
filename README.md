# amazon2-pypy37-docker

[PyPy](https://pypy.org) is a replacement for CPython. It is built using the
RPython language that was co-developed with it. The main reason to use it
instead of CPython is speed: it runs generally faster.

This project provides a version of the base `amazonlinux:2` image (see the
[DockerHub Amazon Linux page](https://hub.docker.com/_/amazonlinux)) with the current
stable version of pypy-3.7 (v7.3.3) installed into `/opt/pypy`.

[Repository page on Docker Hub](https://cloud.docker.com/u/caltechads/repository/docker/caltechads/pypy37)

## Available image tags in Docker Hub

 * `caltechads/pypy37:3.7-v7.3.3`: the latest version of pypy3.6 
 * `caltechads/pypy37:3.7-v7.3.3-build1`: the specific tag of latest version of the
   pypy3.6 build of `caltechads/pypy36:3.6-v7.3.0`

## Testing

You can run the container via

```
docker-compose up
```

And then exec into the container like so:

```
docker exec -ti pypy37 bash
```

## Pushing a new release to Docker Hub

The build takes a loooooong time on Docker Hub -- 1.5 hours -- and the Docker
Hub automated build system doesn't like this.  So we don't use Docker Hub's
"Automated Builds" feature for this like we do on other images.  Instead, we
build it manually and push.

When you are ready to push a new release to [DockerHub](https://hub.docker.com), commit
all your changes to `master`, then:

```
pip install -r requirements.txt
bumpversion patch
git checkout build
git merge master
git push --tags origin master build
# The build will take a long time -- 30 min or so
make build
make tag
docker login
# Enter the caltechads credentials
make push
```
