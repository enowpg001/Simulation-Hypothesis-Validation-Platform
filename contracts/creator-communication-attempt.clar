;; Creator Communication Attempt Contract

(define-data-var next-attempt-id uint u0)

(define-map communication-attempts
  { attempt-id: uint }
  {
    message: (string-utf8 256),
    response: (optional (string-utf8 256)),
    status: (string-ascii 20)
  }
)

(define-public (initiate-communication (message (string-utf8 256)))
  (let
    ((attempt-id (+ (var-get next-attempt-id) u1)))
    (var-set next-attempt-id attempt-id)
    (ok (map-set communication-attempts
      { attempt-id: attempt-id }
      {
        message: message,
        response: none,
        status: "sent"
      }
    ))
  )
)

(define-public (record-response (attempt-id uint) (response (string-utf8 256)))
  (let
    ((attempt (unwrap! (map-get? communication-attempts { attempt-id: attempt-id }) (err u404))))
    (ok (map-set communication-attempts
      { attempt-id: attempt-id }
      (merge attempt {
        response: (some response),
        status: "received"
      })
    ))
  )
)

(define-read-only (get-communication-attempt (attempt-id uint))
  (map-get? communication-attempts { attempt-id: attempt-id })
)

