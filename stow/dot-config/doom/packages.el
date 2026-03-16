;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; (package! obsidian)

(package! typst-ts-mode
  :recipe (:host codeberg :repo "meow_king/typst-ts-mode"))
(package! typst-preview
  :recipe (:host github :repo "havarddj/typst-preview.el"))

(package! ox-typst
  :recipe (:host github :repo "jmpunkt/ox-typst"))

;; roam-ui needs latest roam
(unpin! org-roam)
(package! org-roam-ui)

(package! md-roam
  :recipe (:host github :repo "nobiot/md-roam"))

(package! org-drill)
