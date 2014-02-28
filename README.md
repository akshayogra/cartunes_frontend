# dplyr

Musical democracy for Design Works.


## Run and develop

    $ coffee -bc -o app app-src
    $ npm install -g grunt-cli && npm install && grunt start-dev-server

Then open http://127.0.0.1:8080/ in your web browser.

To have the coffee auto-compile as you develop:

    $ coffee -wbc -o app app-src

When working on the client side coffeescript:

    $ cd app-src/views/js
    $ grunt run-tests

The client side test suite will be running at http://127.0.0.1:9001/ It will
auto-compile from the previous `start-dev-server` grunt task you had run
previously.
