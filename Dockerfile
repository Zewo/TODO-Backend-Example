FROM kylef/swiftenv
MAINTAINER Dan Appel <dan.appel00@gmail.com>

# setup swift
RUN swiftenv install 3.0
# download postgresql adapter
RUN apt-get install -y libpq-dev

ENV APP=TodoBackend

RUN mkdir /$APP
WORKDIR /$APP

ADD . .

RUN swift build -c release -Xcc -I/usr/include/postgresql

EXPOSE 8080

CMD .build/release/$APP
