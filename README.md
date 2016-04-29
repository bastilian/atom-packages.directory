# Atom Packages Directory

This is the application to maintain http://atom-packages.directory. The package directory itself is based on data from https://atom.io/packages/ and uses groups of keywords in categories to present them in browsable directory. Atom is an awesome text-editor, but it's true strength comes from the thousands of packages, the directory makes it easier to find them. The directory also brings forward a showcase of what Atom can be used for.

The site is built as a static page deployed on GitHub Pages. It is built with Sinatra and RethinkDB as a data storage. Even though it is deployed as a static page it has characteristics of a web application, like an API for the resources and a database in the back, this is only to make it possible to work with the amount of data in a reasonably performance.

This project adheres to the Contributor Covenant [code of conduct](/CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to sebastian@validcode.me.


## Contributing

There are a lot of ways to contribute and get involved. One is to put an effort in establishing new categories if you find one is missing, or it could be better structured or improve the site overall. For this you should setup a local development environment. If you have Docker and Docker Compose installed you are already set to go:

```shell
$ git clone https://github.com/bastilian/atom-packages.directory.git
$ cd atom-packages.directory
$ docker-compose run site rake bootstrap # Takes a while...
$ docker-compose up site
```

Once the bootstrap process is finished and the site is up, head to your browser and go to `http://DOCKER_IP` and you should see exactly the same as on the live site.

 Another way is to assign keywords to packages that have none by opening a pull request and add them to their repositories `package.json`.

## License

 MIT License

 Copyright (c) 2016 Sebastian Gräßl

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
