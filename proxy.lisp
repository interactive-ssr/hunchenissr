(in-package #:issr)

(defun make-destinator (config)
  (lambda ()
    (if (str:starts-with-p "/-issr" (yxorp:header :uri))
        (if (yxorp:header :upgrade)
            (config-websocket-port config)
            (config-http-port config))
        (config-application-destination config))))

(defun insert-js-call (node id)
  (let* ((html (some-<> node
                 node-children
                 (find :html <> :key 'node-name)))
         (head (some-<> html
                 node-children
                 (find :head <> :key 'node-name)))
         (js (make-node :script '((:noupdate . "T"))
                        (format nil "connect(~S)" id))))
    (if head
        (setf (node-children head)
              (append (node-children head)
                      (list js)))
        (setf (node-children node)
              (append (node-children node)
                      (list js)))))
  node)

(defun add-ids-and-js-to-html (body)
  (if (str:containsp "/html" (yxorp:header :content-type)
                     :ignore-case t)
      (let ((page (-> body
                    plump:parse
                    plump-dom-dom
                    ensure-ids))
            (id (random-alphanum)))
        (insert-js-call page id)
        (princ-to-string page))
      body))
