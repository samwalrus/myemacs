
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(org-agenda-files
   '("/media/sam/9bb6ab40-5f17-481e-aba8-7bd9e4e05d66/home/sam/Documents/Reactome_pengine/todolist_reactome_pen.org" "/home/sam/Documents/methylation/methylation/todolist_meth.org" "/home/sam/Desktop/business_website/linkshare/todo_linkshare.org")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(global-set-key [f10] 'ediprolog-dwim)

(setq load-path (cons "/home/sam/Documents/emacs/prolog" load-path))
(autoload 'run-prolog "prolog" "Start a Prolog sub-process." t)
(autoload 'prolog-mode "prolog" "Major mode for editing Prolog programs." t)
(autoload 'mercury-mode "prolog" "Major mode for editing Mercury programs." t)
(setq prolog-system 'swi)
(setq auto-mode-alist (append '(("\\.pl$" . prolog-mode)
                                ("\\.m$" . mercury-mode))
			      auto-mode-alist))

(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "/media/sam/9bb6ab40-5f17-481e-aba8-7bd9e4e05d66/home/sam/Documents/Reactome_pengine/todolist_reactome_pen.org"
                             "/home/sam/Documents/methylation/methylation/todolist_meth.org" 
                             "/home/sam/Desktop/business_website/linkshare/todo_linkshare.org"
			     "/media/sam/9bb6ab40-5f17-481e-aba8-7bd9e4e05d66/home/sam/Documents/Prolog_practise/machine_learning/shapelets/todo_shapelets.org"))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(define-prefix-command 'endless/mc-map)
;; C-x m is usually `compose-mail'. Bind it to something
;; else if you use this command.
(define-key ctl-x-map "m" 'endless/mc-map)

;; These vary between keyboards. They're supposed to be
;; Shifted versions of the two above.
(global-set-key (kbd "M-£") #'mc/unmark-next-like-this)
(global-set-key (kbd "M-$") #'mc/unmark-previous-like-this)

;;; Really really nice!
(define-key endless/mc-map "i" #'mc/insert-numbers)
(define-key endless/mc-map "h" #'mc-hide-unmatched-lines-mode)
(define-key endless/mc-map "a" #'mc/mark-all-like-this)

;;; Occasionally useful
(define-key endless/mc-map "d"
  #'mc/mark-all-symbols-like-this-in-defun)
(define-key endless/mc-map "r" #'mc/reverse-regions)
(define-key endless/mc-map "s" #'mc/sort-regions)
(define-key endless/mc-map "l" #'mc/edit-lines)
(define-key endless/mc-map "\C-a"
  #'mc/edit-beginnings-of-lines)
(define-key endless/mc-map "\C-e"
  #'mc/edit-ends-of-lines)
(global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click)


(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)


(defun prolog-insert-comment-block ()
  "Insert a PceEmacs-style comment block like /* - - ... - - */ "
  (interactive)
  (let ((dashes "-"))
    (dotimes (_ 36) (setq dashes (concat "- " dashes)))
    (insert (format "/* %s\n\n%s */" dashes dashes))
    (forward-line -1)
    (indent-for-tab-command)))

(global-set-key "\C-cq" 'prolog-insert-comment-block)

(global-set-key "\C-cl" (lambda ()
                          (interactive)
                          (insert ":- use_module(library()).")
                          (forward-char -3)))

(add-hook 'prolog-mode-hook
          (lambda ()
            (require 'flymake)
            (make-local-variable 'flymake-allowed-file-name-masks)
            (make-local-variable 'flymake-err-line-patterns)
            (setq flymake-err-line-patterns
                  '(("ERROR: (?\\(.*?\\):\\([0-9]+\\)" 1 2)
                    ("Warning: (\\(.*\\):\\([0-9]+\\)" 1 2)))
            (setq flymake-allowed-file-name-masks
                  '(("\\.pl\\'" flymake-prolog-init)))
            (flymake-mode 1)))

(defun flymake-prolog-init ()
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
         (local-file  (file-relative-name
                       temp-file
                       (file-name-directory buffer-file-name))))
    (list "swipl" (list "-q" "-t" "halt" "-s " local-file))))
