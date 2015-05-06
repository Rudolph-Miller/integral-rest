(in-package :cl-user)
(defpackage integral-rest.util
  (:use :cl
        :integral))
(in-package :integral-rest.util)

(syntax:use-syntax :annot)

@export
(defun slot-initarg (slot)
  (car (c2mop:slot-definition-initargs slot)))

@export
(defgeneric table-initargs (table)
  (:method ((table symbol))
    (table-initargs (find-class table)))
  (:method ((table class))
    (loop for slot in (c2mop:class-direct-slots table)
          for initarg = (slot-initarg slot)
          when initarg
            collecting initarg)))