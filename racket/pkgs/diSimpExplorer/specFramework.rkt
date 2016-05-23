#lang racket

;;(require 
;;  net/url
;;  net/sendurl
;;)

;;(require web-server/http/request-structs)

(require "./restfulServlets.rkt")
(require "./dseFramework.rkt")

;; List the javascript files required to run Jasmine.js
;;
(define jasmine-js
  (list 
    "/jasmine/lib/jasmine-core/jasmine.js"
    "/jasmine/lib/jasmine-core/jasmine-html.js"
    "/jasmine/lib/jasmine-core/boot.js"
  )
)

;; capture the required paths for our local work
;;
(require racket/runtime-path)
(define-runtime-path 
  jasmine-java-script 
  "specs/javascript/node_modules/jasmine/node_modules/jasmine-core"
)
(define-runtime-path specs-java-script "specs/javascript")

;; create a list of the various specification files
;;
(define curDir (current-directory))
(current-directory "specs/javascript")
;;
(define functional-specs 
  (for/list
    ( [ aFile (in-directory "functional")] 
      #:when (regexp-match? #rx"\\.js$" aFile)
    )
    (string-append "/specs/" (path->string aFile))
  )
)
;;
(define integration-specs 
  (for/list
    ( [ aFile (in-directory "integration")] 
      #:when (regexp-match? #rx"\\.js$" aFile)
    )
    (string-append "/specs/" (path->string aFile))
  )
)
;;
(define unit-specs 
  (for/list
    ( [ aFile (in-directory "unit")] 
      #:when (regexp-match? #rx"\\.js$" aFile)
    )
    (string-append "/specs/" (path->string aFile))
  )
)
;;
(current-directory curDir)

;; Build the HTML parts from which we assemble each page
;;
(define header-preamble #<<END-OF-PREAMBLE
<html>
  <head>
    <title>diSimpExplorer Specification checking</title>
    <link rel="icon" type="image/png"
      href="/jasmine/images/jasmine_favicon.png" />
    <link rel="stylesheet" (type="text/css"
      href="/jasmine/lib/jasmine-core/jasmine.css" />

END-OF-PREAMBLE
)
;;
(define html-postamble #<<END-OF-POSTAMBLE
  </head>
  <body>
    <nav>
      <ul>
        <li><a href="/all">All</a></li>
        <li><a href="/functional">Functional</a></li>
        <li><a href="/integration">Integration</a></li>
        <li><a href="/unit">Unit</a></li>
        <li><a href="/quit">Quit</a></li>
      </ul>
    </nav>
  </body>
</html>
END-OF-POSTAMBLE
)
;;
(define (path->scriptStrings aPath)
  (list
    "    <script type=\"text/javascript\" src=\""
    aPath
    "\"></script>\n"
  )
)

;; Define the various pages/servlets
;;
(get "/all" 
  (lambda ()
    (string-append*
      (flatten 
        (list 
          header-preamble
          (map path->scriptStrings zepto-js)
          (map path->scriptStrings jasmine-js)
          (map path->scriptStrings functional-specs)
          (map path->scriptStrings integration-specs)
          (map path->scriptStrings unit-specs)
          html-postamble
        )
      )
    )
  )
)
;;
(get "/functional" 
  (lambda ()
    (string-append*
      (flatten 
        (list 
          header-preamble
          (map path->scriptStrings zepto-js)
          (map path->scriptStrings jasmine-js)
          (map path->scriptStrings functional-specs)
          html-postamble
        )
      )
    )
  )
)
;;
(get "/integration" 
  (lambda ()
    (string-append*
      (flatten 
        (list 
          header-preamble
          (map path->scriptStrings zepto-js)
          (map path->scriptStrings jasmine-js)
          (map path->scriptStrings integration-specs)
          html-postamble
        )
      )
    )
  )
)
;;
(get "/unit" 
  (lambda ()
    (string-append*
      (flatten 
        (list 
          header-preamble
          (map path->scriptStrings zepto-js)
          (map path->scriptStrings jasmine-js)
          (map path->scriptStrings unit-specs)
          html-postamble
        )
      )
    )
  )
)

(require "./binaryServlets.rkt")
(get-file "/jasmine" jasmine-java-script 3600 )

(get-file "/specs" specs-java-script 0 )