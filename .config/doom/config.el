;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; These are used for a number of things, particularly for GPG configuration,
;; some email clients, file templates and snippets.
(setq user-full-name "Kelvin Porter"
      user-mail-address "kporter@protonmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-ephemeral)

(after! ivy-posframe
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-top-center))))

;; Org and Notes
(use-package! org-roam
    :after org
    :hook (org-mode . org-roam-mode)
    :commands (org-roam-insert org-roam-find-file org-roam)
    :custom
    (org-roam-directory "~/doc/org/roam/")
    (org-roam-capture-templates '(("d" "default" plain (function org-roam--capture-get-point)
                                   "%?"
                                   :file-name "%<%Y%m%d%H%M%S>-${slug}"
                                   :head "#+TITLE: ${title}\n"
                                   :unnarrowed t)))
    :config
    (org-roam-mode +1))

(use-package! org-roam-protocol)

(use-package! org-super-agenda
  :config
  (setq org-agenda-start-day "0d"
        org-agenda-span 1
        org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-include-diary t
        org-agenda-block-separator nil
        org-agenda-overriding-header ""
        org-agenda-compact-blocks t)
  (org-super-agenda-mode)
  (setq org-super-agenda-groups
        '((:name "Next to do"
                 :todo "NEXT"
                 :order 1)
          (:name "Important"
                 :tag "Important"
                 :order 6)
          (:name "Due Today"
                 :deadline today
                 :order 2)
          (:name "Due Soon"
                 :deadline future
                 :order 8)
          (:name "Overdue"
                 :deadline past
                 :order 7)
          (:name "Scheduled"
                 :category "Events"
                 :order 9)
          (:name "School"
                 :tag "School"
                 :order 10)
          (:name "Issues"
                 :tag "Issue"
                 :order 12)
          (:name "Projects"
                 :tag "Project"
                 :order 14)
          (:name "Dotfiles"
                 :tag "Dotfiles"
                 :order 13)
          (:name "Waiting"
                 :todo "WAITING"
                 :order 20)
          (:name "Trivial"
                 :priority<= "C"
                 :tag ("Trivial" "Unimportant")
                 :order 90)
          (:discard (:tag ("Chore" "Routine" "Daily"))))))

(use-package! org-agenda-property
  :config
  (setq org-agenda-property-list '("LOCATION" "TEACHER")
        org-agenda-property-position 'where-it-fits
        org-agenda-property-separator "|"))

(setq org-directory "~/doc/org/"
      org-id-track-globally t
      org-id-locations-file "~/doc/org/.orgids"
      org-agenda-files (list org-directory)
      org-agenda-time-grid '((daily today require-timed) nil nil "---------------")
      org-agenda-skip-scheduled-if-done t
      org-agenda-skip-deadline-if-done t
      org-agenda-include-deadlines t
      org-agenda-block-separator nil
      org-agenda-compact-blocks t
      org-agenda-start-with-log-mode t
      org-agenda-log-mode-items '(closed clock state)
      org-agenda-prefix-format "%i %-12t %-3e "
      org-agenda-use-time-grid nil
      org-columns-default-format-for-agenda "%25ITEM %TODO %3PRIORITY %TAGS %LOCATION"
      org-todo-keywords '((sequence "TODO(t)" "HOLD(h)" "WIP(w)" "PROJECT(p)" "|" "DONE(d)"))
      org-tag-alist '((:startgroup nil)
                      ("Trivial" . ?t) ("Unimportant" . ?u) ("Important" . ?i)
                      (:endgroup nil)
                      (:startgroup nil)
                      ("School" . ?s)
                      ("Issue" . ?i)
                      ("Project" . ?p)
                      ("Dotfiles" . ?d)
                      (:endgroup nil))
      org-capture-templates
      '(
        ("t" "Tasks")
        ("tt" "Todo" entry (file+headline "~/doc/org/todo.org" "Tasks")
         "* TODO %^{Tags}g %?\nSCHEDULED: %(org-insert-time-stamp (org-read-date nil t \"today\"))\n %^{Effort}p \n")
        ("ts" "School Todo" entry (file+headline "~/doc/org/todo.org" "Tasks")
         "* TODO %? :School:")
        ("tp" "Project Todo" entry (file+headline "~/doc/org/todo.org" "Projects")
         "* TODO %? :Project:\n %^{Effort}p \n")
        ("e" "Events")
        ("ee" "Event" entry (file+headline "~/doc/org/schedule.org" "Events")
         "* %?")
        ("ec" "Club Event" entry (file+headline "~/doc/org/schedule.org" "Clubs")
         "* %?")))

(after! org-gcal
  (add-to-list 'load-path "~/.config/doom")
  (require 'config_private))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

(map! :leader
      (:prefix ("f" . "file")
        :desc "Fzf find file" "f" (lambda()
                                    (interactive)
                                    (counsel-fzf "" "/home/yack" "" ))
        :desc "Find file at point" "o" #'find-file-at-point)
      (:prefix-map ("n" . "notes")
        (:prefix ("r" . "roam")
          :desc "Capture" "x" (lambda()
                                 (interactive)
                                 (org-roam-capture)))))



;; Disable some lsp stuff
;; (add-hook 'lsp-ui-mode-hook #'(mapcar (lambda (f) (set-face-foreground f "dim gray"))
;;       '(lsp-ui-sideline-code-action lsp-ui-sideline-current-symbol lsp-ui-sideline-symbol lsp-ui-sideline-symbol-info)))

;; Evil settings and conda mode
(setq evil-snipe-scope 'buffer
      evil-snipe-repeat-scope 'whole-buffer
      conda-env-home-directory "/home/yack/.conda/"
      display-line-numbers-type 'relative)

(add-hook 'web-mode-hook
          (lambda ()
            ;; short circuit js mode and just do everything in jsx-mode
            (if (equal web-mode-content-type "javascript")
                (web-mode-set-content-type "jsx")
              (message "now set to: %s" web-mode-content-type))))
