FROM zewo/swiftdocker:0.7.0

MAINTAINER Dan Appel <dan.appel00@gmail.com>
ENV DEBIAN_FRONTEND=noninteractive

# If not set, app defaults to localhost:8080/
#ENV API_ROOT=MY_API_ROOT
ENV APP=TodoBackend

RUN mkdir /$APP
WORKDIR /$APP

ADD . /$APP

RUN swift build -Xswiftc -O

EXPOSE 8080

CMD .build/debug/$APP
