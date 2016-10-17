FROM kylef/swiftenv
MAINTAINER Dan Appel <dan.appel00@gmail.com>

# setup swift
RUN swiftenv install 3.0

# If not set, app defaults to localhost:8080/
#ENV API_ROOT=MY_API_ROOT
ENV APP=TodoBackend

RUN mkdir /$APP
WORKDIR /$APP

ADD . .

RUN swift build -c release

EXPOSE 8080

CMD .build/release/$APP
