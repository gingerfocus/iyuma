;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; You do not need to run 'doom sync' after modifying this file!

;; Transparent background
(set-frame-parameter nil 'alpha-background 85)

;; Remove the top bar
(setq default-frame-alist '((undecorated . t)))
(scroll-bar-mode -1)

;; User info for some programs
(setq user-full-name "Evan Stokdyk"
      user-mail-address "evan.stokdyk@gmail.com")

;; See 'C-h v doom-font' for documentation.
(setq doom-font (font-spec :family "Hack Nerd Font" :size 15 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Mononoki Nerd Font" :size 14))

(setq doom-theme 'doom-city-lights)

;; set dashboard image
(setq fancy-splash-image "~/.config/doom/banner.png")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; (map! "SPC f f" #'project-find-file)

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; Bind "escape" in normal mode to save (for evil-mode users)
(define-key evil-normal-state-map
            (kbd "<escape>")
            (lambda () (interactive)
              (save-some-buffers t)
              (evil-ex-nohighlight)
              ))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  ;; :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(setq org-directory "~/dox")
(setq org-roam-directory (file-truename "~/dox"))


(setq org-roam-mode-sections
      (list #'org-roam-backlinks-section
            ;; #'org-roam-reflinks-section
            #'org-roam-unlinked-references-section))

;; Set all files as agenda files
(setq org-agenda-files 
      '("~/dox/" "~/dox/01 - Projects/"))

;;;; Org-roam
;; (define-key global-map (kbd "C-c n f") #'org-roam-node-find)
;; (define-key global-map (kbd "C-c n c") #'org-roam-capture)
;; (define-key global-map (kbd "C-c n i") #'org-roam-node-insert)
;; (define-key global-map (kbd "C-c n l") #'org-roam-buffer-toggle)

(setq emms-browser-tree-node-map
      '((info-albumartist . info-title)
        (info-artist      . info-title)
        (info-composer    . info-title)
        (info-performer   . info-title)
        (info-album       . info-title)
        (info-genre       . info-title)
        (info-year        . info-title)))

;; Org-roam
;; (define-key global-map (kbd "C-c n f") #'org-roam-node-find)
;; (define-key global-map (kbd "C-c n c") #'org-roam-capture)
;; (define-key global-map (kbd "C-c n i") #'org-roam-node-insert)
;; (define-key global-map (kbd "C-c n l") #'org-roam-buffer-toggle)

(setq org-cite-global-bibliography
      '(
        "~/dox/07 - Assets/Citations/popular.bib"  ; youtube, blogs
        "~/dox/07 - Assets/Citations/industry.bib" ; private labs
        "~/dox/07 - Assets/Citations/academic.bib" ; public labs
        ;; "~/dox/07 - Assets/Citations/asmr.bib"     ; amsr youtube
        ))

;; (plist-put org-format-latex-options :scale 0.75)

;; https://pastebin.com/raw/5k4R7NPr
(defun org-typst-preview ()
  (interactive)
  (let (checkdir-flag)
    (org-element-map
	(org-element-parse-buffer)
	'(src-block)
      (lambda (bl)
	(when (string= (org-element-property :language bl) "typst")
	  (let* ((start (org-element-property :begin bl))
		 (value (org-element-property :value bl))
		 (end (+ start
			 (length
			  (string-to-list
			   (concat "#+begin_src typst" value "#+end_src\n")))))
		 (fg (plist-get org-format-latex-options :foreground))
		 (hash (sha1 (prin1-to-string (list value fg))))
		 (imagetype "svg")
		 (prefix (concat "typstimg/" "org-typst"))
		 (absprefix (expand-file-name prefix))
		 (linkfile (format "%s_%s.%s" prefix hash imagetype))
		 (movefile (format "%s_%s.%s" absprefix hash imagetype))
		 (sep "\n\n")
		 (link (concat sep "[[file:" linkfile "]]" sep)))
	    (unless checkdir-flag ; Ensure the directory exists.
	      (setq checkdir-flag t)
	      (let ((todir (file-name-directory absprefix)))
		(unless (file-directory-p todir)
		  (make-directory todir t))))
	    (unless (file-exists-p movefile)
	      (with-temp-buffer
		(insert "#set text(size: 30pt, fill: rgb(\"#ebdbb2\"))\n#set page(width: auto, height: auto, margin: 10pt)\n")
		(insert value)
		(let* ((temp-file (make-temp-file ""))
		       (command (format
				 "typst compile %s %s" temp-file movefile)))
		  (write-file temp-file)
		  (shell-command command))))
	    (progn
	      (dolist (o (overlays-in start end))
		(when (eq (overlay-get o 'org-overlay-type)
			  'org-latex-overlay)
		  (delete-overlay o)))
	      (org--make-preview-overlay start end movefile imagetype)
	      (goto-char end))))))))

