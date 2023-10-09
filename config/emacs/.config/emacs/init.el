(setq inhibit-startup-screen t)

(if (display-graphic-p)
  (progn
    (scroll-bar-mode -1) ; Disable scroll bar
    (tool-bar-mode -1) ; Disable tool bar
    (tooltip-mode -1) ; Disable tooltips
    (menu-bar-mode t))) ; Disable menu bar

(set-fringe-mode 10) ; Give some breathing room

(setq visible-bell t)

(set-face-attribute 'default nil :font "Hack" :height 120)

(column-number-mode)
(setq fill-column 80)

;;(load-theme 'tango-dark t)
(let ((backup-dir (concat (getenv "XDG_DATA_HOME") "/emacs/backups"))
      (auto-saves-dir (concat (getenv "XDG_DATA_HOME") "/emacs/auto-saves")))
  (dolist (dir (list backup-dir auto-saves-dir))
    (when (not (file-directory-p dir))
      (make-directory dir t)))
  (setq backup-by-copying t      ; don't clobber symlinks
	backup-directory-alist `((".*" . ,backup-dir))    ; don't litter my fs tree)
	auto-save-file-name-transforms `((".*" ,auto-saves-dir t)) ; this does not fucking work for whatever reason
  tramp-backup-directory-alist `((".*" . ,backup-dir))
	delete-old-versions t
	kept-new-versions 6
	kept-old-versions 2
	version-control t))       ; use versioned backups

;; Init package sources
(require 'package)

(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Unit use-package on non-Linux systems
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; Bootstrap Quelpa
(unless (package-installed-p 'quelpa)
  (with-temp-buffer
    (url-insert-file-contents "https://raw.githubusercontent.com/quelpa/quelpa/master/quelpa.el")
    (eval-buffer)
    (quelpa-self-upgrade)))
(quelpa
 '(quelpa-use-package
   :fetcher git
   :url "https://github.com/quelpa/quelpa-use-package.git"))
(require 'quelpa-use-package)
;;

(use-package evil
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  ;; :custom
  ;; (evil-collection-want-company-extended-keybindings t)
  :config
  ;; (add-to-list 'evil-collection-mode-list 'company)
  (evil-collection-init))

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))

(use-package evil-nerd-commenter :after evil)

(use-package undo-fu
  :config
  (evil-set-undo-system 'undo-fu))

(use-package undo-fu-session
  :config
  (setq undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  (global-undo-fu-session-mode))

;; all-the-icons

(use-package doom-themes
  :config
  (load-theme 'doom-one t)
  ;; Enable flashing mode-line on errors
  ;;(doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;;(setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  ;;(doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  ;;(doom-themes-org-config)
  )

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (set-face-attribute 'mode-line nil :height 100)
  (set-face-attribute 'mode-line-inactive nil :height 100))


(use-package ivy
  :diminish
  :bind (("C-x b" . ivy-switch-buffer)
	 :map ivy-minibuffer-map
	 ("M-j" . ivy-next-line)
	 ("M-k" . ivy-previous-line))
  :config
  (ivy-mode 1))

(use-package smex)

(use-package counsel
  :config
  (counsel-mode 1))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package which-key
  :config
  (which-key-mode 1))

(use-package command-log-mode)

;; (use-package pdf-tools
;;   :pin manual ;; don't reinstall when package updates
;;   :mode  ("\\.pdf\\'" . pdf-view-mode)
;;   :magic ("%PDF" . pdf-view-mode)
;;   :hook (pdf-view-mode . pdf-view-midnight-minor-mode)
;;   :bind (:map pdf-view-mode-map
;; 	 ("zm" . pdf-view-midnight-minor-mode))
;;   :config
;;   (setq-default pdf-view-display-size 'fit-page)
;;   (setq pdf-annot-activate-created-annotations t)
;;   (pdf-tools-install :no-query))

(use-package yasnippet
  :config
  (yas-global-mode 1))

;; (use-package doom-snippets
;;   :load-path "~/.emacs.d/.local/straight/build-29.0.50/doom-snippets"
;;   :after yasnippet)

(use-package company
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :config
  (setq company-idle-delay 0.3)
  (global-company-mode t))

;; (use-package emacs-lookup)
;
;(set-frame-parameter (selected-frame) 'alpha '(92 . 90))
;(add-to-list 'default-frame-alist '(alpha . (92 . 90)))

;(setq display-line-numbers-type t)

;; recentf
(recentf-mode 1)
(setq recentf-max-menu-items 150)
(setq recentf-max-saved-items 150)

;; ;; Org Mode
(use-package org
  :custom (org-hide-leading-stars t)
  :config (require 'org-tempo))
(require 'ox)

(use-package org-appear
  :hook (org-mode . org-appear-mode)
  :config
  (setq org-appear-autoemphasis t
	org-appear-autosubmarkers t
	org-appear-autolinks t
	org-appear-autoentities t
	org-appear-autokeywords t))

(add-hook 'org-mode-hook 'auto-fill-mode)
;(add-hook 'org-mode-hook 'centered-window-mode-toggle)

;; Set faces for heading levels
;; (dolist (face '((org-level-1 . 1.25)
;; 		(org-level-2 . 1.15)))
;;   (set-face-attribute (car face) nil :height (cdr face)))

(setq org-directory "~/org/")

(setq org-startup-folded 'fold)

(defun org-refresh-agenda-files ()
  (setq org-agenda-files (append
                          (directory-files-recursively "~/wiki/" "\\.org$")
                          (directory-files-recursively "~/org/" "\\.org$")
                          )))
;; (run-with-timer 0 (* 30 60) 'org-refresh-agenda-files)

(use-package org-modern
  :hook (org-mode . org-modern-mode)
  :custom (org-modern-hide-stars . nil))

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode))

(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.25))

(add-to-list 'org-src-lang-modes '("plantuml" . plantuml))
;; ;; active Babel languages
;; (org-babel-do-load-languages
;;  'org-babel-load-languages
;;  '((shell . t)
;;    (python . t)
;;    (plantuml . t)
;;    (emacs-lisp . t)))

(defadvice org-babel-execute-src-block (around load-language nil activate)
  "Load language if needed"
  (let ((language (org-element-property :language (org-element-at-point))))
    (unless (cdr (assoc (intern language) org-babel-load-languages))
      (add-to-list 'org-babel-load-languages (cons (intern language) t))
      (org-babel-do-load-languages 'org-babel-load-languages org-babel-load-languages))
    ad-do-it))

(setq org-plantuml-jar-path (expand-file-name "/home/pablo/.nix-profile/lib/plantuml.jar"))

(setq org-confirm-babel-evaluate nil)

(require 'ox-latex)
(setq org-latex-listings 'minted
      org-latex-packages-alist '(("" "minted"))
      org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
	"biber %b"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

(setq org-latex-minted-options '(("breaklines" "true")
                                 ("breakanywhere" "true")
				 ("bgcolor" "bg")))

;;; repeat every 30 minutes (* 30 60) is just 30 * 60 seconds
;(add-hook 'org-mode-hook 'org-fragtog-mode)
;(add-hook 'org-mode-hook #'org-modern-mode)
;(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)

;(setq org-preview-latex-default-process 'dvisvgm)
;; (define-key org-mode-map (kbd "C-M-=") 'calc-embedded)
;(setq org-cycle-include-plain-lists 'integrate)

(setq org-cycle-include-plain-lists 'integrate)

(setq image-use-external-converter t)

(use-package hide-mode-line)
(use-package olivetti)

(defun personal/presentation-setup ()
  (setq-local visible-bell nil)
  (olivetti-mode +1)
  (hide-mode-line-mode +1)
  (set-face-attribute 'org-meta-line nil
		      :foreground (face-attribute 'default :background))
  (org-display-inline-images))

(defun personal/presentation-end ()
  (setq-local visible-bell t)
  (olivetti-mode -1)
  (set-face-attribute 'org-meta-line nil :foreground nil)
  (hide-mode-line-mode -1))

(use-package org-tree-slide
  :hook ((org-tree-slide-play . personal/presentation-setup)
         (org-tree-slide-stop . personal/presentation-end))
  :custom
  (org-tree-slide-slide-in-effect nil)
  (org-tree-slide-activate-message " ")
  (org-tree-slide-deactivate-message " ")
  (org-image-actual-width nil))

;(setq org-latex-with-hyperref nil)

;(defun org-insert-clipboard-image (&optional file)
;  (interactive "F")
;  (shell-command (concat "xclip -selection clipboard -t image/png -o > " file))
;  (insert "#+attr_html: :width 700px" ?\n
;          "#+attr_latex: :width 700px" ?\n
;          (concat "[[" file "]]") ?\n)
;  (org-display-inline-images))


;(setq ispell-dictionary "es_AR")

;(use-package! ox-altacv
;  :after org)
;
;(setq org-export-backends '(md ascii html icalendar altacv odt))

;(defun nicer-org ()
;  (progn
;  (auto-fill-mode 1)
;  ))
;
;(add-hook! 'org-mode-hook  #'nicer-org)

;(after! org
;  (custom-set-faces! '((org-block) :background nil))
;  (defface redd
;    '((((class color) (min-colors 88) (background light))
;      :foreground "red"))
;    "Red."
;    :group 'basic-faces)
;  (custom-set-faces!
;    ;'(org-document-title :height 1.6 :weight bold)
;    '(org-level-1 :height 1.3 :weight extrabold :slant normal)
;    '(org-level-2 :height 1.2 :weight bold :slant normal)
;    '(org-level-3 :height 1.1 :weight regular :slant normal)
;    ;'(org-document-info  :inherit 'nano-face-faded)
;    ;; '(org-document-title   ;:foreground ,(doom-color 'black)
;    ;;                        :family "Roboto"
;    ;;                        :height 250
;    ;;                        :weight medium))
;   )
;)

;(require 'org-alert)
;(org-alert-enable)
;(setq alert-default-style 'libnotify)

;(org-babel-do-load-languages
; 'org-babel-load-languages
; '((python . t)))

;(setq split-width-threshold nil)
;(setq split-height-threshold 0)

;; add a type of link so that the emacs will open the linked file with the
;; default external application (useful for media such as movies, pdfs, etc.)
;;
;(defun waflao-open-ext (path-to-media)
;  (shell-command (concat "open " path-to-media)))
;(org-add-link-type "open-ext" 'waflao-open-ext)

(defun +org-get-todo-keywords-for (&optional keyword)
  "Returns the list of todo keywords that KEYWORD belongs to."
  (when keyword
    (cl-loop for (type . keyword-spec)
             in (cl-remove-if-not #'listp org-todo-keywords)
             for keywords =
             (mapcar (lambda (x) (if (string-match "^\\([^(]+\\)(" x)
                                     (match-string 1 x)
                                   x))
                     keyword-spec)
             if (eq type 'sequence)
             if (member keyword keywords)
             return keywords)))


(defun personal/org-return ()
  (interactive)
  (if (button-at (point))
      (call-interactively #'push-button)
    (let* ((context (org-element-context))
           (type (org-element-type context)))
      ;; skip over unimportant contexts
      (while (and context (memq type '(verbatim code bold italic underline strike-through subscript superscript)))
        (setq context (org-element-property :parent context)
              type (org-element-type context)))
      (pcase type
        ((or `citation `citation-reference)
         (org-cite-follow context))

        (`headline
	 (if (or (org-element-property :todo-type context)
                 (org-element-property :scheduled context))
  	      (org-todo
  	         (if (eq (org-element-property :todo-type context) 'done)
  	  	     (or (car (+org-get-todo-keywords-for (org-element-property :todo-keyword context)))
  	  	  	'todo)
	  	  'done)))
         ;; Update any metadata or inline previews in this subtree
         (org-update-checkbox-count)
         (org-update-parent-todo-statistics))

        (`clock (org-clock-update-time-maybe))

        (`footnote-reference
         (org-footnote-goto-definition (org-element-property :label context)))

        (`footnote-definition
         (org-footnote-goto-previous-reference (org-element-property :label context)))

        ((or `planning `timestamp)
         (org-follow-timestamp-link))


        (`table-cell
         (org-table-blank-field)
         (org-table-recalculate)
         (when (and (string-empty-p (string-trim (org-table-get-field)))
                    (bound-and-true-p evil-local-mode))
           (evil-change-state 'insert)))

        (`babel-call
         (org-babel-lob-execute-maybe))

        (`statistics-cookie
         (save-excursion (org-update-statistics-cookies)))

        ((or `src-block `inline-src-block)
         (org-babel-execute-src-block))

        ((or `latex-fragment `latex-environment)
         (org-latex-preview))

        ((guard (org-element-property :checkbox (org-element-lineage context '(item) t)))
         (let ((match (and (org-at-item-checkbox-p) (match-string 1))))
           (org-toggle-checkbox (if (equal match "[ ]") '(16)))))))))

(add-hook 'org-babel-after-execute-hook
    (defun +org-redisplay-inline-images-in-babel-result-h ()
      (unless (or
               ;; ...but not while Emacs is exporting an org buffer (where
               ;; `org-display-inline-images' can be awfully slow).
               (bound-and-true-p org-export-current-backend)
               ;; ...and not while tangling org buffers (which happens in a temp
               ;; buffer where `buffer-file-name' is nil).
               (string-match-p "^ \\*temp" (buffer-name)))
        (save-excursion
          (when-let ((beg (org-babel-where-is-src-block-result))
                     (end (progn (goto-char beg) (forward-line) (org-babel-result-end))))
            (org-display-inline-images nil nil (min beg end) (max beg end)))))))

;; Keybindings

;; Map Ctrl + Shift + V to paste
(global-set-key (kbd "C-S-v") 'yank)

;; Map Ctrl + Shift + C to copy
(global-set-key (kbd "C-S-c") 'kill-ring-save)

(defun personal/update-latex-preview-scale ()
  (interactive)
  (setq org-format-latex-options
	(plist-put org-format-latex-options :scale (+ 1.25 (* text-scale-mode-amount 0.5))))
  (if (eq major-mode 'org-mode) (org-latex-preview)))

(defun personal/zoom-out ()
  (interactive)
  (text-scale-decrease 1)
  (personal/update-latex-preview-scale))

(defun personal/zoom-in ()
  (interactive)
  (text-scale-increase 1)
  (personal/update-latex-preview-scale))

(evil-set-leader 'normal (kbd ","))
(evil-define-key 'normal 'global (kbd "<leader>h") #'counsel-recentf)
(evil-define-key 'normal 'global (kbd "<leader>f") #'counsel-find-file)
(evil-define-key 'normal 'global (kbd "<leader>b") #'counsel-switch-buffer)
(evil-define-key 'normal 'global (kbd "C-p") #'counsel-fzf)
(if (eq system-type 'darwin)
    (progn
	(evil-define-key 'normal 'global (kbd "s--") #'personal/zoom-out)
	(evil-define-key 'normal 'global (kbd "s-=") #'personal/zoom-in)
	(evil-define-key 'normal 'global (kbd "s-0") #'text-scale-adjust))
  (progn
    	(evil-define-key 'normal 'global (kbd "C--") #'personal/zoom-out)
	(evil-define-key 'normal 'global (kbd "C-=") #'personal/zoom-in)
	(evil-define-key 'normal 'global (kbd "C-0") #'text-scale-adjust)))
(evil-define-key 'normal 'global (kbd "g-") #'undo)
(evil-define-key 'normal 'global (kbd "g=") #'undo-redo)
(evil-define-key 'normal org-mode-map (kbd "RET") #'personal/org-return)
(evil-define-key 'normal 'global (kbd "gc") #'evilnc-comment-operator)
(evil-define-key 'visual 'global (kbd "gc") #'evilnc-comment-operator)
(evil-define-key 'normal 'global (kbd "Q") #'evil-fill-and-move)
(evil-define-key 'normal 'global (kbd "gj") #'evil-next-visual-line)
(evil-define-key 'normal 'global (kbd "gk") #'evil-previous-visual-line)
(evil-define-key 'insert 'global (kbd "C-x C-f") #'company-files)
(evil-define-key 'insert 'global (kbd "C-x C-l") #'evil-collection-company-whole-lines)
;; Define key mappings for Alt + j and Alt + k in Evil's Ex mode using evil-define-key
(define-key evil-ex-completion-map (kbd "M-j") 'next-complete-history-element)
(define-key evil-ex-completion-map (kbd "M-k") 'previous-complete-history-element)
; (define-key evil-ex-completion-map (kbd "M-j")
;   (lambda ()
;     "Move to the end of the next complete history element in the minibuffer."
;     (interactive)
;     (let ((orig-pos (point)))
;       (if (and (bound-and-true-p evil-ex-completion-orig-pos) (= (point) (line-end-position)))
; 	(goto-char evil-ex-completion-orig-pos)
;         (setq evil-ex-completion-orig-pos orig-pos))
;       (next-complete-history-element 1)
;       (end-of-line))))

; (define-key evil-ex-completion-map (kbd "M-k")
;   (lambda ()
;     "Move to the end of the previous complete history element in the minibuffer."
;     (interactive)
;     (let ((orig-pos (point)))
;       (if (and (bound-and-true-p evil-ex-completion-orig-pos) (= (point) (line-end-position)))
; 	(goto-char evil-ex-completion-orig-pos)
;         (setq evil-ex-completion-orig-pos orig-pos))
;       (previous-complete-history-element 1)
;       (end-of-line))))


; ; define a function to clear evil-ex-completion-orig-pos variable
; (defun clear-evil-ex-completion-orig-pos ()
;   (interactive)
;   (setq evil-ex-completion-orig-pos nil))
; (advice-add 'abort-recursive-edit :before #'clear-evil-ex-completion-orig-pos)
; (advice-add 'exit-minibuffer :before #'clear-evil-ex-completion-orig-pos)
;; (advice-remove 'abort-recursive-edit #'clear-evil-ex-completion-orig-pos)
;; (advice-remove 'exit-minibuffer #'clear-evil-ex-completion-orig-pos)
;; (unintern 'evil-ex-completion-orig-pos)
;; (bound-and-true-p evil-ex-completion-orig-pos)

(evil-set-initial-state 'pdf-view-mode 'normal)

;(define-key evil-normal-state-map "Q" #'evil-fill-and-move)
;(define-key evil-normal-state-map "gj" #'evil-next-visual-line)
;(define-key evil-normal-state-map "gk" #'evil-previous-visual-line)

;; Github Copilot
(use-package copilot
  :quelpa (copilot :fetcher github
                   :repo "zerolfx/copilot.el"
                   :branch "main"
                   :files ("dist" "*.el"))
  :bind (:map copilot-mode-map
	      ("<tab>" . copilot-accept-completion)
	      ("TAB" . copilot-accept-completion)
	      ("C-TAB" . copilot-accept-completion-by-word)
	      ("C-<tab>" . copilot-accept-completion-by-word)))
;; you can utilize :map :hook and :config to customize copilot
(add-hook 'prog-mode-hook 'copilot-mode)
;; (evil-define-key 'insert 'global (kbd "<tab>") #'copilot-accept-completion)
;; (evil-define-key 'insert 'global (kbd "TAB") #'copilot-accept-completion)

(defun personal/org-reload-latex-fragments ()
  "Check for the 'ltximg' folder and reload LaTeX fragments if found."
  (interactive)
  (let ((ltximg-folder "ltximg"))
    (if (file-exists-p ltximg-folder)
        (progn
          (delete-directory ltximg-folder t) ; Delete the 'ltximg' folder and its contents
          (message "Deleted 'ltximg' folder.")
	  (org-clear-latex-preview (point-min) (point-max))
	  (org--latex-preview-region (point-min) (point-max))
          (message "Reloaded LaTeX fragments."))
      (message "No 'ltximg' folder found. Nothing to do."))))
