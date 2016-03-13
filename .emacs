(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(compilation-scroll-output (quote first-error))
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

;; bind .h file to c++-mode
(setq auto-mode-alist
      (append '(("\\.h$" . c++-mode)) auto-mode-alist))

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
(run-with-timer 2 nil 'color-theme-taming-mr-arneson)

;; load cedet
(load-file "~/Tools/cedet/cedet-devel-load.el")

;; enable EDE
;; (global-ede-mode t)

;; enable srecode
;; (global-srecode-minor-mode 1)

;; semantic-idle-scheduler-mode
;; semanticdb-minor-mode
;; semanticdb-load-ebrowse-caches
(semantic-load-enable-minimum-features)

;; semantic-idle-summary-mode
;; senator-minor-mode
;; semantic-mru-bookmark-mode
(semantic-load-enable-code-helpers)

;; semantic-stickyfunc-mode
;; semantic-decoration-mode
;; semantic-idle-completions-mode
;; (semantic-load-enable-guady-code-helpers)

;; semantic-highlight-func-mode
;; semantic-idle-local-symbol-highlight-mode
;; semantic-decoration-on-*-members
;; which-func-mode
;; (semantic-load-enable-excessive-code-helpers)
(global-semantic-idle-local-symbol-highlight-mode 1)

;; semantic-highlight-edits-mode
;; semantic-show-unmatched-syntax-mode
;; semantic-show-parser-state-mode
;; (semantic-load-enable-semantic-debugging-helpers)
;; (global-semantic-highlight-edits-mode 1)
(global-semantic-show-parser-state-mode 1)

;; add imenu to menubar
(defun imenu-semantic-hook ()
  (imenu-add-to-menubar "TAGS"))
(add-hook 'semantic-init-hooks 'imenu-semantic-hook)

;;(require 'semantic-gcc)

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

;; add gcc symbol file to semantic preprocessor and then reset the symbol map
;;(add-to-list 'semantic-lex-c-preprocessor-symbol-file "/usr/include/sys/cdefs.h")
;;(semantic-c-reset-preprocessor-symbol-map)

;; `end' key seems to be remapped to `select' inside screen
(global-set-key (kbd "<select>") 'move-end-of-line)

;; more consistent with key binding of `next-error': C-x `
(global-set-key (kbd "C-x ~") 'previous-error)

;; bind M-n to semantic-ia-complete-symbol
;; (define-key senator-mode-map (kbd "M-n") 'semantic-ia-complete-symbol)

;; bind C-c , k to senator-kill-tag
;;(define-key senator-mode-map (kbd "C-c , k") 'senator-kill-tag)

;; bind C-c , w to senator-copy-tag
;;(define-key senator-mode-map (kbd "C-c , w") 'senator-copy-tag)

;; bind C-c , y to senator-yank-tag
;;(define-key senator-mode-map (kbd "C-c , y") 'senator-yank-tag)

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
  (setq ac-sources (append '(;; ac-source-semantic 
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

;; load php-mode
(require 'php-mode)

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
;; (setq c-default-style (cons '(protobuf-mode . "Google") c-default-style))

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
(global-set-key (kbd "<C-f10>") 'grep-current-symbol-recursive)
