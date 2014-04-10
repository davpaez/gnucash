;; This program is free software; you can redistribute it and/or    
;; modify it under the terms of the GNU General Public License as   
;; published by the Free Software Foundation; either version 2 of   
;; the License, or (at your option) any later version.              
;;                                                                  
;; This program is distributed in the hope that it will be useful,  
;; but WITHOUT ANY WARRANTY; without even the implied warranty of   
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the    
;; GNU General Public License for more details.                     
;;                                                                  
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, contact:
;;
;; Free Software Foundation           Voice:  +1-617-542-5942
;; 59 Temple Place - Suite 330        Fax:    +1-617-542-2652
;; Boston, MA  02111-1307,  USA       gnu@gnu.org

(define (gnc:startup)
  (gnc:debug "starting up.")
  (if (not (gnc:handle-command-line-args))
      (gnc:shutdown 1))

  (gnc:setup-debugging)

  ;; Load the srfis
  (gnc:load "srfi/srfi-8.guile.scm")
  (gnc:load "srfi/srfi-1.unclear.scm")
  (gnc:load "srfi/srfi-1.r5rs.scm")

  ;; Now we can load a bunch of files.

  (gnc:depend "doc.scm")
  (gnc:depend "extensions.scm")
  (gnc:depend "text-export.scm")
  (gnc:depend "report.scm")
  (gnc:depend "report/report-list.scm")
  (gnc:depend "qif-import/qif-import.scm")
  (gnc:depend "printing/print-check.scm")

  ;; Load the system configs
  (if (not (gnc:load-system-config-if-needed))
      (gnc:shutdown 1))

  ;; Load the user configs
  (gnc:load-user-config-if-needed)

  ;; Clear the change flags caused by loading the configs
  (gnc:global-options-clear-changes)

  (gnc:hook-run-danglers gnc:*startup-hook*)

  (if (gnc:config-var-value-get gnc:*arg-show-version*)
      (begin
        (gnc:prefs-show-version)
        (gnc:shutdown 0)))

  (if (or (gnc:config-var-value-get gnc:*arg-show-usage*)
          (gnc:config-var-value-get gnc:*arg-show-help*))
      (begin
        (gnc:prefs-show-usage)
        (gnc:shutdown 0)))

  (if (gnc:config-var-value-get gnc:*loglevel*)
      (gnc:set-log-level-global (gnc:config-var-value-get gnc:*loglevel*))))


(define (gnc:shutdown exit-status)
  (gnc:debug "Shutdown -- exit-status: " exit-status)

  (cond ((gnc:ui-is-running?)
	 (if (not (gnc:ui-is-terminating?))
	     (begin
               (gnc:ui-destroy-all-subwindows)
               (if (gnc:file-query-save)
                   (begin
                     (gnc:hook-run-danglers gnc:*ui-shutdown-hook*)
                     (gnc:ui-shutdown))))))
        (else
	 (gnc:ui-destroy)
	 (gnc:hook-run-danglers gnc:*shutdown-hook*)
	 (exit exit-status))))

(define (gnc:ui-finish)
  (gnc:debug "UI Shutdown hook.")
  (gnc:file-quit))

(define (gnc:main)

  ;; Now the fun begins.
  (gnc:startup)

  (if (not (= (gnc:lowlev-app-init) 0))
      (gnc:shutdown 0))

  (let ((ok (not (gnc:config-var-value-get gnc:*arg-no-file*)))
        (file (if (pair? gnc:*command-line-files*)
                  (car gnc:*command-line-files*)
                  (gnc:history-get-last))))
    (if (and ok (string? file))
      (gnc:ui-open-file file)))

  ;; add a hook to save the user configs on shutdown
  (gnc:hook-add-dangler gnc:*shutdown-hook* gnc:save-global-options)
  (gnc:hook-add-dangler gnc:*ui-shutdown-hook* gnc:ui-finish)
  (gnc:ui-main)
  (gnc:hook-remove-dangler gnc:*ui-shutdown-hook* gnc:ui-finish)
  (gnc:shutdown 0))