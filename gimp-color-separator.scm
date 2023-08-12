(define (script-fu-knit-color-separator inImage inLayer lengthenFirst selectSize lengthenSecond)
(let* (
    (width (car (gimp-drawable-width inLayer)))
    (height (car (gimp-drawable-height inLayer)))
    (position-x (car (gimp-drawable-offsets inLayer)))
    (position-y (cadr (gimp-drawable-offsets inLayer)))
  )

  (gimp-context-push)
  (gimp-context-set-paint-mode LAYER-MODE-NORMAL)
  (gimp-context-set-opacity 100.0)
  (gimp-context-set-feather FALSE)
  (gimp-context-set-interpolation 0)
  (gimp-image-undo-group-start inImage)
  (if (> lengthenFirst 0)  ; elongate first
    (begin
      (gimp-image-scale inImage width (* height (* lengthenFirst 2)))
    )
  )
  (letrec ((loop (lambda (i max)
                    (if (< i max)
                        (begin ; invert alternate rows of pixels
                          (gimp-image-select-rectangle inImage CHANNEL-OP-REPLACE position-x (+ i position-y) width (if (= selectSize 0) 1 2))
                          (gimp-drawable-invert inLayer FALSE)
                          (loop (+ i (if (= selectSize 0) 2 4)) max))))))
    (loop 1 (* height (if (> lengthenFirst 0) (* lengthenFirst 2) 1 )))
  )
  (gimp-selection-none inImage)
  (if (> lengthenSecond 0)  ; elongate at end
    (begin
      (gimp-image-scale inImage width (* (* height (if (> lengthenFirst 0) (* lengthenFirst 2) 1 )) (* lengthenSecond 2)))
    )
  )
  (gimp-image-undo-group-end inImage)
  (gimp-context-pop)
  (gimp-displays-flush)
))

(script-fu-register
    "script-fu-knit-color-separator" ;function name
    "2-Color Separator"   ;menu label
    "Splits black-and-white designs for two 
    color DBJ or slip/tuck knitting with 
    a punchcard or computerized machine" ;description
    "Cathy Wise"             ;author
    "copyright 2023, Cathy Wise" ;copyright notice
    "2023-08-09"             ;date created
    "GRAY"                   ;image type that the script works on
    SF-IMAGE      "Image"  0 ;input image
    SF-DRAWABLE   "Layer"  0 ;input layer
    SF-OPTION    _"1. Lengthen" '(_"None" _"2x" _"4x")
    SF-OPTION    _"2. Invert" '(_"Every other row, starting with the 2nd" _"Pairs of rows, starting with the 2nd")
    SF-OPTION    _"3. Lengthen"  '(_"None" _"2x" _"4x")
  )
(script-fu-menu-register "script-fu-knit-color-separator" "<Image>/Filters/Knitting/Color Separator")
