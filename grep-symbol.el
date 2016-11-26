;; Search for the current symbol

(defun grep-current-symbol (path)
  "Call `grep' to search for the current symbol from all files inside the project directory, which can be determined automatically by some remark files such as `Makefile'. The whole command can be fetched from `grep-history'"
  (interactive
   (list (read-directory-name "Enter grep directory: ")))
  (let ((sym (find-tag-default))
        (grep-cmd "grep -nrIH -e"))
    (if (null sym)
        (error "No symbol at point"))

    (message "Grep %s in directory %s" sym path)
    (setq sym (concat "\\<" (regexp-quote sym) "\\>"))
    (setq grep-cmd (concat grep-cmd " '" sym "' " path
                           " --exclude=*.svn-base"
                           " --exclude=*~"
                           " --exclude=*.tmp"
                           " --exclude=*.html"))
    (add-to-history 'grep-history grep-cmd)
    (grep grep-cmd)))

(provide 'grep-symbol)
