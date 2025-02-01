;; FlexHive Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-invalid-gig (err u101))
(define-constant err-already-applied (err u102))
(define-constant err-insufficient-funds (err u103))
(define-constant err-not-authorized (err u104))

;; Data Variables
(define-data-var next-gig-id uint u0)
(define-data-var platform-fee uint u25) ;; 2.5%

;; Data Maps
(define-map gigs
  { gig-id: uint }
  {
    employer: principal,
    title: (string-utf8 100),
    description: (string-utf8 1000),
    compensation: uint,
    status: (string-ascii 20),
    worker: (optional principal),
    created-at: uint
  }
)

(define-map applications
  { gig-id: uint, applicant: principal }
  {
    proposal: (string-utf8 500),
    status: (string-ascii 20)
  }
)

(define-map ratings
  { gig-id: uint, rater: principal }
  {
    rating: uint,
    review: (string-utf8 500)
  }
)

;; Public Functions
(define-public (post-gig (title (string-utf8 100)) 
                        (description (string-utf8 1000)) 
                        (compensation uint))
  (let ((gig-id (var-get next-gig-id)))
    (try! (stx-transfer? compensation tx-sender (as-contract tx-sender)))
    (map-set gigs
      { gig-id: gig-id }
      {
        employer: tx-sender,
        title: title,
        description: description,
        compensation: compensation,
        status: "open",
        worker: none,
        created-at: block-height
      }
    )
    (var-set next-gig-id (+ gig-id u1))
    (ok gig-id)))

(define-public (apply-for-gig (gig-id uint) 
                             (proposal (string-utf8 500)))
  (let ((gig (unwrap! (map-get? gigs { gig-id: gig-id }) 
                     (err err-invalid-gig))))
    (asserts! (is-eq (get status gig) "open") 
             (err err-invalid-gig))
    (map-set applications
      { gig-id: gig-id, applicant: tx-sender }
      {
        proposal: proposal,
        status: "pending"
      }
    )
    (ok true)))
