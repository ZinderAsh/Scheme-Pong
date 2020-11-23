#lang scheme

(require graphics/graphics)

(open-graphics)

(define v (open-viewport "Pong" 600 400))
(define p (open-pixmap "pix" 600 400))

(define (main bx by bvx bvy px score curkey)
  ((clear-solid-rectangle p) (make-posn 0 0) 600 400)
  ((draw-solid-ellipse p) (make-posn bx by) 10 10)
  ((draw-solid-rectangle p) (make-posn px 360) 50 5)
  ((draw-string p) (make-posn 4 16) (number->string score))
  (copy-viewport p v)
  (sleep 0.02)
  (define hitpaddle (and (> bvy 0) (>= by 350) (< by 360) (>= bx (- px 5)) (<= bx (+ px 45))))
  (define hitkey (ready-key-press v))
  (define key (if hitkey (key-value hitkey) #f))
  (if (< by 400) (main (+ bx bvx) (+ by bvy)
                       (if (or (and (> bvx 0) (>= bx 590)) (and (< bvx 0) (<= bx 0))) (- bvx) bvx)
                       (if (or hitpaddle (and (< bvy 0) (<= by 0))) (- bvy) bvy)
                       (cond ((eq? curkey 'right) (+ px 6))
                             ((eq? curkey 'left) (- px 6))
                             (else px))
                       (if hitpaddle (+ score 1) score)
                       (if hitkey key curkey))
      score)
  )

(define (start)
  (main 200 300 -3 -3 300 0 'release))

(start)

(close-viewport v)
(close-graphics)