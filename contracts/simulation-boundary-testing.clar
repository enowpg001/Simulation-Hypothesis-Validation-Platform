;; Simulation Boundary Testing Contract

(define-data-var next-test-id uint u0)

(define-map boundary-tests
  { test-id: uint }
  {
    type: (string-ascii 50),
    result: (optional (string-utf8 256)),
    status: (string-ascii 20)
  }
)

(define-public (initiate-boundary-test (type (string-ascii 50)))
  (let
    ((test-id (+ (var-get next-test-id) u1)))
    (var-set next-test-id test-id)
    (ok (map-set boundary-tests
      { test-id: test-id }
      {
        type: type,
        result: none,
        status: "initiated"
      }
    ))
  )
)

(define-public (update-test-result (test-id uint) (result (string-utf8 256)))
  (let
    ((test (unwrap! (map-get? boundary-tests { test-id: test-id }) (err u404))))
    (ok (map-set boundary-tests
      { test-id: test-id }
      (merge test {
        result: (some result),
        status: "completed"
      })
    ))
  )
)

(define-read-only (get-boundary-test (test-id uint))
  (map-get? boundary-tests { test-id: test-id })
)

