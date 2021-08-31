(in-package #:issr)

(defvar *show-errors-to-client* nil
  "When non-nil, errors after the initial connection can be seen in console.error.")

(defun make-ws-message (host port)
  (lambda (socket message)
    (if (str:starts-with-p "id:" message)
        ;; first connection
        (let* ((id (subseq message 3))
               (info (get-id-client id)))
          (if (typep info 'request)
              (progn
                (set-client-request socket info)
                (set-id-client id socket)
                (format t "Connected to client with id:~a.~%" id))
              ;; (run-application-hook id "disconnect" host port)
              (pws:send socket (jojo:to-json (list (i:reconnect))))))
        ;; giving parameters to update page
        (handler-case (rr socket host port (jojo:parse message
                                                       :as :alist))
          (jojo:<jonathan-error> ()
            (pws:send socket (jojo:to-json (list (i:reconnect))))
            (pws:close socket))))))


(defun make-ws-close (host port)
  (lambda (socket)
    (run-application-hook
     (->> socket
       client-request
       (yxorp:header :issr-id))
     "disconnect" host port)
    (remove-client-request socket)))

(defun ws-error (socket condition)
  (when *show-errors-to-client*
    (pws:send
     socket
     (jojo:to-json
      (list (i:error (format nil "~A" condition)))))))