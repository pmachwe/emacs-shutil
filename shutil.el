

;;; shutil.el --- Shell Utilities -*- lexical-binding: t -*-

;; Copyright (C) 2016 PARIKSHIT MACHWE

;; Author: PARIKSHIT MACHWE <pmachwe@gmail.com>
;; Created: 24 Oct 2016
;; Version: 0.0.1
;; Keywords: shell, emacs
;; X-URL: https://github.com/pmachwe/shutil

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 2, or (at
;; your option) any later version.

;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; This package contains a collection of utilities for working with shells
;; in Emacs.  The list is as follows:
;;   1. Split and open a new shell either horizontally or vertically.
;;   2. Open the new shell in the current working directory from where the
;;      split is made.
;;   3. Given a server name as input, open a new shell and rsh to the server.
;;      This could be taken as the prefix argument to the other commands.
;;      Also rename the shell according to server name.
;;   4. Switch between shell buffers quickly (only show shell buffers in switch).
;;      Use helm/counsel to show the open shell buffers.
;;   5. Use perspective-mode or bookmarks to save shell window configurations
;;      and easy switch amongst them.
;;   6. Open special command in ansi-term when possible like what eshell does.
;;      Special commands include: vim, less, watch etc.
;;   7. Use a global counter to number the shells as it will be overall good.
;;   8. Provide an API to get new shell using shutil (so that counter is set).

;;; Code:

(require 'comint)

(defgroup shutil nil
  "Shell Utilities"
  :group 'shutil)

(defvar shutil-shell-cnt 1
  "Global counter to number each shell.")

;; TODO - Make it to work with C-u bindings.
(defun shutil-get-new-shell (name)
  "Get a new shell with NAME."
  (interactive "sEnter shell name: ")
  (let (sh-name)
    (if (or (equal name nil)
            (string-empty-p name))
        (setq name "shell"))
    (setq sh-name (concat (int-to-string shutil-shell-cnt) "--" name))
    (setq sh-name (concat "*" sh-name "*"))
    (shell sh-name)
    (setq shutil-shell-cnt (1+ shutil-shell-cnt))
    sh-name))

;; Could use a filter function as well
(defun shutil-get-shell-list ()
  "Get list of active buffers."
  (interactive)
  (let (buf buf-mode shell-bufs)
    (dolist (buf (buffer-list))
      (setq buf-mode (buffer-local-value 'major-mode buf))
      (if  (string= "shell-mode" (prin1-to-string buf-mode))
          (setq shell-bufs (cons (buffer-name buf) shell-bufs))))
    shell-bufs))

(defun shutil-switch-to-buffer ()
  "Use counsel to switch to a shell buffer."
  (interactive)
  (let (sh-buf)
    (if (require 'ivy nil 'noerror)
        (setq sh-buf (ivy-read "Switch to shell: " (shutil-get-shell-list)))
      (if (require 'helm nil 'noerror)
          (setq sh-buf (helm-comp-read "Switch to shell: " (shutil-get-shell-list)))
        (setq sh-buf (completing-read "Switch to shell: " (shutil-get-shell-list)))))
    (switch-to-buffer (get-buffer sh-buf))))

(defun shutil-shell-on-server (server)
  "Start a new shell on the given SERVER."
  (interactive "sServer: ")
  (let (sh-name curr-buf-dir)
    (setq curr-buf-dir default-directory)
    (setq sh-name (shutil-get-new-shell server))
    (with-current-buffer (get-buffer sh-name)
      (insert "cd\n")
      (comint-send-input)
      (insert (concat "ssh -X " server "\n"))
      (comint-send-input)
      (insert (concat "cd " curr-buf-dir))
      (comint-send-input))))

(defun shutil-split-vertically ()
  "Split window and open a shell."
  (interactive)
  (split-window-vertically)
  (other-window 1)
  (shutil-get-new-shell ""))

(defun shutil-command-on-term (cmd)
  "Fire some command CMD on term."
  (interactive "sEnter command: ")
  (term "/bin/bash")
  (insert cmd)
  (term-send-input))

(provide 'shutil)

;;; shutil.el ends here
