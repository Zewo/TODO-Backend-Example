# Todo Backend
[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/) [![Zewo](https://img.shields.io/badge/Zewo-0.7-FF7565.svg?style=flat)](http://zewo.io) [![Platforms Mac - Linux](https://img.shields.io/badge/Platforms-OS%20X%20--%20Linux-lightgray.svg?style=flat)](https://developer.apple.com/swift/) [![License MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat)](https://tldrlegal.com/license/mit-license) [![Slack Status](https://zewo-slackin.herokuapp.com/badge.svg)](http://slack.zewo.io)

This repository contains an implementation of Todo Backend created using Zewo components.

> The Todo-Backend project helps showcase and compare different language and framework combinations for building web services. This website defines a simple web API in the form of a todo list and users can create their own identical APIs using various tech stacks. This website then provides a spec runner to verify that the user implementation is identical to the base implementation.

## Architecture
The application is split up into three components: [Models](https://github.com/Zewo/TodoBackend/tree/master/Sources/TodoBackend/Models), [Resources](https://github.com/Zewo/TodoBackend/tree/master/Sources/TodoBackend/Resources), and [Storage](https://github.com/Zewo/TodoBackend/tree/master/Sources/TodoBackend/Storage).

### Models
The `Models` directory contains the bare minimum for the Todo model and avoids giving it state/optionality by abstracting its "entity" behavior (`id`, `url`) in an Entity wrapper struct. The (fairly concise) boilerplate for serializing and instantiating the structs from and to [`StructuredData`](https://github.com/Zewo/StructuredData), which is then transparently converted to the correct data type for the API (in this case, JSON) by the resource.

### Resources
The resources directory contains a single resource which defines all of the routes. Since most of the hard work (serializing our models to and from JSON) is done by the [Resource]([Resource](https://github.com/Zewo/Resource)) module, the rest of the code is just glue that interacts with the data store.

### Storage
For Storage, we define a `TodoStore` protocol which defines the necessary methods for interacting with a data store (fetch, insert, update, remove). A simple in-memory implementation of the protocol is included which just uses a dictionary for storage.

Thanks to this architecture, our application's code is simple to understand, boilerplate-free, and highly maintainable. While this is by no means a perfect architecture, it can be a good example to follow for your own application.

## Setup
### Setting up the environment
You can follow the setup instructions for Zewo in the [main readme](https://github.com/Zewo/Zewo). In short, just install the 05-09 Swift development snapshot.

### Running the project locally
Simply clone this repository (`git clone https://github.com/Zewo/TodoBackend.git`) and run `swift build`. Once the build process finishes, an executable for the application should pop up at `.build/debug/TodoBackend`.

### Deploying the project with Docker
To begin, clone the repository (`git clone https://github.com/Zewo/TodoBackend.git`) and [install Docker](https://docs.docker.com/engine/installation/).

There is a basic Dockerfile in the root of the repository that installs Swift, builds the application, and runs it. Before you can use it, however, you need to set the [API_ROOT](https://github.com/Zewo/TodoBackend/blob/master/Dockerfile#L7) environmental variable to the full url at which it will be deployed (for example, `https://myapi.com/`).

Once you have the Dockerfile configured, build the docker image (`docker build -t zewo/todobackend .`). With the image built, run it using the [`docker run`](https://docs.docker.com/engine/reference/run/) family of commands. For example, `docker run -itd -p 0.0.0.0:80:8080 zewo/todobackend` will start a container running the Todo Backend application in the background, and map the containers `8080` port to the machine's `80` (default http) port.

## Support
If you need any help you can join our [Slack](http://slack.zewo.io) and go to the **#help** channel. Or you can create a Github [issue](https://github.com/Zewo/Zewo/issues/new) in our main repository. When stating your issue be sure to add enough details, specify what module is causing the problem and reproduction steps.

## Community
[![Slack](http://s13.postimg.org/ybwy92ktf/Slack.png)](https://zewo-slackin.herokuapp.com/badge.svg)

The entire Zewo code base is licensed under MIT. By contributing to Zewo you are contributing to an open and engaged community of brilliant Swift programmers. Join us on [Slack](http://slack.zewo.io) to get to know us!

## License
This project is released under the MIT license. See [LICENSE](LICENSE) for details.
