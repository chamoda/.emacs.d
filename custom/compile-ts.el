(defun treesitter-install-all-language-grammar ()
    (interactive)
    (mapc #'treesit-install-language-grammar (mapcar #'car treesit-language-source-alist))
)

