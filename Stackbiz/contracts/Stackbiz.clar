;; Stackbiz.clarity Contract
;; Contract for managing business registrations in the Stackbiz loyalty ecosystem network

;; Constants
(define-constant CONTRACT_ADMIN tx-sender)
(define-constant ERROR_PERMISSION_DENIED (err u100))
(define-constant ERROR_RECORD_NOT_FOUND (err u101))
(define-constant ERROR_RECORD_DUPLICATE (err u102))
(define-constant ERROR_INVALID_PARAMS (err u103))
(define-constant MAX_BUSINESS_TYPES u50)

;; Data maps
(define-map BusinessRegistry
  principal
  {
    merchant-name: (string-ascii 50),
    merchant-profile: (string-utf8 280),
    merchant-category: (string-ascii 20),
    merchant-active: bool,
    enrollment-height: uint
  }
)

(define-map ValidBusinessTypes (string-ascii 20) bool)

;; Variables
(define-data-var BusinessTypeCount uint u0)
(define-map BusinessTypeRegistry uint (string-ascii 20))

;; Private helper functions

(define-private (is-valid-business-type (category-name (string-ascii 20)))
  (default-to false (map-get? ValidBusinessTypes category-name))
)

;; Public functions

(define-public (register-merchant (merchant-name (string-ascii 50)) (merchant-profile (string-utf8 280)) (merchant-category (string-ascii 20)))
  (let ((caller tx-sender))
    (asserts! (and (> (len merchant-name) u0) (<= (len merchant-name) u50)) ERROR_INVALID_PARAMS)
    (asserts! (and (> (len merchant-profile) u0) (<= (len merchant-profile) u280)) ERROR_INVALID_PARAMS)
    (asserts! (and (> (len merchant-category) u0) (<= (len merchant-category) u20)) ERROR_INVALID_PARAMS)
    (asserts! (is-valid-business-type merchant-category) ERROR_INVALID_PARAMS)
    (asserts! (is-none (map-get? BusinessRegistry caller)) ERROR_RECORD_DUPLICATE)
    (ok (map-insert BusinessRegistry caller
      {
        merchant-name: merchant-name,
        merchant-profile: merchant-profile,
        merchant-category: merchant-category,
        merchant-active: true,
        enrollment-height: stacks-block-height
      }
    ))
  )
)

(define-public (update-merchant (merchant-name (string-ascii 50)) (merchant-profile (string-utf8 280)) (merchant-category (string-ascii 20)))
  (let ((caller tx-sender))
    (asserts! (and (> (len merchant-name) u0) (<= (len merchant-name) u50)) ERROR_INVALID_PARAMS)
    (asserts! (and (> (len merchant-profile) u0) (<= (len merchant-profile) u280)) ERROR_INVALID_PARAMS)
    (asserts! (and (> (len merchant-category) u0) (<= (len merchant-category) u20)) ERROR_INVALID_PARAMS)
    (asserts! (is-valid-business-type merchant-category) ERROR_INVALID_PARAMS)
    (match (map-get? BusinessRegistry caller)
      existing-record (ok (map-set BusinessRegistry caller
        (merge existing-record
          {
            merchant-name: merchant-name,
            merchant-profile: merchant-profile,
            merchant-category: merchant-category
          }
        )))
      ERROR_RECORD_NOT_FOUND
    )
  )
)

(define-public (deactivate-merchant)
  (let ((caller tx-sender))
    (match (map-get? BusinessRegistry caller)
      existing-record (ok (map-set BusinessRegistry caller (merge existing-record { merchant-active: false })))
      ERROR_RECORD_NOT_FOUND
    )
  )
)

(define-public (activate-merchant)
  (let ((caller tx-sender))
    (match (map-get? BusinessRegistry caller)
      existing-record (ok (map-set BusinessRegistry caller (merge existing-record { merchant-active: true })))
      ERROR_RECORD_NOT_FOUND
    )
  )
)

