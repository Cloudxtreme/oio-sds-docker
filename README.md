# Open IO Docker container

This is a Dockerfile (and some utility scripts) for building [Open IO Software Defined Storage](http://openio.io/) on Ubuntu.

## Building the image

* Install [Docker](https://www.docker.com/).
* Download this Git repository.
* Build this container with Docker:
```shell
docker build -t conradkleinespel/oio-sds
```

## Using the image

You should now have a Docker image ready to run Open IO SDS. Here's how you can run the "default" Open IO installation:
```shell
docker run conradkleinespel/oio-sds
```

Or if you want to get access to a shell within the container, try this:
```shell
docker run --tty -i --entrypoint bash conradkleinespel/oio-sds
```

Once inside the shell, you can run any Open IO SDS commands you wish to run.

There is also a sample C program in `/test`. You can build and run it like this:
```shell
cd /test
make
./a.out
```
