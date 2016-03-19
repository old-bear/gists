;; Search for the current symbol

(defun grep-current-symbol (&optional recursive)
  "Call `grep' to search for the current symbol from all files inside the project directory, which can be determined automatically by some remark files such as `Makefile'. The whole command can be fetched from `grep-history'"
  (interactive "P")
  (let ((sym (find-tag-default)) (path "./") 
        (grep-cmd "grep -nIH -e"))
    (if (null sym)
        (error "No symbol at point"))
    ;; Find the root path of the project, which will be the directory to start grep
    (while (and (not (file-equal-p path "~/"))
                (not (file-exists-p (concat path "Makefile")))
                (not (file-exists-p (concat path "COMAKE")))
                (not (file-exists-p (concat path "README")))
                (not (file-exists-p (concat path "OWNER")))
                (not (file-exists-p (concat path "build.sh")))
                (not (file-exists-p (concat path "local_build.sh"))))
      (setq path (concat "../" path)))
    (if (file-equal-p path "~/")
        (setq path "./"))

    (message "Grep %s recursively in directory %s" sym path)
    (setq sym (concat "\\<" (regexp-quote sym) "\\>"))
    (setq grep-cmd (concat grep-cmd " '" sym 
                           (if recursive (concat "' -r " path) "' *")
                           " --exclude=*.svn-base"
                           " --exclude=Makefile*"
                           " --exclude=*~"
                           " --exclude=*.tmp"
                           " --exclude=*.html"
                           " --exclude_dir=output"))
    (add-to-history 'grep-history grep-cmd)
    (grep grep-cmd)))

(defun grep-current-symbol-recursive ()
  (interactive)
  (grep-current-symbol t))

(provide 'grep-symbol)