(define-public (add-business-type (category-name (string-ascii 20)))
  (let ((caller tx-sender)
        (current-type-count (var-get BusinessTypeCount)))
    (asserts! (is-eq caller CONTRACT_ADMIN) ERROR_PERMISSION_DENIED)
    (asserts! (and (> (len category-name) u0) (<= (len category-name) u20)) ERROR_INVALID_PARAMS)
    (asserts! (is-none (map-get? ValidBusinessTypes category-name)) ERROR_RECORD_DUPLICATE)
    (asserts! (< current-type-count MAX_BUSINESS_TYPES) ERROR_INVALID_PARAMS)
    (map-set ValidBusinessTypes category-name true)
    (map-set BusinessTypeRegistry current-type-count category-name)
    (var-set BusinessTypeCount (+ current-type-count u1))
    (ok true)
  )
)

(define-public (remove-business-type (category-name (string-ascii 20)))
  (let ((caller tx-sender))
    (asserts! (is-eq caller CONTRACT_ADMIN) ERROR_PERMISSION_DENIED)
    (asserts! (is-some (map-get? ValidBusinessTypes category-name)) ERROR_RECORD_NOT_FOUND)
    (map-delete ValidBusinessTypes category-name)
    (ok true)
  )
)

;; Read-only functions

(define-read-only (get-merchant-info (account principal))
  (map-get? BusinessRegistry account)
)

(define-read-only (is-merchant-active (account principal))
  (default-to false (get merchant-active (map-get? BusinessRegistry account)))
)

(define-read-only (get-business-type-by-id (index uint))
  (default-to "" (map-get? BusinessTypeRegistry index))
)

(define-read-only (is-valid-category (category-name (string-ascii 20)))
  (is-valid-business-type category-name)
)

(define-read-only (count-business-types)
  (var-get BusinessTypeCount)
)

;; Get all business types - completely rewritten to avoid interdependence
(define-read-only (get-all-business-types)
  (let ((type-count (var-get BusinessTypeCount)))
    (filter not-empty
      (list
        (get-business-type-by-id u0) (get-business-type-by-id u1) (get-business-type-by-id u2)
        (get-business-type-by-id u3) (get-business-type-by-id u4) (get-business-type-by-id u5)
        (get-business-type-by-id u6) (get-business-type-by-id u7) (get-business-type-by-id u8)
        (get-business-type-by-id u9) (get-business-type-by-id u10) (get-business-type-by-id u11)
        (get-business-type-by-id u12) (get-business-type-by-id u13) (get-business-type-by-id u14)
        (get-business-type-by-id u15) (get-business-type-by-id u16) (get-business-type-by-id u17)
        (get-business-type-by-id u18) (get-business-type-by-id u19) (get-business-type-by-id u20)
        (get-business-type-by-id u21) (get-business-type-by-id u22) (get-business-type-by-id u23)
        (get-business-type-by-id u24) (get-business-type-by-id u25) (get-business-type-by-id u26)
        (get-business-type-by-id u27) (get-business-type-by-id u28) (get-business-type-by-id u29)
        (get-business-type-by-id u30) (get-business-type-by-id u31) (get-business-type-by-id u32)
        (get-business-type-by-id u33) (get-business-type-by-id u34) (get-business-type-by-id u35)
        (get-business-type-by-id u36) (get-business-type-by-id u37) (get-business-type-by-id u38)
        (get-business-type-by-id u39) (get-business-type-by-id u40) (get-business-type-by-id u41)
        (get-business-type-by-id u42) (get-business-type-by-id u43) (get-business-type-by-id u44)
        (get-business-type-by-id u45) (get-business-type-by-id u46) (get-business-type-by-id u47)
        (get-business-type-by-id u48) (get-business-type-by-id u49)
      )
    )
  )
)

;; Helper for filtering out empty strings in lists
(define-private (not-empty (value (string-ascii 20)))
  (not (is-eq value ""))
)