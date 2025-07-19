;; Grid Contribution Contract
;; Tracks energy fed into power grids and manages rewards

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INVALID-AMOUNT (err u102))
(define-constant ERR-PRODUCER-NOT-FOUND (err u103))
(define-constant ERR-GRID-CONNECTION-REQUIRED (err u108))

;; Data Variables
(define-data-var next-contribution-id uint u1)
(define-data-var grid-rate uint u50) ;; Rate per kWh in micro-STX
(define-data-var total-grid-contributions uint u0)

;; Data Maps
(define-map grid-connections
  { producer-id: uint }
  {
    connected: bool,
    connection-date: uint,
    grid-operator: principal,
    approved: bool
  }
)

(define-map grid-contributions
  { contribution-id: uint }
  {
    producer-id: uint,
    amount: uint,
    timestamp: uint,
    block-height: uint,
    rate: uint,
    reward: uint,
    paid: bool
  }
)

(define-map producer-grid-stats
  { producer-id: uint }
  {
    total-contributed: uint,
    total-rewards: uint,
    last-contribution-block: uint,
    contribution-count: uint
  }
)

;; Read-only functions
(define-read-only (get-grid-connection (producer-id uint))
  (map-get? grid-connections { producer-id: producer-id })
)

(define-read-only (get-grid-contribution (contribution-id uint))
  (map-get? grid-contributions { contribution-id: contribution-id })
)

(define-read-only (get-producer-grid-stats (producer-id uint))
  (map-get? producer-grid-stats { producer-id: producer-id })
)

(define-read-only (get-grid-rate)
  (var-get grid-rate)
)

(define-read-only (get-total-grid-contributions)
  (var-get total-grid-contributions)
)

(define-read-only (calculate-reward (amount uint))
  (* amount (var-get grid-rate))
)

;; Public functions
(define-public (request-grid-connection (producer-id uint))
  (begin
    (map-set grid-connections
      { producer-id: producer-id }
      {
        connected: false,
        connection-date: (unwrap-panic (get-block-info? time block-height)),
        grid-operator: CONTRACT-OWNER,
        approved: false
      }
    )
    (ok true)
  )
)

(define-public (approve-grid-connection (producer-id uint))
  (let
    (
      (connection (unwrap! (get-grid-connection producer-id) ERR-PRODUCER-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-UNAUTHORIZED)

    (map-set grid-connections
      { producer-id: producer-id }
      (merge connection { connected: true, approved: true })
    )

    (ok true)
  )
)

(define-public (contribute-to-grid (producer-id uint) (amount uint))
  (let
    (
      (connection (unwrap! (get-grid-connection producer-id) ERR-PRODUCER-NOT-FOUND))
      (contribution-id (var-get next-contribution-id))
      (reward (calculate-reward amount))
      (current-stats (default-to
        { total-contributed: u0, total-rewards: u0, last-contribution-block: u0, contribution-count: u0 }
        (get-producer-grid-stats producer-id)
      ))
    )
    (asserts! (get connected connection) ERR-GRID-CONNECTION-REQUIRED)
    (asserts! (get approved connection) ERR-GRID-CONNECTION-REQUIRED)
    (asserts! (> amount u0) ERR-INVALID-AMOUNT)

    (map-set grid-contributions
      { contribution-id: contribution-id }
      {
        producer-id: producer-id,
        amount: amount,
        timestamp: (unwrap-panic (get-block-info? time block-height)),
        block-height: block-height,
        rate: (var-get grid-rate),
        reward: reward,
        paid: false
      }
    )

    (map-set producer-grid-stats
      { producer-id: producer-id }
      {
        total-contributed: (+ (get total-contributed current-stats) amount),
        total-rewards: (+ (get total-rewards current-stats) reward),
        last-contribution-block: block-height,
        contribution-count: (+ (get contribution-count current-stats) u1)
      }
    )

    (var-set next-contribution-id (+ contribution-id u1))
    (var-set total-grid-contributions (+ (var-get total-grid-contributions) amount))

    (ok contribution-id)
  )
)

(define-public (pay-grid-reward (contribution-id uint))
  (let
    (
      (contribution (unwrap! (get-grid-contribution contribution-id) ERR-PRODUCER-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-UNAUTHORIZED)
    (asserts! (not (get paid contribution)) ERR-UNAUTHORIZED)

    (map-set grid-contributions
      { contribution-id: contribution-id }
      (merge contribution { paid: true })
    )

    (ok (get reward contribution))
  )
)

(define-public (update-grid-rate (new-rate uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-UNAUTHORIZED)
    (asserts! (> new-rate u0) ERR-INVALID-AMOUNT)

    (var-set grid-rate new-rate)
    (ok true)
  )
)

(define-public (disconnect-from-grid (producer-id uint))
  (let
    (
      (connection (unwrap! (get-grid-connection producer-id) ERR-PRODUCER-NOT-FOUND))
    )
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-UNAUTHORIZED)

    (map-set grid-connections
      { producer-id: producer-id }
      (merge connection { connected: false, approved: false })
    )

    (ok true)
  )
)
