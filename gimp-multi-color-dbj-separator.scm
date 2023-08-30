(define (script-fu-knit-multi-color-dbj-separator inImage inLayer)
(let* (
    ; (palette (cadr (gimp-image-get-colormap inImage)))
    ; (color-count (/ (car (gimp-image-get-colormap inImage)) 3))
    (palette (car (gimp-context-get-palette)))
    (color-count (car (gimp-palette-get-info palette)))
    (width (car (gimp-drawable-width inLayer)))
    (height (car (gimp-drawable-height inLayer)))
    (position-x (car (gimp-drawable-offsets inLayer)))
    (position-y (cadr (gimp-drawable-offsets inLayer)))
    (bg-color (car (gimp-palette-entry-get-color palette 0)))
    (fg-color (car (gimp-palette-entry-get-color palette 1)))
  )

  (gimp-context-push)
  (gimp-context-set-paint-mode LAYER-MODE-NORMAL)
  (gimp-context-set-opacity 100.0)
  (gimp-context-set-feather FALSE)
  (gimp-context-set-interpolation 0)
  (gimp-image-undo-group-start inImage)
  (gimp-context-set-brush-size 1.0)
  (gimp-context-set-brush "1. Pixel")
  
  ; make a copy of each row per color
  (gimp-image-scale inImage width (* height color-count))

  
  (letrec ((loop (lambda (i max)
    (if (< i max)
        (let* ((color-idx (modulo i color-count)))
            (letrec ((pixloop (lambda (j max-j) 
                (if (< j max-j) (
                  (let*  (
                    (pixel (car (gimp-image-pick-color inImage inLayer j i FALSE FALSE 0)))
                    (row-color (car (gimp-palette-entry-get-color palette color-idx)))
                    (dot (cons-array 2 'double))
                  )
                    (aset dot 0 j)
                    (aset dot 1 i)
                    (if (equal? pixel row-color)
                      (gimp-context-set-foreground fg-color)
                      (gimp-context-set-foreground bg-color)
                    )
                    (gimp-pencil inLayer 2 dot) ; screaming into the void
                  )
                )
              (pixloop (+ j 1) max-j))

            ))) (pixloop 0 width)
            )
          (loop (+ i 1) max)))))
        ) 
    (loop 0 height)
  )

  ; double length again
  (gimp-image-scale inImage width (* 2 (* height color-count)))

  ; erase every other row
  (letrec ((loop (lambda (i max)
                    (if (< i max)
                        (begin
                          (gimp-image-select-rectangle inImage CHANNEL-OP-REPLACE position-x (+ i position-y) width 1)
                          (gimp-edit-fill inLayer FILL-BACKGROUND)
                          (loop (+ i 2) max))))))
    (loop 1 (* height (* 2 color-count)))
  )
  (gimp-selection-none inImage)
  (gimp-image-undo-group-end inImage)
  (gimp-context-pop)
  (gimp-displays-flush)
))

(script-fu-register
    "script-fu-knit-multi-color-dbj-separator" ;function name
    "DBJ Color Separator"   ;menu label
    "Splits indexed colored designs for 
    DBJ knitting with a punchcard or 
    computerized machine"    ;description
    "Cathy Wise"             ;author
    "copyright 2023, Cathy Wise" ;copyright notice
    "2023-08-12"             ;date created
    "INDEXED*"               ;image type that the script works on
    SF-IMAGE      "Image"  0 ;input image
    SF-DRAWABLE   "Layer"  0 ;input layer
  )
(script-fu-menu-register "script-fu-knit-multi-color-dbj-separator" "<Image>/Filters/Knitting/Color Separator")
