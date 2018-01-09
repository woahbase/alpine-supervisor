[![Build Status](https://travis-ci.org/woahbase/alpine-supervisor.svg?branch=master)](https://travis-ci.org/woahbase/alpine-supervisor) [![](https://images.microbadger.com/badges/image/woahbase/alpine-supervisor.svg)](https://microbadger.com/images/woahbase/alpine-supervisor) [![](https://images.microbadger.com/badges/commit/woahbase/alpine-supervisor.svg)](https://microbadger.com/images/alpine-supervisor) [![](https://images.microbadger.com/badges/version/woahbase/alpine-supervisor.svg)](https://microbadger.com/images/woahbase/alpine-supervisor)

## Alpine-Supervisor
#### Container for Alpine Linux + Supervisor Init System

---

This [image][8] serves as the base container for applications
/ services that need an init system to launch the processes and
pass the proper signals when interacted with the containers.

Built from my [alpine-base][9] image with the [supervisor][10]([Github][11]) init system
overlayed on it.

The image is tagged respectively for 2 architectures,
* **armhf**
* **x86_64**

**armhf** builds have embedded binfmt_misc support and contain the
[qemu-user-static][5] binary that allows for running it also inside
an x64 environment that has it.

---
#### Get the Image
---

Pull the image for your architecture it's already available from
Docker Hub.

```
# make pull
docker pull woahbase/alpine-supervisor:x86_64

```

---
#### Run
---

If you want to run images for other architectures, you will need
to have binfmt support configured for your machine. [**multiarch**][4],
has made it easy for us containing that into a docker container.

```
# make regbinfmt
docker run --rm --privileged multiarch/qemu-user-static:register --reset

```
Without the above, you can still run the image that is made for your
architecture, e.g for an x86_64 machine..

For custom configuration, replace the `/etc/supervisord.conf` with
your own. By default, the supervisor configuration `ini` files
inside `/etc/supervisor.d/` are sourced so you can also put your
application configurations there, or bind mount the directory from
your local.

```
# make
docker run --rm -it \
  --name docker_supervisor --hostname supervisor \
  -v conf:/etc/supervisor.d \
  woahbase/alpine-supervisor:x86_64

# make stop
docker stop -t 2 docker_supervisor

# make rm
# stop first
docker rm -f docker_supervisor

# make restart
docker restart docker_supervisor

```

---
#### Shell access
---

```
# make rshell
docker exec -u root -it docker_supervisor /bin/bash

# make shell
docker exec -it docker_supervisor /bin/bash

# make logs
docker logs -f docker_supervisor

```

---
## Development
---

If you have the repository access, you can clone and
build the image yourself for your own system, and can push after.

---
#### Setup
---

Before you clone the [repo][7], you must have [Git][1], [GNU make][2],
and [Docker][3] setup on the machine.

```
git clone https://github.com/woahbase/alpine-supervisor
cd alpine-supervisor

```
You can always skip installing **make** but you will have to
type the whole docker commands then instead of using the sweet
make targets.

---
#### Build
---

You need to have binfmt_misc configured in your system to be able
to build images for other architectures.

Otherwise to locally build the image for your system.

```
# make ARCH=x86_64 build
# sets up binfmt if not x86_64
docker build --rm --compress --force-rm \
  --no-cache=true --pull \
  -f ./Dockerfile_x86_64 \
  -t woahbase/alpine-supervisor:x86_64 \
  --build-arg ARCH=x86_64 \
  --build-arg DOCKERSRC=alpine-base \
  --build-arg USERNAME=woahbase

# make ARCH=x86_64 test
docker run --rm -it \
  --name docker_supervisor --hostname supervisor \
  woahbase/alpine-supervisor:x86_64 \
  --version

# make ARCH=x86_64 push
docker push woahbase/alpine-supervisor:x86_64

```

---
## Maintenance
---

Built daily at Travis.CI (armhf / x64 builds). Docker hub builds maintained by [woahbase][6].

[1]: https://git-scm.com
[2]: https://www.gnu.org/software/make/
[3]: https://www.docker.com
[4]: https://hub.docker.com/r/multiarch/qemu-user-static/
[5]: https://github.com/multiarch/qemu-user-static/releases/
[6]: https://hub.docker.com/u/woahbase

[7]: https://github.com/woahbase/alpine-supervisor
[8]: https://hub.docker.com/r/woahbase/alpine-supervisor
[9]: https://hub.docker.com/r/woahbase/alpine-base

[10]: http://supervisord.org/index.html
[11]: https://github.com/Supervisor/supervisor