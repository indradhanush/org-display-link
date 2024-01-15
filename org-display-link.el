;;; org-display-link.el --- Display org links in the minibuffer -*- lexical-binding: t; -*-

;; Copyright (C) 2023 Free Software Foundation, Inc.

;; Author: Indradhanush Gupta
;; URL: https://github.com/indradhanush/org-display-link
;; Version: 0.0.1
;; Package-Requires: ((emacs "29.1") (org "9.6.1"))
;; Keywords: convenience hypermedia extensions outlines

;; This file is not part of GNU Emacs.

;; GNU Emacs is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; GNU Emacs is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; This extension displays the value of an org-link item at the current cursor's
;; position in the minibuffer, akin to browsers displaying the URL when hovering
;; over a hyperlink.

(require 'org)

(defvar org-display-link-timer-interval 0.5)

(defvar org-display-link-enable nil)

(defun org-display-link-at-point ()
  "Get the link at point in an org-mode file."
  (interactive)
  (org-display-link-at--point))

(defun org-display-link-at--point ()
  "Get the link at point in an org-mode file."
  ;; (message "yo"))

  (when org-display-link-enable
    (when (eq major-mode 'org-mode)
      (let ((element (org-element-context)))
        (if (eq (org-element-type element) 'link)
            (let ((link-info (org-element-property :raw-link element)))
              (message "%s" link-info)))))))


(defvar org-display-link-at-point-timer nil
  "Timer for org-display-link-at-point-on-idle to reschedule itself, or nil.")

(defun org-display-link-at-point-on-idle ()
  "Run asynchronously to get the link at point in an org-mode file on idle."
  ;; If the user types a command while get-link-timer is active, the next time
  ;; this function is called from its main idle timer, deactivate
  ;; get-link-timer.
  (when org-display-link-at-point-timer
    (cancel-timer org-display-link-at-point-timer))
  (setq org-display-link-at-point-timer
        (run-with-idle-timer org-display-link-timer-interval t
                             'org-display-link-at--point)))

(provide 'org-display-link)

;;; org-display-link.el ends here
