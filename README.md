# ob-graphql
> GraphQL execution backend for org-babel

This package provides an execution backend for org-babel source blocks that can execute GraphQL queries and display the results inline.

## Installation

This project is available [via Melpa](https://melpa.org/#/ob-graphql). You can install it via `M-x package-install <RET> ob-graphql` or using the package management solution of your choice. Alternatively, you can put `ob-graphql` on your load path somewhere and load it via `(require 'ob-graphql)`. After that you'll be able to evaluate GraphQL code blocks.

If you're installing `ob-graphql` manually you'll also need to install [`graphql-mode`](https://github.com/davazp/graphql-mode).

## Usage

The URL of the GraphQL server should be given by the `:url` header parameter:

``` org
#+BEGIN_SRC graphql :url https://countries.trevorblades.com/
  query GetContinents {
      continent(code: "AF") {
          name
	  code
      }
  }
#+END_SRC

#+RESULTS:
: {
:   "data": {
:     "continent": {
:       "name": "Africa",
:       "code": "AF"
:     }
:   }
: }
```

Variables can be passed into the source block from other source/example blocks via the `:variables` header parameter. The parameter should be the name of the variables source block, which should evaluate to the JSON body of the variables to pass into the query:

``` org
#+NAME: my-variables
#+begin_example
  {
      "continentCode": "AF"
  }
#+end_example

#+BEGIN_SRC graphql :url https://countries.trevorblades.com/ :variables my-variables
  query GetContinents($continentCode: String!) {
      continent(code: $continentCode) {
          name
	  code
      }
  }
#+END_SRC

#+RESULTS:
: {
:   "data": {
:     "continent": {
:       "name": "Africa",
:       "code": "AF"
:     }
:   }
: }
```

Additional headers, such as an `Authorization` header, can be passed into the query via the `:headers` header parameter. This parameter should be the name of another source block that evaluates to an alist of header names to header values:

``` org
#+NAME: my-headers
#+BEGIN_SRC emacs-lisp
  '(("Authorization" . "Bearer my-secret-token"))
#+END_SRC

#+BEGIN_SRC graphql :url https://countries.trevorblades.com/ :headers my-headers
  query GetContinents {
      continent(code: "AF") {
          name
	  code
      }
  }
#+END_SRC

#+RESULTS:
: {
:   "data": {
:     "continent": {
:       "name": "Africa",
:       "code": "AF"
:     }
:   }
: }
```
