
INTRO

JSON is ideal as a neutral pure data or API format, but it is a poor choice for a configuration language.

Configuration management is exploratory abd interactive, comments are needed to explain different options, to toggle inert code. 
Json does not support comments.

Json insists on quotes for key values, and does not support multi-line values.  Json is also too strict on not allowing trailing comas in maps and lists, which makes it very hard to cut and paste template code.

Hjson extennds JSON to do just that.


{
  # TL;DR
  human:   Hjson
  machine: JSON
}
How does Hjson help?

COMMAS!
Never see a syntax error because of a missing or trailing comma again (unless you try really hard).

A good practice is to put each value onto a new line, in this case commas are optional and should be omitted.

{
  first: 1
  second: 2
}
COMMENTS
You are allowed to use comments! Encouraged, even!

Comments allow you to document your data inline. You can also use them to comment out values when testing.

{
  # hash style comments
  # (because it's just one character)

  // line style comments
  // (because it's like C/JavaScript/...)

  /* block style comments because
     it allows you to comment out a block */

  # Everything you do in comments,
  # stays in comments ;-}
}
OBJECT NAMES (KEYS)
Object names can be specified without quotes.

This makes them easier to read.

{
  # specify rate in requests/second
  rate: 1000
}
QUOTELESS STRINGS
You can specify strings without quotes.

In this case only one value per line and no commas are allowed.

{
  JSON: "a string"

  Hjson: a string

  # notice, no escape necessary:
  RegEx: \s+
}
MULTILINE
Write multiline strings with proper whitespace handling.

A simple syntax and easy to read.

{
  md:
    '''
    First line.
    Second line.
      This line is indented by two spaces.
    '''
}
PUNCTUATORS, SPACES AND ESCAPES
JSON and Hjson use the characters {}[],: as punctuators to define the structure of the data.

Punctuators and whitespace can't be used in an unquoted key or as the first character of a quoteless string. In this (rather uncommon) case you need to use quotes.

The backslash is only used as an escape character in a quoted string.

{
  "key name": "{ sample }"
  "{}": " spaces at the start/end "
  this: is OK though: {}[],:
}
HJSON
"So this is Hjson."

If you like it please go ahead and add a star!


Are you a user? Then ask the developer of your favorite application to add Hjson support!

Interested in details? Take a look at the syntax.

Questions? See the FAQ.

{
  // use #, // or /**/ comments,
  // omit quotes for keys
  key: 1
  // omit quotes for strings
  contains: everything on this line
  // omit commas at the end of a line
  cool: {
    foo: 1
    bar: 2
  }
  // allow trailing commas
  list: [
    1,
    2,
  ]
  // and use multiline strings
  realist:
    '''
    My half empty glass,
    I will fill your empty half.
    Now you are half full.
    '''
}
Users Developers Syntax Try FAQ Feedback History
