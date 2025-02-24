;; Reality Consistency Check Contract

(define-data-var next-glitch-id uint u0)

(define-map glitches
  { glitch-id: uint }
  {
    description: (string-utf8 256),
    severity: uint,
    status: (string-ascii 20)
  }
)

(define-public (report-glitch (description (string-utf8 256)) (severity uint))
  (let
    ((glitch-id (+ (var-get next-glitch-id) u1)))
    (var-set next-glitch-id glitch-id)
    (ok (map-set glitches
      { glitch-id: glitch-id }
      {
        description: description,
        severity: severity,
        status: "reported"
      }
    ))
  )
)

(define-public (update-glitch-status (glitch-id uint) (new-status (string-ascii 20)))
  (let
    ((glitch (unwrap! (map-get? glitches { glitch-id: glitch-id }) (err u404))))
    (ok (map-set glitches
      { glitch-id: glitch-id }
      (merge glitch { status: new-status })
    ))
  )
)

(define-read-only (get-glitch (glitch-id uint))
  (map-get? glitches { glitch-id: glitch-id })
)

