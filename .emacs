(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(compilation-scroll-output (quote first-error))
 '(ecb-layout-name "left15")
 '(ecb-options-version "2.40")
 '(enable-local-variables nil)
 '(global-auto-revert-mode t)
 '(global-linum-mode t)
 '(ido-mode (quote both) nil (ido))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(show-paren-mode t)
 '(split-height-threshold 80)
 '(split-width-threshold 100)
 '(tab-width 4)
 '(user-full-name "bear")
 '(user-mail-address "jrjbear@gmail.com")
 '(which-function-mode t)
 '(xterm-mouse-mode t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(linum ((t (:inherit default :foreground "white")))))

;; bind .h/.c file to c++-mode
(setq auto-mode-alist
      (append '(("\\.h$" . c++-mode)) '(("\\.c$" . c++-mode)) auto-mode-alist))

(require 'mwheel)
(mouse-wheel-mode t)

;; add melpa into package repository
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; apply color-theme
(require 'color-theme)
(color-theme-initialize)
(run-with-timer 2 nil 'color-theme-calm-forest)

;; Turn on semantic globally first
(semantic-mode t)
;; This restricts semantic parsing only in some modes
;; (add-to-list 'semantic-inhibit-functions
;; 	     (lambda () (not (member major-mode
;;                                  '(c-mode c++-mode)))))
(setq semantic-default-submodes '(global-semanticdb-minor-mode
                                  global-semantic-idle-scheduler-mode
                                  global-semantic-idle-summary-mode
                                  global-semantic-show-parser-state-mode))

;; add include directorys to cedet
(defconst cedet-user-include-dirs
  (list
   "."
   "./include"))

(require 'semantic-c nil 'noerror)

(let ((include-dirs cedet-user-include-dirs))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))

;; `end' key seems to be remapped to `select' inside screen
(global-set-key (kbd "<select>") 'move-end-of-line)

;; more consistent with key binding of `next-error': C-x `
(global-set-key (kbd "C-x ~") 'previous-error)

(defun my-comment-code ()
  (interactive)
  (if (use-region-p)
      (comment-region (region-beginning) (region-end) 2)
    (comment-region (point-at-bol) (point-at-eol)) 2))
(global-set-key (kbd "C-c c") 'my-comment-code)

(defun my-uncomment-code ()
  (interactive)
  (if (use-region-p)
      (comment-region (region-beginning) (region-end) -2)
    (comment-region (point-at-bol) (point-at-eol) -2)))
(global-set-key (kbd "C-c u") 'my-uncomment-code)

(defun my-kill-line ()
  (interactive)
  (beginning-of-line)
  (kill-line 1))
(global-set-key (kbd "C-c w") 'my-kill-line)

(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward)

;; yasnippet
(require 'yasnippet)
(setq yas-snippet-dirs "~/.emacs.d/snippets")
(yas/global-mode 1)

;; auto-complete
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20150618.1949/dict")
(ac-config-default)
;; use TAB to show completion menu explicitly
(ac-set-trigger-key "TAB")
(setq ac-auto-start nil)
;; add semantic to ac-sources
(defun ac-cc-mode-setup ()
  (setq ac-sources (append '(ac-source-semantic 
                             ;; ac-source-semantic-raw
                             ac-source-yasnippet) ac-sources)))

;; add ansi-color to compilation mode
(require 'ansi-color)
(add-hook 'compilation-filter-hook 
          '(lambda ()  
             (toggle-read-only)
             (ansi-color-apply-on-region (point-min) (point-max))
             (toggle-read-only)))

;; load elisp extensions
(add-to-list 'load-path "~/.emacs.d/plugins/")

;; load my-semantic-jump
(require 'my-semantic-jump)
(semantic-toggle-minor-mode-globally 'my-semantic-jump-mode 1)

;; load calc-mode
(require 'calc-mode)

;; load linum+
(require 'linum+)
(setq linum-format ["%%%dd "])

;; load google-c-styel
(require 'google-c-style)
(defun my-google-set-c-style ()
  (google-set-c-style)
  (c-add-style "My-Google"
               '("Google" (c-basic-offset . 4)) t))
(add-hook 'c++-mode-hook 'my-google-set-c-style)
(add-hook 'c++-mode-hook 'google-make-newline-indent)

(require 'protobuf-mode)
(add-hook 'protobuf-mode-hook 'my-google-set-c-style)

;; load highlight-symbol
(require 'highlight-symbol)
;; exchange default key bindings of isearch-forward and isearch-forward-regexp
;; this is intented to cooperate with isearch-current-symbol which uses
;; isearch-forward-regexp inside
(define-key global-map "\C-s" 'isearch-forward-regexp)
(define-key esc-map "\C-s" 'isearch-forward)
(define-key global-map "\C-r" 'isearch-backward-regexp)
(define-key esc-map "\C-r" 'isearch-backward)
;; when entering iseach-minor-mode, type C-c to highlight the symbol
;; under the current point
(define-key isearch-mode-map "\C-c" 'isearch-current-symbol)

;; bind F11 to automatically compile current project
(require 'smart-compile)
(global-set-key (kbd "<f11>") 'compile-use-parent-makefile)

;; bind F10 to grep the current symbol
(require 'grep-symbol)
(global-set-key (kbd "<f10>") 'grep-current-symbol)

;; activate ECB
(ecb-activate)
(setq ecb-source-path '("~/"))
(ecb-hide-ecb-windows)
(global-set-key (kbd "<f9>") 'ecb-toggle-ecb-windows)
