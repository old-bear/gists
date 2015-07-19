;; Automatically construct the right compilation command

(defun compile-use-parent-makefile ()
  "Find Makefile starting from current directory. If not found, it goes
up one directory until reaches ~/ or a Makefile has been found"
  (interactive)
  (let ((makepath "./"))
    (while (and (not (file-equal-p makepath "~/"))
                (not (file-exists-p (concat makepath "Makefile"))))
      (setq makepath (concat "../" makepath)))
    (if (file-exists-p (concat makepath "Makefile"))
        (compile (concat "cd " makepath " && make -sj10"))
      (message "Can't find Makefile")
      (call-interactively 'compile))))

(provide 'smart-compile)
