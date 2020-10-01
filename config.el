;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "monospace" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.
(require 'rtags)
  (add-hook 'c-mode-hook #'cide--mode-hook)
  (add-hook 'c++-mode-hook #'cide--mode-hook)
  ;; When creating a file in Emacs, run CMake again to pick it up
;; (add-hook 'before-save-hook #'cide--before-save)
(require 'clang-format)
(global-set-key (kbd "C-c i") 'clang-format-region)
(global-set-key (kbd "C-c u") 'clang-format-buffer)

(setq clang-format-style-option "llvm")
(add-hook 'c-mode-common-hook
          (function (lambda ()
                    (add-hook 'before-save-hook
                              'clang-format-buffer))))
(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)


(load! "flycheck-glsl" )

(use-package rtags
  :ensure t
  :hook (c++-mode . rtags-start-process-unless-running)
  :config (setq rtags-completions-enabled t
		rtags-path "/home/tocha/.emacs.d/rtags/src/rtags.el"
		rtags-rc-binary-name "/home/tocha/.emacs.d/rtags/bin/rc"
		rtags-use-helm t
		rtags-rdm-binary-name "/home/tocha/.emacs.d/rtags/bin/rdm")
  :bind (("C-c E" . rtags-find-symbol)
  	 ("C-c e" . rtags-find-symbol-at-point)
  	 ("C-c O" . rtags-find-references)
  	 ("C-c o" . rtags-find-references-at-point)
  	 ("C-c s" . rtags-find-file)
  	 ("C-c v" . rtags-find-virtuals-at-point)
  	 ("C-c F" . rtags-fixit)
  	 ("C-c f" . rtags-location-stack-forward)
  	 ("C-c b" . rtags-location-stack-back)
  	 ("C-c n" . rtags-next-match)
  	 ("C-c p" . rtags-previous-match)
  	 ("C-c P" . rtags-preprocess-file)
  	 ("C-c R" . rtags-rename-symbol)
  	 ("C-c x" . rtags-show-rtags-buffer)
  	 ("C-c T" . rtags-print-symbol-info)
  	 ("C-c t" . rtags-symbol-type)
  	 ("C-c I" . rtags-include-file)
  	 ("C-c i" . rtags-get-include-file-for-symbol)))

(setq rtags-display-result-backend 'helm)
;; ;;=====================DAP DEBUG==============================

;; ======================NODE==================================
(require 'dap-mode)
(require 'dap-node)

(dap-register-debug-template "DiagramsAPI"
                             (list :name "DiagramsAPI"
                                   :type "node"
                                   :request "launch"
                                   :args [ "/home/tocha/develop/wilpride_el_diagram/api/src/main.ts"]
                                   :runtimeArgs ["--nolazy" "-r" "ts-node/register"]
                                   :trace t
                                   :environment (list :NODE_ENV "debug")
                                   :sourceMaps t
                                   :cwd "/home/tocha/develop/wilpride_el_diagram/api/src"
                                   :protocol "inspector"))

;; ;;=====================DAP CHROME==============================
(require 'dap-chrome)
(require 'restclient)
;;======================REACT==================================
;;
(require 'rjsx-mode)
(require 'prettier-js)
(add-hook 'rjsx-mode-hook 'prettier-js-mode)


(with-eval-after-load 'rjsx-mode
  (define-key rjsx-mode-map "<" nil)
  (define-key rjsx-mode-map (kbd "C-d") nil)
  (define-key rjsx-mode-map ">" nil))

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . rjsx-mode))

(modify-syntax-entry ?` "\"" js-mode-syntax-table)


(load! "styled" )
(global-set-key (kbd "C-c '") #'fence-edit-code-at-point)

(setq tide-server-max-response-length 2147483647)
;; =====================Vue Mode================================
(require 'vue-mode)
(require 'prettier-js)
(add-hook 'vue-mode-hook 'prettier-js-mode)

(require 'rainbow-delimiters)
(add-hook 'vue-mode-hook 'rainbow-delimiters-mode)
;; For vue-mode with Emacs 26.3
(setq mmm-js-mode-enter-hook (lambda () (setq syntax-ppss-table nil)))
(setq mmm-typescript-mode-enter-hook (lambda () (setq syntax-ppss-table nil)))

(add-hook 'vue-mode-hook #'lsp-deferred)
(add-hook 'vue-mode-hook 'tide-restart-server)
;;=====================TYPESCRIPT=============================
;;(add-hook 'before-save-hook 'prettier-js-mode)

(eval-after-load
  'typescript-mode
  '(add-hook 'typescript-mode-hook #'add-node-modules-path))

(use-package tide :diminish t)
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (prettier-js-mode +1)
;;   (eldoc-mode +1)
  (company-mode +1)
;;   (prettier-js-mode +1)
  (flycheck-mode +1)
  (tide-hl-identifier-mode +1))

;; ;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; ;; formats the buffer before saving
;; ;; (add-hook 'before-save-hook 'tide-format-before-save)
(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; (add-hook 'typescript-mode-hook
;;           (lambda ()
;;             (when (string-equal "tsx" (file-name-extension buffer-file-name))
;;               (setup-tide-mode))))
;; (require 'dap-mode)
;; (setq tide-server-max-response-length 2147483647)

(global-set-key (kbd "C-c z") 'hydra-typescript/body)
(setq tide-server-max-response-length 2147483647)
(defhydra hydra-typescript (:color red
                                   :hint nil )

  "
  ^Buffer^                 ^Errors^                   ^Refactor^                   ^Format^                 ^Tide^
------------------------------------------------------------------------------------------------------------------------------------
[_d_]   Documentation      [_e_] Errors              [_rs_]  Rename symbol         [_t_]  Tide format       [_*_]  Restart server
[_fd_]  Find definition    [_a_] Apply error fix     [_rf_]  Refactor              [_c_]  JSDoc comment     [_v_]  Verify setup
[_fr_]  Find references                                                                               [_i_]  Organize imports
"
  ("a" tide-fix :exit t)
  ("d" tide-documentation-at-point :exit t)
  ("fd" tide-jump-to-definition :exit t)
  ("fr" tide-references :exit t)
  ("c" tide-jsdoc-template :exit t)
  ("e" tide-project-errors :exit t)
  ("rs" tide-rename-symbol :exit t)
  ("rf" tide-refactor :exit t)
  ("t" tide-format :exit t)
  ("*" tide-restart-server :exit t)
  ("v" tide-verify-setup :exit t)
  ("i" tide-organize-imports :exit t)
  )

;; ;;===================== COMPANY  ================================
(use-package company
  :demand t
  :bind (;; Replace `completion-at-point' and `complete-symbol' with
         ;; `company-manual-begin'. You might think this could be put
         ;; in the `:bind*' declaration below, but it seems that
         ;; `bind-key*' does not work with remappings.
         ([remap completion-at-point] . company-manual-begin)
         ([remap complete-symbol] . company-manual-begin)

         ;; The following are keybindings that take effect whenever
         ;; the completions menu is visible, even if the user has not
         ;; explicitly interacted with Company.

         :map company-active-map

         ;; Make TAB always complete the current selection. Note that
         ;; <tab> is for windowed Emacs and TAB is for terminal Emacs.
         ("<tab>" . company-complete-selection)
         ("TAB" . company-complete-selection)

         ;; Prevent SPC from ever triggering a completion.
         ("SPC" . nil)

         ;; The following are keybindings that only take effect if the
         ;; user has explicitly interacted with Company.

         :map company-active-map
         :filter (company-explicit-action-p)

         ;; Make RET trigger a completion if and only if the user has
         ;; explicitly interacted with Company. Note that <return> is
         ;; for windowed Emacs and RET is for terminal Emacs.
         ("<return>" . company-complete-selection)
         ("RET" . company-complete-selection)

         ;; We then do the same for the up and down arrows. Note that
         ;; we use `company-select-previous' instead of
         ;; `company-select-previous-or-abort'. I think the former
         ;; makes more sense since the general idea of this `company'
         ;; configuration is to decide whether or not to steal
         ;; keypresses based on whether the user has explicitly
         ;; interacted with `company', not based on the number of
         ;; candidates.

         ("<C-k>" . company-select-previous)
         ("<C-j>" . company-select-next))

  :bind* (;; The default keybinding for `completion-at-point' and
          ;; `complete-symbol' is M-TAB or equivalently C-M-i. Here we
          ;; make sure that no minor modes override this keybinding.
          ("M-TAB" . company-manual-begin))

  :diminish company-mode
  :config

  ;; Turn on Company everywhere.
  (global-company-mode 1)

  ;; Show completions instantly, rather than after half a second.
  (setq company-idle-delay 0)

  ;; Show completions after typing a single character, rather than
  ;; after typing three characters.
  (setq company-minimum-prefix-length 1)

  ;; Show a maximum of 10 suggestions. This is the default but I think
  ;; it's best to be explicit.
  (setq company-tooltip-limit 10)

  ;; Always display the entire suggestion list onscreen, placing it
  ;; above the cursor if necessary.
  (setq company-tooltip-minimum company-tooltip-limit)

  ;; Always display suggestions in the tooltip, even if there is only
  ;; one. Also, don't display metadata in the echo area. (This
  ;; conflicts with ElDoc.)
  (setq company-frontends '(company-pseudo-tooltip-frontend))

  ;; Show quick-reference numbers in the tooltip. (Select a completion
  ;; with M-1 through M-0.)
  (setq company-show-numbers t)

  ;; Prevent non-matching input (which will dismiss the completions
  ;; menu), but only if the user interacts explicitly with Company.
  (setq company-require-match #'company-explicit-action-p)

  ;; Company appears to override our settings in `company-active-map'
  ;; based on `company-auto-complete-chars'. Turning it off ensures we
  ;; have full control.
  (setq company-auto-complete-chars nil)

  ;; Prevent Company completions from being lowercased in the
  ;; completion menu. This has only been observed to happen for
  ;; comments and strings in Clojure.
  (setq company-dabbrev-downcase nil)

  ;; Only search the current buffer to get suggestions for
  ;; company-dabbrev (a backend that creates suggestions from text
  ;; found in your buffers). This prevents Company from causing lag
  ;; once you have a lot of buffers open.
  (setq company-dabbrev-other-buffers nil)

  ;; Make company-dabbrev case-sensitive. Case insensitivity seems
  ;; like a great idea, but it turns out to look really bad when you
  ;; have domain-specific words that have particular casing.
  (setq company-dabbrev-ignore-case nil)

  ;; Make it so that Company's keymap overrides Yasnippet's keymap
  ;; when a snippet is active. This way, you can TAB to complete a
  ;; suggestion for the current field in a snippet, and then TAB to
  ;; move to the next field. Plus, C-g will dismiss the Company
  ;; completions menu rather than cancelling the snippet and moving
  ;; the cursor while leaving the completions menu on-screen in the
  ;; same location.

  (with-eval-after-load 'yasnippet
    ;; TODO: this is all a horrible hack, can it be done with
    ;; `bind-key' instead?

    ;; This function translates the "event types" I get from
    ;; `map-keymap' into things that I can pass to `lookup-key'
    ;; and `define-key'. It's a hack, and I'd like to find a
    ;; built-in function that accomplishes the same thing while
    ;; taking care of any edge cases I might have missed in this
    ;; ad-hoc solution.
    (defun radian--normalize-event (event)
      (if (vectorp event)
          event
        (vector event)))

    ;; Here we define a hybrid keymap that delegates first to
    ;; `company-active-map' and then to `yas-keymap'.
    (setq radian--yas-company-keymap
          ;; It starts out as a copy of `yas-keymap', and then we
          ;; merge in all of the bindings from
          ;; `company-active-map'.
          (let ((keymap (copy-keymap yas-keymap)))
            (map-keymap
             (lambda (event company-cmd)
               (let* ((event (radian--normalize-event event))
                      (yas-cmd (lookup-key yas-keymap event)))
                 ;; Here we use an extended menu item with the
                 ;; `:filter' option, which allows us to
                 ;; dynamically decide which command we want to
                 ;; run when a key is pressed.
                 (define-key keymap event
                   `(menu-item
                     nil ,company-cmd :filter
                     (lambda (cmd)
                       ;; There doesn't seem to be any obvious
                       ;; function from Company to tell whether or
                       ;; not a completion is in progress (à la
                       ;; `company-explicit-action-p'), so I just
                       ;; check whether or not `company-my-keymap'
                       ;; is defined, which seems to be good
                       ;; enough.
                       (if company-my-keymap
                           ',company-cmd
                         ',yas-cmd))))))
             company-active-map)
            keymap))
    (setq python-shell-interpreter "/home/tocha/develop/Python-sandbox/sandbox/bin")
    (add-to-list 'company-backends 'company-jedi)
    ;; The function `yas--make-control-overlay' uses the current
    ;; value of `yas-keymap' to build the Yasnippet overlay, so to
    ;; override the Yasnippet keymap we only need to dynamically
    ;; rebind `yas-keymap' for the duration of that function.
    (defun radian--advice-company-overrides-yasnippet
        (yas--make-control-overlay &rest args)
      "Allow `company' to override `yasnippet'.
This is an `:around' advice for `yas--make-control-overlay'."
      (let ((yas-keymap radian--yas-company-keymap))
        (apply yas--make-control-overlay args)))

    (advice-add #'yas--make-control-overlay :around
                #'radian--advice-company-overrides-yasnippet)))
;;; Prevent suggestions from being triggered automatically. In particular,
  ;;; this makes it so that:
  ;;; - TAB will always complete the current selection.
  ;;; - RET will only complete the current selection if the user has explicitly
  ;;;   interacted with Company.
  ;;; - SPC will never complete the current selection.
  ;;;
  ;;; Based on:
  ;;; - https://github.com/company-mode/company-mode/issues/530#issuecomment-226566961
  ;;; - https://emacs.stackexchange.com/a/13290/12534
  ;;; - http://stackoverflow.com/a/22863701/3538165
  ;;;
  ;;; See also:
  ;;; - https://emacs.stackexchange.com/a/24800/12534
  ;;; - https://emacs.stackexchange.com/q/27459/12534

;; <return> is for windowed Emacs; RET is for terminal Emacs
(dolist (key '("<return>" "RET"))
  ;; Here we are using an advanced feature of define-key that lets
  ;; us pass an "extended menu item" instead of an interactive
  ;; function. Doing this allows RET to regain its usual
  ;; functionality when the user has not explicitly interacted with
  ;; Company.
  (define-key company-active-map (kbd key)
    `(menu-item nil company-complete
                :filter ,(lambda (cmd)
                           (when (company-explicit-action-p)
                             cmd)))))
(define-key company-active-map (kbd "TAB") #'company-complete-selection)
(define-key company-active-map (kbd "SPC") nil)


;; Company appears to override the above keymap based on company-auto-complete-chars.
;; Turning it off ensures we have full control.
(setq company-auto-complete-chars nil)
;;===================PYTHON========================
(use-package pyenv-mode
  ;; Integrate pyenv with Python-mode
  :init
  (let ((pyenv-path (expand-file-name "~/.pyenv/bin")))
    (setenv "PATH" (concat pyenv-path ":" (getenv "PATH")))
    (add-to-list 'exec-path pyenv-path))
  :config
  (pyenv-mode))

(require 'pyenv-mode)
 (require 'flycheck-mypy)

(defun projectile-pyenv-mode-set ()
  "Set pyenv version matching project name."
  (let ((project (projectile-project-name)))
    (if (member project (pyenv-mode-versions))
        (pyenv-mode-set project)
      (pyenv-mode-unset))))

(defun my/python-mode-hook ()
  (add-to-list 'company-backends 'company-jedi))

(add-hook 'python-mode-hook 'my/python-mode-hook)


(after! python
  (set-company-backend! 'python-mode 'company-jedi))


(require 'ein)
(require 'ein-dev)
(require 'jedi)
(add-hook 'ein:connect-mode-hook 'ein:jedi-setup)

(setq ein:output-area-inlined-images t);

(add-hook 'python-mode-hook 'yapf-mode)


(require 'gdscript-mode)
;;============================SQL===============================
(load! "company-sql" )

(add-to-list 'company-backends 'company-sql)

(require 'ejc-sql)
(add-hook 'ejc-sql-minor-mode-hook
          (lambda ()
            (auto-complete-mode t)
            (ejc-ac-setup)))

(ejc-create-connection
 "my-db-conn"
 :classpath "/home/tocha/.m2/repository/postgresql/postgresql/9.3-1102.jdbc41/postgresql-42.2.14.jar"
 :dbtype "postgresql"
 :dbname "tme"
 :host "localhost"
 :port "5432"
 :user "postgres"
 :password "fallen88")

(require 'org-sql)

(require 'json-mode)
(add-to-list 'auto-mode-alist '("\\.json'" . json-mode))
