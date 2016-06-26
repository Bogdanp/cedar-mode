;;; cedar-mode.el -- A major mode for editing Cedar files

;; Copyright (C) 2016  Bogdan Popa

;; Author: Bogdan Popa
;; Package-requires:
;; URL: https://github.com/Bogdanp/cedar-mode

;;; Commentary:
;;; Code:
(defconst cedar--keywords
  '("enum" "union" "record" "fn"))

(defconst cedar-font-lock-keywords
  (cons (regexp-opt cedar--keywords t) font-lock-keyword-face)
  "Highlighting for Cedar keywords.")

(defconst cedar-font-lock-types
  '("\\<\\([A-Z][a-zA-Z0-9_]*\\)\\>" . font-lock-type-face))

(defconst cedar-font-lock-attributes
  '("\\<\\([a-z][a-zA-Z0-9_]*\\)\\>" . font-lock-variable-name-face))

(defconst cedar-font-lock-functions
  '("fn \\([a-z][a-zA-Z0-9_]*\\)" 1 font-lock-function-name-face))

(defconst cedar-font-lock
  (list (list cedar-font-lock-keywords
              cedar-font-lock-types
              cedar-font-lock-functions
              cedar-font-lock-attributes)
        nil nil))

(defun cedar-indent-line ()
  "Indent the current line in a Cedar spec file."
  (interactive)
  (beginning-of-line)
  (if (bobp)
      (indent-line-to 0)

    (let ((not-indented t) cur-indent)
      (if (looking-at "^.*[)}]")
          (save-excursion
            (forward-line -1)
            (setq cur-indent (max 0 (- (current-indentation) 2))))

        (save-excursion
          (while not-indented
            (forward-line -1)
            (if (looking-at "^.*[)}]")
                (progn
                  (setq cur-indent (current-indentation))
                  (setq not-indented nil))

              (when (looking-at "^.*[({]")
                (setq cur-indent (+ (current-indentation) 2))
                (setq not-indented nil))

              (when (bobp)
                (setq not-indented nil))))))

      (if cur-indent
          (indent-line-to cur-indent)
        (indent-line-to 0)))))

(define-derived-mode cedar-mode prog-mode "Cedar"
  "Major mode for editing Cedar files."

  (set (make-local-variable 'font-lock-defaults) cedar-font-lock)
  (set (make-local-variable 'indent-line-function) #'cedar-indent-line)

  (define-key cedar-mode-map "\C-j" #'newline-and-indent))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.cedar\\'" . cedar-mode))

(provide 'cedar-mode)
;;; cedar-mode.el ends here
