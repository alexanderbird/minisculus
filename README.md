# Minisculus Compiler
[Assignment documentation](http://pages.cpsc.ucalgary.ca/~robin/class/411/M+/M+.txt)

## Quick Start
1. Install prerequisites ([Ruby 2.x](https://www.ruby-lang.org/en/documentation/installation/) and [bundler](http://bundler.io/))
2. Install dependancies (`bundle install`)
4. Run `ruby ./compile --help`

## Viewing the AST
Pipe the output of `./compile -m ast infile.m+` to anything.xml

    ./compile -m ast infile.m+ > outfile.xml

And view the xml file in a web browser or other xml renderrer. Note that error output is not rendered as xml, so attempt compiling, check for error messages, and then rerun while piping to file once you have confirmed that the infile can be parsed successfully. 


