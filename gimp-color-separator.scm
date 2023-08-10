(define (script-fu-knit-color-separator inImage inLayer)
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
  (gimp-image-undo-group-start inImage)
  (letrec ((loop (lambda (i max)
                    (if (< i max)
                        (begin
                          (gimp-image-select-rectangle inImage CHANNEL-OP-REPLACE position-x (+ i position-y) width 1)
                          (gimp-drawable-invert inLayer FALSE)
                          (loop (+ i 2) max))))))
    (loop 1 height)
  )
  (gimp-selection-none inImage)
  (gimp-image-undo-group-end inImage)
  (gimp-context-pop)
  (gimp-displays-flush)
))

(script-fu-register
    "script-fu-knit-color-separator"                        ;function name
    "Knit Color Separator"                                  ;menu label
    "Splits black-and-white designs for two 
    color slip/tuck knitting with a punchcard machine"              ;description
    "Cathy Wise"                             ;author
    "copyright 2023, Cathy Wise"        ;copyright notice
    "2023-08-09"                          ;date created
    "GRAY"                                      ;image type that the script works on
    SF-IMAGE      "Image"          0   ;input image
    SF-DRAWABLE "Layer" 0 ;input layer
  )
(script-fu-menu-register "script-fu-knit-color-separator" "<Image>/Filters/Knitting/Color Separator")
