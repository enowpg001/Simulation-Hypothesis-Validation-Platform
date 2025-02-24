;; Ethical Simulated Life Contract

(define-data-var next-entity-id uint u0)

(define-map simulated-entities
  { entity-id: uint }
  {
    type: (string-ascii 50),
    consciousness-level: uint,
    rights: (list 5 (string-ascii 50))
  }
)

(define-public (register-entity (type (string-ascii 50)) (consciousness-level uint))
  (let
    ((entity-id (+ (var-get next-entity-id) u1)))
    (var-set next-entity-id entity-id)
    (ok (map-set simulated-entities
      { entity-id: entity-id }
      {
        type: type,
        consciousness-level: consciousness-level,
        rights: (list )
      }
    ))
  )
)

(define-public (grant-right (entity-id uint) (right (string-ascii 50)))
  (let
    ((entity (unwrap! (map-get? simulated-entities { entity-id: entity-id }) (err u404))))
    (ok (map-set simulated-entities
      { entity-id: entity-id }
      (merge entity {
        rights: (unwrap! (as-max-len? (append (get rights entity) right) u5) (err u401))
      })
    ))
  )
)

(define-read-only (get-entity (entity-id uint))
  (map-get? simulated-entities { entity-id: entity-id })
)

