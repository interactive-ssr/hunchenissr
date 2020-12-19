(defpackage hunchenissr-asd
  (:use #:cl #:asdf))
(in-package #:hunchenissr-asd)

(defsystem #:hunchenissr
  :description "Make Interactive-Server-Side-Rendered web pages with declaritive and recursive programming."
  :author "Charles Jackson <charles.b.jackson@protonmail.com>"
  :license "LLGPL"
  :version "1"
  :serial t
  :depends-on (#:jonathan
               #:plump
               #:clws
               #:str
               #:hunchentoot
               #:issr-core)
  :components ((:file "package")
               (:file "hunchenissr" :depends-on ("package"))))
