;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; You do not need to run 'doom sync' after modifying this file!

;; Transparent background
(set-frame-parameter nil 'alpha-background 85)

;; Remove the top bar
(setq default-frame-alist '((undecorated . t)))

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
;; (define-key evil-normal-state-map (kbd "<escape>") (lambda () (interactive) (save-some-buffers t)))

;;   (after! PACKAGE
;;     (setq x y))

;; (require 'typst-preview)
;; (setq typst-preview-browser "qutebrowser")

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam ;; or :after org
  ;;         normally we'd recommend hooking orui after org-roam, but since org-roam does not have
  ;;         a hookable mode anymore, you're advised to pick something yourself
  ;;         if you don't care about startup time, use
  ;;  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-update-on-save t
        org-roam-ui-open-on-start t))

(use-package! md-roam
  :after org-roam
  :config
  (md-roam-mode 1) ; md-roam-mode must be active before org-roam-db-sync
  (setq md-roam-file-extension "md") ; default "md". Specify an extension such as "markdown"
  (org-roam-db-autosync-mode 1) ; autosync-mode triggers db-sync. md-roam-mode must be already active
  )

(setq org-directory "~/dox")

;; enable Org-roam for a markdown extension
(setq org-roam-file-extensions '("org" "md"))
(setq org-roam-directory (file-truename "~/dox"))

(setq org-roam-mode-sections
      (list #'org-roam-backlinks-section
            ;; #'org-roam-reflinks-section
            #'org-roam-unlinked-references-section
            ))

;;;; Org-roam
;; (define-key global-map (kbd "C-c n f") #'org-roam-node-find)
;; (define-key global-map (kbd "C-c n c") #'org-roam-capture)
;; (define-key global-map (kbd "C-c n i") #'org-roam-node-insert)
;; (define-key global-map (kbd "C-c n l") #'org-roam-buffer-toggle)
