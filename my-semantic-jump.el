(defvar my-semantic-jump-ring
  (make-ring 20)
  "ring buffer that used to store code jump information")

(defvar my-semantic-ring-index
  -1 "current index inside `my-semantic-jump-ring'")

(defvar my-semantic-jump-map
  (let ((keymap (make-sparse-keymap)))
    (define-key keymap (kbd "<f12>") 'my-semantic-jump-to)
    (define-key keymap (kbd "M-<left>") 'my-semantic-jump-prev)
    (define-key keymap (kbd "M-<right>") 'my-semantic-jump-next)
    keymap)
  "Keymap used by `my-semantic-jump-mode'")


(define-minor-mode my-semantic-jump-mode
  "Use <M-left>/<M-right> to jump backward/forward 
throughout the jump history"
  nil "" my-semantic-jump-map)


(defun my-make-ring-item ()
  (let* ((buffer (current-buffer))
         (filename (buffer-file-name buffer))
         (offset (point)))
    (cons filename offset)))
    

;; load semantic-ia for semantic-ia-fast-jump
(require 'semantic)
(defun my-semantic-jump-to ()
  (interactive)
  (let* ((item (my-make-ring-item)))
    (if (buffer-file-name (current-buffer)) 
        ;; if it's not an internal buffer
        (progn         
          ;; insert the info before jump
          (ring-insert my-semantic-jump-ring item)
          (semantic-ia-fast-jump (point))

          ;; insert the info after jump
          (setq item (my-make-ring-item))
          (ring-insert my-semantic-jump-ring item)

          ;; set cursor to the newest info
          (setq my-semantic-ring-index 0)))))

(defun my-semantic-jump-prev ()
  (interactive)
  (let* (item)
    (if (or (< my-semantic-ring-index 0)
            (>= (1+ my-semantic-ring-index)
               (ring-length my-semantic-jump-ring)))
        (error "No history jump info")
      (setq my-semantic-ring-index (1+ my-semantic-ring-index))
      (setq item (ring-ref my-semantic-jump-ring 
                           my-semantic-ring-index))
      (find-file (car item))
      (goto-char (cdr item))
      (pulse-momentary-highlight-one-line (point)))))

(defun my-semantic-jump-next ()
  (interactive)
  (let* (item)
    (if (<= my-semantic-ring-index 0)
        (error "No history jump info")
      (setq my-semantic-ring-index (1- my-semantic-ring-index))
      (setq item (ring-ref my-semantic-jump-ring 
                           my-semantic-ring-index))
      (find-file (car item))
      (goto-char (cdr item))
      (pulse-momentary-highlight-one-line (point)))))


(provide 'my-semantic-jump)
