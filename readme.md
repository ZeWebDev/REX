# REX

Bulk rename files using regex.
With a simple command you can replace a pattern in thousands of file names in seconds

## Usage

 ```sh
rex -r "\.html$" ".php"
```

The above will replace all .html extensions with .php

**Notes:**
Backslashes must either be escaped or in quotes.
Anything with whitespaces must be in quotes.

### Installation

REX is just 1 binary file so to install it you can just copy it to to /usr/bin/

 ```sh
sudo cp /path/to/rex /usr/bin
```

### Building

REX is made with Crystal so you are going to need it to build it from source.

Just run:

 ```sh
crystal build rex.cr
```


### Todos

 - Add comments
 - Cleanup messy code
