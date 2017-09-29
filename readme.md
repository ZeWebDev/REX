# REX

Bulk rename files using regex.
With a simple command you can replace a pattern in thousands of file names in seconds

## Usage

 ```sh
rex -r "\.html$" ".php"
```

The above will replace all .html extensions with .php

**Notes:**
Backslashes and whitespaces must either be escaped or in quotes.

### Installation

REX is just 1 binary file so to install it you can just copy it to to /usr/bin/

 ```sh
sudo cp /path/to/rex /usr/bin   # Or anywhere in your PATH
```

### Building

REX is made with Crystal so you are going to need it to build it from source.

Just run:

 ```sh
crystal build rex.cr --release
```


### Todos

 - Add comments
 - Cleanup messy code
