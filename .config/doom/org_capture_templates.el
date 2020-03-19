(setq org-capture-templates
      '(
        ("t" "Tasks")
        ("t" "Todo" entry (file "~/doc/org/refile.org")
         "* TODO %?\n%U" :empty-lines 1)
        ("T" "Todo with Clipboard" entry (file "~/doc/org/refile.org")
         "* TODO %?\n%U\n   %c" :empty-lines 1)
        ("n" "Note" entry (file "~/doc/org/refile.org")
         "* NOTE %?\n%U" :empty-lines 1)
        ("N" "Note with Clipboard" entry (file "~/doc/org/refile.org")
         "* NOTE %?\n%U\n   %c" :empty-lines 1)
        ("e" "Event" entry (file+headline "~/doc/org/events.org" "Transient")
         "* EVENT %?\n%U" :empty-lines 1)
        ("E" "Event With Clipboard" entry (file+headline "~/doc/org/events.org" "Transient")
         "* EVENT %?\n%U\n   %c" :empty-lines 1)
        )
      )

(provide 'org_capture_templates)
