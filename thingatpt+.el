;;; thingatpt+.el --- Extensions to `thingatpt.el'.
;;
;; Filename: thingatpt+.el
;; Description: Extensions to `thingatpt.el'.
;; Author: Drew Adams
;; Maintainer: Drew Adams
;; Copyright (C) 1996-2012, Drew Adams, all rights reserved.
;; Created: Tue Feb 13 16:47:45 1996
;; Version: 21.0
;; Last-Updated: Fri Aug 17 16:06:02 2012 (-0700)
;;           By: dradams
;;     Update #: 1589
;; URL: http://www.emacswiki.org/cgi-bin/wiki/thingatpt+.el
;; Keywords: extensions, matching, mouse
;; Compatibility: GNU Emacs: 20.x, 21.x, 22.x, 23.x
;;
;; Features that might be required by this library:
;;
;;   `thingatpt'.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;;    Extensions to `thingatpt.el'.
;;
;;
;;  Commands defined here:
;;
;;    `find-fn-or-var-nearest-point', `forward-char-same-line',
;;    `forward-whitespace-&-newlines', `tap-redefine-std-fns'.
;;
;;  User options defined here:
;;
;;    `tap-near-point-x-distance', `tap-near-point-y-distance'.
;;
;;  Non-interactive functions defined here:
;;
;;    `tap-bounds-of-form-at-point',
;;    `tap-bounds-of-form-nearest-point',
;;    `tap-bounds-of-list-at-point',
;;    `tap-bounds-of-list-nearest-point',
;;    `tap-bounds-of-sexp-at-point',
;;    `tap-bounds-of-sexp-nearest-point',
;;    `tap-bounds-of-string-at-point',
;;    `tap-bounds-of-symbol-at-point',
;;    `tap-bounds-of-symbol-nearest-point',
;;    `tap-bounds-of-thing-nearest-point',
;;    `tap-define-aliases-wo-prefix', `tap-form-at-point-with-bounds',
;;    `tap-form-nearest-point', `tap-form-nearest-point-with-bounds',
;;    `tap-list-at/nearest-point-with-bounds',
;;    `tap-list-at-point-with-bounds', `tap-list-nearest-point',
;;    `tap-list-nearest-point-with-bounds',
;;    `tap-list-nearest-point-as-string',
;;    `tap-non-nil-symbol-name-at-point',
;;    `tap-non-nil-symbol-name-nearest-point',
;;    `tap-non-nil-symbol-nearest-point',
;;    `tap-number-at-point-decimal', `tap-number-at-point-hex',
;;    `tap-number-nearest-point', `tap-region-or-word-at-point',
;;    `tap-region-or-word-nearest-point',
;;    `tap-region-or-non-nil-symbol-name-nearest-point',
;;    `tap-sentence-nearest-point', `tap-sexp-at-point-with-bounds',
;;    `tap-sexp-nearest-point', `tap-sexp-nearest-point-with-bounds',
;;    `tap-string-at-point', `tap-string-nearest-point',
;;    `tap-symbol-at-point-with-bounds',
;;    `tap-symbol-name-nearest-point', `tap-symbol-nearest-point',
;;    `tap-symbol-nearest-point-with-bounds',
;;    `tap-thing-at-point-with-bounds',
;;    `tap-thing/form-nearest-point-with-bounds',
;;    `tap-thing-nearest-point',
;;    `tap-thing-nearest-point-with-bounds',
;;    `tap-unquoted-list-at-point', `tap-unquoted-list-nearest-point',
;;    `tap-unquoted-list-nearest-point-as-string',
;;    `tap-word-nearest-point',
;;
;;    plus the same functions without the prefix `tap-', if you invoke
;;    `tap-redefine-std-fns'.
;;
;;
;;  A REMINDER (the doc strings are not so great):
;;
;;    These functions, defined in `thingatpt.el', all move point:
;;      `beginning-of-thing', `end-of-sexp', `end-of-thing',
;;      `forward-symbol', `forward-thing'.
;;
;;  For older Emacs releases that do not have the following functions,
;;  they are defined here as no-ops:
;;
;;  `constrain-to-field', `field-beginning', `field-end'.
;;
;;
;;  This file should be loaded after loading the standard GNU file
;;  `thingatpt.el'.  So, in your init file (`~/.emacs'), do this:
;;
;;    (eval-after-load "thingatpt" '(require 'thingatpt+))
;;
;;  But to get the most out of this library, use the following in your
;;  init file, instead:
;;
;;    (eval-after-load "thingatpt"
;;      '(require 'thingatpt+)
;;       (tap-redefine-std-fns))
;;
;;  That makes all code that uses the following functions use the
;;  their versions that are defined here, not the standard versions.
;;
;;  `bounds-of-thing-at-point' - Accept optional arg SYNTAX-TABLE.
;;  `form-at-point'            - Accept optional arg SYNTAX-TABLE.
;;  `list-at-point'            - Better behavior.
;;                               Accept optional arg SYNTAX-TABLE.
;;  `symbol-at-point'          - Accept optional arg NON-NIL.
;;  `thing-at-point'           - Accept optional arg SYNTAX-TABLE.
;;  `thing-at-point-bounds-of-list-at-point'
;;                             - Better behavior.  Accept optional
;;                               args UP and UNQUOTEDP.
;;
;;  If you write code that uses the functions here, for convenience
;;  you can invoke `tap-define-aliases-wo-prefix' to provide alias
;;  functions that have the same names but without the prefix `tap-'.
;;  These aliases do not collide with any standard Emacs functions.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Change Log:
;;
;; 2012/08/17 dadams
;;     Added: tap-define-aliases-wo-prefix, tap-redefine-std-fns.
;;     Added group thing-at-point-plus.  Use for defcustoms.
;;     Renamed fns & vars, adding prefix tap-.
;;     Do not redefine std stuff, except in tap-define-aliases-wo-prefix, tap-redefine-std-fns.
;; 2012/02/18 dadams
;;     thing/form-nearest-point-with-bounds:
;;       Fixed infloop: set [be]obp when finished sole line in both directions.
;; 2011/09/06 dadams
;;     thing/form-nearest-point-with-bounds: If only one line then do not try to access others.
;;     bounds-of-thing-at-point-1, thing-at-point, thing/form-nearest-point-with-bounds:
;;       Respect field boundaries.
;;     Define constrain-to-field, field-(beginning|end) as no-ops for older Emacs releases.
;; 2011/08/30 dadams
;;     Added: region-or-non-nil-symbol-name-nearest-point.
;;     region-or-*: Use region only if transient-mark-mode, non-empty (and active).
;; 2011/08/17 dadams
;;     list-at/nearest-point-with-bounds:
;;       Don't count `foo or 'foo as a list, i.e., (` foo) or (quote foo).
;; 2011/08/14 dadams
;;     bounds-of-thing-at-point-1:
;;       Tests for end need to use <, not <=.  If past the THING then should return nil.
;; 2011/07/08 dadams
;;     Removed: list-at/nearest-point.
;;     Added: (list|sexp)-(at|nearest)-point-with-bounds,
;;            bounds-of-(list|sexp)-(at|nearest)-point, list-at/nearest-point-with-bounds.
;;     (unquoted-)list-(at|nearest)-point(-as-string):
;;       Redefined using list-(at|nearest)-point-with-bounds.
;;     (put 'list 'bounds-of-thing-at-point 'bounds-of-list-at-point) - not nil.
;; 2011/05/24 dadams
;;     Added: (bounds-of-)string-at-point, string-nearest-point.
;; 2011/05/21 dadams
;;     bounds-of-thing-at-point-1: Synchronized with vanilla Emacs fix for bug #8667.
;; 2011/05/13 dadams
;;     Added redefinition of bounds-of-thing-at-point - fixed bug #8667.
;;       Removed old-bounds-of-thing-at-point.  Added: bounds-of-thing-at-point-1.
;;     Added: forward-whitespace-&-newlines.
;;     Added (put 'thing-at-point *) for unquoted-list, non-nil-symbol-name.
;;     Removed old eval-when-compile for Emacs before Emacs 20.
;; 2011/05/07 dadams
;;     Added: number-at-point-(decimal|hex) and aliases.
;;     Put (bounds-of-)thing-at-point properties: (hex-|decimal-)number-at-point.
;; 2011/05/05 dadams
;;     (put 'list 'bounds-of-thing-at-point nil)  See Emacs bug #8628.
;;     (put 'list 'thing-at-point 'list-at-point) - not really needed, though.
;;     bounds-of-thing-at-point: Mention in doc string that pre-Emacs 23 is buggy.
;; 2011/01/20 dadams
;;     *list-*-point: Improved doc strings.
;; 2011/01/04 dadams
;;     Removed autoload cookies from non def* sexps and non-interactive fns.
;;     Added autoload cookies for defcustom.
;; 2010/12/17 dadams
;;     Added: (unquoted-)list-(at|nearest)-point, list-at/nearest-point,
;;            unquoted-list-nearest-point-as-string.
;;     list-nearest-point: Redefined using list-at/nearest-point.
;; 2010/12/10 dadams
;;     form-at-point-with-bounds:
;;       Moved condition-case to around whole.  Let sexp be any format of nil.
;; 2010/01/24 dadams
;;     Added: region-or-word-nearest-point.
;; 2008/10/22 dadams
;;     Added: region-or-word-at-point.  Thx to Richard Riley.
;; 2007/07/15 dadams
;;     Added: thing/form-nearest-point-with-bounds,
;;            non-nil-symbol(-name)-(at|nearest)-point, near-point-(x|y)-distance.
;;     (thing|form)-nearest-point-with-bounds:
;;       Use thing/form-nearest-point-with-bounds, which: (1) accepts PRED arg,
;;         (2) respects near-point-(x|y)-distance, (3) fixed some logic.
;;     form-at-point-with-bounds:
;;       Distinguish between nil (no find) and "nil" object found.
;;     (bounds-of-)symbol-(at|nearest)-point(-with-bounds), :
;;       Added optional non-nil arg.
;;     Added beginning-op, end-op, and forward-op for defun type.
;; 2006/12/08 dadams
;;     Added: find-fn-or-var-nearest-point.
;; 2006/05/16 dadams
;;     Only require cl (at compile time) for Emacs < 20.
;;     Replace incf by setq...1+.
;; 2005/12/17 dadams
;;     symbol-name-nearest-point, form-at-point-with-bounds:
;;       Treat nil as legitimate symbol.
;; 1996/06/11 dadams
;;     bounds-of-symbol-at-point, bounds-of-symbol-nearest-point,
;;       symbol-at-point, symbol-at-point-with-bounds,
;;       symbol-name-nearest-point, symbol-nearest-point,
;;       symbol-nearest-point-with-bounds: No longer use a syntax-table
;;       arg.  Always dealing with elisp symbols, so use
;;       emacs-lisp-mode-syntax-table.
;; 1996/03/20 dadams
;;     1. Added redefinitions of thing-at-point, form-at-point, with optional
;;        syntax table arg.
;;     2. Added: thing-nearest-point-with-bounds,
;;        bounds-of-thing-nearest-point, thing-nearest-point,
;;        form-nearest-point-with-bounds,
;;        bounds-of-form-nearest-point, form-nearest-point,
;;        word-nearest-point, sentence-nearest-point,
;;        sexp-nearest-point, number-nearest-point,
;;        list-nearest-point.
;;     3. symbol-at-point: Added optional syntax table arg.
;;     4. symbol-nearest-point-with-bounds: Now defined in terms of
;;        form-nearest-point-with-bounds.
;;     5. bounds-of-form-at-point: Added args THING and PRED.
;; 1996/03/20 dadams
;;     1. Added redefinition of bounds-of-thing-at-point: New arg SYNTAX-TABLE.
;;     2. thing-at-point-with-bounds, form-at-point-with-bounds,
;;        bounds-of-form-at-point, symbol-at-point-with-bounds,
;;        bounds-of-symbol-at-point, symbol-nearest-point-with-bounds,
;;        bounds-of-symbol-nearest-point, symbol-nearest-point,
;;        symbol-name-nearest-point: New arg SYNTAX-TABLE.
;; 1996/03/08 dadams
;;     1. Added: thing-at-point-with-bounds, form-at-point-with-bounds,
;;        bounds-of-form-at-point, symbol-at-point-with-bounds,
;;        bounds-of-symbol-at-point
;;     2. symbol-at-point: 2nd arg ('symbolp) to form-at-point to ensure interned.
;;     3. Added: symbol-nearest-point-with-bounds, symbol-name-nearest-point,
;;        bounds-of-symbol-nearest-point, symbol-nearest-point.
;;     4. symbol-nearest-point-with-bounds: Use symbol-at-point-with-bounds, not
;;        bounds-of-thing-at-point.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:

(require 'thingatpt)

;;;;;;;;;;;;;;;;;;;;;;

;;;###autoload
(defgroup thing-at-point-plus nil
  "Enhancements to `thingatpt.el'."
  :prefix "tap-" :group 'applications :group 'development :group 'help
  :link `(url-link :tag "Send Bug Report"
          ,(concat "mailto:" "drew.adams" "@" "oracle" ".com?subject=\
Thingatpt+ bug: \
&body=Describe bug here, starting with `emacs -Q'.  \
Don't forget to mention your Emacs and library versions."))
  :link '(url-link :tag "Download" "http://www.emacswiki.org/thingatpt+.el")
  :link '(url-link :tag "Description" "http://www.emacswiki.org/ThingAtPointPlus")
  :link '(emacs-commentary-link :tag "Commentary" "thingatpt+"))

;;;###autoload
(defcustom tap-near-point-x-distance 50
  "*Maximum number of characters from point to search, left and right.
Used by functions that provide default text for minibuffer input.
Some functions might ignore or override this setting temporarily."
  :type 'integer :group 'thing-at-point-plus :group 'minibuffer)

;;;###autoload
(defcustom tap-near-point-y-distance 5
  "*Maximum number of lines from point to search, up and down.
To constrain search to the same line as point, set this to zero.
Used by functions that provide default text for minibuffer input.
Some functions might ignore or override this setting temporarily."
  :type 'integer :group 'thing-at-point-plus :group 'minibuffer)


;; Make these no-ops for Emacs versions that don't have it.  Easier than `fboundp' everywhere.
(unless (fboundp 'constrain-to-field) (defun constrain-to-field (&rest _ignore) (point)))

(unless (fboundp 'field-beginning) (defalias 'field-beginning (symbol-function 'ignore)))
(unless (fboundp 'field-end) (defalias 'field-end (symbol-function 'ignore)))
 
;;; THINGS -----------------------------------------------------------


;; REPLACE ORIGINAL in `thingatpt.el'.
;;
;; 1. Fix Emacs bug #8667 (do not return an empty thing).
;; 2. Add optional argument SYNTAX-TABLE.
;;
;; NOTE: All of the other functions here are based on this function.
;;
(defun tap-bounds-of-thing-at-point (thing &optional syntax-table)
  "Determine the start and end buffer locations for the THING at point.
Return a consp `(START . END)' giving the START and END positions,
where START /= END.  Return nil if no such THING is found.
THING is an entity for which there is a either a corresponding
`forward-'THING operation, or corresponding `beginning-of-'THING and
`end-of-'THING operations.  THING examples include `word', `sentence',
`defun'.
SYNTAX-TABLE is a syntax table to use.
See the commentary of library `thingatpt.el' for how to define a
symbol as a valid THING."
  (if syntax-table
      (let ((buffer-syntax  (syntax-table)))
        (unwind-protect
             (progn (set-syntax-table syntax-table)
                    (tap-bounds-of-thing-at-point-1 thing))
          (set-syntax-table buffer-syntax)))
    (tap-bounds-of-thing-at-point-1 thing)))

;; This is the vanilla `bounds-of-thing-at-point', but with Emacs bugs #8667 and #9300 fixed.
(defun tap-bounds-of-thing-at-point-1 (thing)
  "Helper for `tap-bounds-of-thing-at-point'.
Do everything except handle the optional SYNTAX-TABLE arg."
  (if (get thing 'bounds-of-thing-at-point)
      (funcall (get thing 'bounds-of-thing-at-point))
    (let ((orig  (point)))
      (condition-case nil
          (save-excursion
            ;; Try moving forward, then back.
            (funcall (or (get thing 'end-op) ; Move to end.
                         (lambda () (forward-thing thing 1))))
            (constrain-to-field nil orig)
            (funcall (or (get thing 'beginning-op) ; Move to beg.
                         (lambda () (forward-thing thing -1))))
            (constrain-to-field nil orig)
            (let ((beg  (point)))
              (if (<= beg orig)
                  ;; If that brings us all the way back to ORIG,
                  ;; it worked.  But END may not be the real end.
                  ;; So find the real end that corresponds to BEG.
                  ;; FIXME: in which cases can `real-end' differ from `end'?
                  (let ((real-end  (progn (funcall
                                           (or (get thing 'end-op)
                                               (lambda () (forward-thing thing 1))))
                                          (constrain-to-field nil orig)
                                          (point))))
                    (and (< orig real-end)  (< beg real-end)
                         (cons beg real-end)))
                (goto-char orig)
                ;; Try a second time, moving first backward and then forward,
                ;; so that we can find a thing that ends at ORIG.
                (funcall (or (get thing 'beginning-op) ; Move to beg.
                             (lambda () (forward-thing thing -1))))
                (constrain-to-field nil orig)
                (funcall (or (get thing 'end-op) ; Move to end.
                             (lambda () (forward-thing thing 1))))
                (constrain-to-field nil orig)
                (let ((end       (point))
                      (real-beg  (progn (funcall
                                         (or (get thing 'beginning-op)
                                             (lambda () (forward-thing thing -1))))
                                        (constrain-to-field nil orig)
                                        (point))))
                  (and (<= real-beg orig)  (< orig end)  (< real-beg end)
                       (cons real-beg end))))))
        (error nil)))))

(defun tap-thing-at-point-with-bounds (thing &optional syntax-table)
  "Return (THING START . END) with START and END of THING.
Return nil if no such THING is found.
THING is the `tap-thing-at-point' (which see).
START and END are the car and cdr of the value returned by
 `tap-bounds-of-thing-at-point'.
SYNTAX-TABLE is a syntax table to use."
  (let ((bounds  (tap-bounds-of-thing-at-point thing syntax-table)))
    (and bounds  (cons (buffer-substring (car bounds) (cdr bounds)) bounds))))


;; REPLACE ORIGINAL in `thingatpt.el'.
;;
;; Add optional argument SYNTAX-TABLE.
;;
(defun tap-thing-at-point (thing &optional syntax-table)
  "Return the THING at point.
This is typically a string, but it can be anything, depending on
whether THING has property `thing-at-point'.  For the case where it
does not, see `tap-bounds-of-thing-at-point'.

Return nil if no such THING is found.

SYNTAX-TABLE is a syntax table to use."
  (if (get thing 'thing-at-point)
      (let ((opoint  (point)))
        (prog1 (funcall (get thing 'thing-at-point))
          (constrain-to-field nil opoint)))
    (let ((bounds  (tap-bounds-of-thing-at-point thing syntax-table)))
      (and bounds  (buffer-substring (car bounds) (cdr bounds))))))

(defun tap-thing-nearest-point-with-bounds (thing &optional syntax-table)
  "Return (THING START . END) with START and END of THING.
Return nil if no such THING is found.
THING is the `tap-thing-nearest-point' (which see).
SYNTAX-TABLE is a syntax table to use."
  (tap-thing/form-nearest-point-with-bounds #'tap-thing-at-point-with-bounds
                                             thing nil syntax-table))

(defun tap-thing/form-nearest-point-with-bounds (fn thing pred syntax-table)
  "Thing or form nearest point, with bounds.
FN is a function returning a thing or form at point, with bounds.
Other arguments are as for `tap-thing-nearest-point-with-bounds'."
  (let ((opoint  (point)))
    (let ((f-or-t+bds  (prog1 (if pred
                                  (funcall fn thing pred syntax-table)
                                (funcall fn thing syntax-table))
                         (constrain-to-field nil opoint)))
          (ind1        0)
          (ind2        0)
          (updown      1)
          (bobp        (or (eq (field-beginning nil) (point))  (bobp)))
          (eobp        (or (eq (field-end nil) (point))        (eobp)))
          (bolp        (or (eq (field-beginning nil) (point))  (bolp)))
          (eolp        (or (eq (field-end nil) (point))        (eolp)))
          (max-x       (abs tap-near-point-x-distance))
          (max-y       (if (zerop (save-excursion
                                    (goto-char (point-max))
                                    (prog1 (forward-line -1)
                                      (constrain-to-field nil opoint))))
                           (abs tap-near-point-y-distance)
                         1)))           ; Only one line.
      ;; IND2: Loop over lines (alternately up and down).
      (while (and (<= ind2 max-y)  (not f-or-t+bds)  (not (and bobp  eobp)))
        (setq updown  (- updown))       ; Switch directions up/down (1/-1).
        (save-excursion
          (when (> max-y 1)             ; Skip this if only one line.
            (condition-case ()
                (prog1 (previous-line (* updown ind2)) ; 0, 1, -1, 2, -2, ...
                  (constrain-to-field nil opoint))
              (beginning-of-buffer (setq bobp  t))
              (end-of-buffer (setq eobp  t))
              (error nil)))
          ;; Do not try to go beyond buffer or field limit.
          (unless (or (and bobp  (> (* updown ind2) 0)) ; But do it for ind2=0.
                      (and eobp  (< updown 0)))
            (setq f-or-t+bds  (prog1 (if pred
                                         (funcall fn thing pred syntax-table)
                                       (funcall fn thing syntax-table))
                                (constrain-to-field nil opoint))
                  bolp        (or (eq (field-beginning nil) (point))  (bolp))
                  eolp        (or (eq (field-end nil) (point))        (eolp))
                  ind1        0)
            (save-excursion
              ;; IND1: Loop over chars in same line (alternately left and right),
              ;; until either found thing/form or both line limits reached.
              (while (and (not (and bolp eolp))  (<= ind1 max-x)  (not f-or-t+bds))
                (unless bolp (save-excursion ; Left.
                               (setq bolp        (prog1 (forward-char-same-line (- ind1))
                                                   (constrain-to-field nil opoint))
                                     f-or-t+bds  (if pred
                                                     (funcall fn thing pred syntax-table)
                                                   (funcall fn thing syntax-table)))
                               (constrain-to-field nil opoint)))
                (unless (or f-or-t+bds  eolp) ; Right.
                  (save-excursion
                    (setq eolp        (prog1 (forward-char-same-line ind1)
                                        (constrain-to-field nil opoint))
                          f-or-t+bds  (if pred
                                          (funcall fn thing pred syntax-table)
                                        (funcall fn thing syntax-table)))
                    (constrain-to-field nil opoint)))
                (setq ind1  (1+ ind1)))
              (setq bobp  (or (eq (field-beginning nil) (point))
                              (bobp)
                              (< max-y 2)) ; If only one line, fake `bobp'.
                    eobp  (or (eq (field-end nil) (point))
                              (eobp)
                              (< max-y 2)))))) ; If only one line, fake `eobp'.
        ;; Increase search line distance every second time (once up, once down).
        (when (and (> max-y 1)  (or (< updown 0)  (zerop ind2))) ; 0,1,1,2,2...
          (setq ind2  (1+ ind2))))
      f-or-t+bds)))

(defun tap-bounds-of-thing-nearest-point (thing &optional syntax-table)
  "Return (START . END) with START and END of  type THING.
Return nil if no such THING is found.  See `tap-thing-nearest-point'.
SYNTAX-TABLE is a syntax table to use."
  (let ((thing+bds  (tap-thing-nearest-point-with-bounds thing syntax-table)))
    (and thing+bds
         (cdr thing+bds))))

(defun tap-thing-nearest-point (thing &optional syntax-table)
  "Return the THING nearest to the cursor, if any, else return nil.
\"Nearest\" to point is determined as follows:
  The nearest THING on the same line is returned, if there is any.
      Between two THINGs equidistant from point on the same line, the
      leftmost is considered nearer.
  Otherwise, neighboring lines are tried in sequence:
  previous, next, 2nd previous, 2nd next, 3rd previous, 3rd next, etc.
      This means that between two THINGs equidistant from point in
      lines above and below it, the THING in the line above point
      (previous Nth) is considered nearer to it.

A related function:
  `tap-thing-at-point' returns the THING under the cursor,
    or nil if none.

SYNTAX-TABLE is a syntax table to use."
  (let ((thing+bds  (tap-thing-nearest-point-with-bounds thing syntax-table)))
    (and thing+bds
         (car thing+bds))))
 
;;; FORMS, SEXPS -----------------------------------------------------

(defun tap-form-at-point-with-bounds (&optional thing pred syntax-table)
  "Return (FORM START . END), START and END the char positions of FORM.
FORM is the `tap-form-at-point'.  Return nil if no form is found.

Optional arguments:
  THING is the kind of form desired (default: `sexp').
  PRED is a predicate that THING must satisfy to qualify.
  SYNTAX-TABLE is a syntax table to use."
  (condition-case nil                   ; E.g. error if tries to read `.'.
      (let* ((thing+bds  (tap-thing-at-point-with-bounds (or thing  'sexp) syntax-table))
             (bounds     (cdr thing+bds))
             (sexp       (and bounds  (read-from-whole-string (car thing+bds)))))
        (and bounds  (or (not pred)  (funcall pred sexp))
             (cons sexp bounds)))
    (error nil)))

;; Essentially an alias for the default case.
(defun tap-sexp-at-point-with-bounds (&optional pred syntax-table)
  "Return (SEXP START . END), boundaries of the `sexp-at-point'.
Return nil if no sexp is found.
Optional args are the same as for `tap-form-at-point-with-bounds'."
  (tap-form-at-point-with-bounds 'sexp pred syntax-table))

(defun tap-bounds-of-form-at-point (&optional thing pred syntax-table)
  "Return (START . END), with START and END of `tap-form-at-point'.

Optional arguments:
  THING is the kind of form desired (default: `sexp').
  PRED is a predicate that THING must satisfy to qualify.
  SYNTAX-TABLE is a syntax table to use."
  (let ((form+bds  (tap-form-at-point-with-bounds thing pred syntax-table)))
    (and form+bds
         (cdr form+bds))))

;; Essentially an alias for the default case.
(defun tap-bounds-of-sexp-at-point (&optional pred syntax-table)
  "Return (START . END), with START and END of `sexp-at-point'.
Optional args are the same as for `tap-bounds-of-form-at-point'."
  (tap-bounds-of-form-at-point 'sexp pred syntax-table))


;; REPLACE ORIGINAL in `thingatpt.el'.
;;
;; Add optional argument SYNTAX-TABLE.
;;
(defun tap-form-at-point (&optional thing pred syntax-table)
  "Return the form nearest to the cursor, if any, else return nil.
The form is a Lisp entity, not necessarily a string.
Optional arguments:
  THING is the kind of form desired (default: `sexp').
  PRED is a predicate that THING must satisfy to qualify.
  SYNTAX-TABLE is a syntax table to use."
  (let ((sexp  (condition-case nil
                   (read-from-whole-string
                    (tap-thing-at-point (or thing  'sexp) syntax-table))
                 (error nil))))
    (and (or (not pred)  (funcall pred sexp))
         sexp)))

(defun tap-form-nearest-point-with-bounds (&optional thing pred syntax-table)
  "Return (FORM START . END), START and END the char positions of FORM.
FORM is the `tap-form-nearest-point'.
Return nil if no such form is found.

Optional arguments:
  THING is the kind of form desired (default: `sexp').
  PRED is a predicate that THING must satisfy to qualify.
  SYNTAX-TABLE is a syntax table to use."
  (tap-thing/form-nearest-point-with-bounds #'tap-form-at-point-with-bounds
                                             thing pred syntax-table))

;; Essentially an alias for the default case.
(defun tap-sexp-nearest-point-with-bounds (&optional pred syntax-table)
  "Return (SEXP START . END), boundaries of the `tap-sexp-nearest-point'.
Return nil if no sexp is found.
Optional args are the same as for `tap-form-nearest-point-with-bounds'."
  (tap-form-nearest-point-with-bounds 'sexp pred syntax-table))

(defun tap-bounds-of-form-nearest-point (&optional thing pred syntax-table)
  "Return (START . END) with START and END of `tap-form-nearest-point'.
Return nil if no such form is found.

Optional arguments:
  THING is the kind of form desired (default: `sexp').
  PRED is a predicate that THING must satisfy to qualify.
  SYNTAX-TABLE is a syntax table to use."
  (let ((form+bds  (tap-form-nearest-point-with-bounds thing pred syntax-table)))
    (and form+bds
         (cdr form+bds))))

;; Essentially an alias for the default case.
(defun tap-bounds-of-sexp-nearest-point (&optional pred syntax-table)
  "Return (START . END), with START and END of `tap-sexp-nearest-point'.
Optional args are the same as for `tap-bounds-of-form-nearest-point'."
  (tap-bounds-of-form-nearest-point 'sexp pred syntax-table))

(defun tap-form-nearest-point (&optional thing pred syntax-table)
  "Return the form nearest to the cursor, if any, else return nil.
\"Nearest\" to point is determined as for `tap-thing-nearest-point'.

Optional arguments:
  THING is the kind of form desired (default: `sexp').
  PRED is a predicate that THING must satisfy to qualify.
  SYNTAX-TABLE is a syntax table to use."
  (let ((form+bds  (tap-form-nearest-point-with-bounds thing pred syntax-table)))
    (and form+bds
         (car form+bds))))
 
;;; SYMBOLS ----------------------------------------------------------

(defun tap-symbol-at-point-with-bounds (&optional non-nil)
  "Return (SYMBOL START . END) with START and END of SYMBOL.
Return nil if no such Emacs Lisp symbol is found.
SYMBOL is the `tap-symbol-at-point' (which see).
If optional arg NON-NIL is non-nil, then the nearest symbol other
  than `nil' is sought."
  (tap-form-at-point-with-bounds
   'symbol (if non-nil (lambda (sym) (and sym  (symbolp sym))) 'symbolp)
   emacs-lisp-mode-syntax-table))

(defun tap-bounds-of-symbol-at-point (&optional non-nil)
  "Return (START . END) with START and END of `tap-symbol-at-point'.
If optional arg NON-NIL is non-nil, then the nearest symbol other
  than `nil' is sought."
  (let ((symb+bds  (tap-symbol-at-point-with-bounds non-nil)))
    (and symb+bds
         (cdr symb+bds))))


;; REPLACE ORIGINAL in `thingatpt.el':
;;
;; Original defn: (defun symbol-at-point () (form-at-point 'sexp 'symbolp))
;; With point on toto in "`toto'" (in Emacs Lisp mode), that definition
;; returned `toto, not toto.  With point on toto in "`toto'," (note comma),
;; that definition returned nil.  The definition here returns toto in both
;; of these cases.
;;
;; Note also that (form-at-point 'symbol) would not be a satisfactory
;; definition either, because it does not ensure that the symbol syntax
;; really represents an interned symbol.
(defun tap-symbol-at-point (&optional non-nil)
  "Return the Emacs Lisp symbol under the cursor, or nil if none.
If optional arg NON-NIL is non-nil, then the nearest symbol other
  than `nil' is sought.

Some related functions:
 `tap-symbol-nearest-point' returns the symbol nearest the cursor,
   or nil.
 `tap-symbol-name-nearest-point' returns the name of
   `tap-symbol-nearest-point' as a string, or \"\" if none.
 `symbol-name-before-point' returns the string naming the symbol at or
   before the cursor (even if it is on a previous line) or \"\" if none.
 `word-before-point' returns the word (a string) at or before cursor.
Note that these last three functions return strings, not symbols."
  ;; Needs to satisfy both: 1) symbol syntax, 2) be interned.
  (tap-form-at-point
   'symbol (if non-nil (lambda (sym) (and sym  (symbolp sym))) 'symbolp)
   emacs-lisp-mode-syntax-table))

(defun tap-symbol-nearest-point-with-bounds (&optional non-nil)
  "Return (SYMBOL START . END) with START and END of SYMBOL.
SYMBOL is the `tap-symbol-nearest-point' (which see).
If optional arg NON-NIL is non-nil, then the nearest symbol other
  than `nil' is sought.
Return nil if no such Emacs Lisp symbol is found."
  (tap-form-nearest-point-with-bounds
   'symbol (if non-nil (lambda (sym) (and sym  (symbolp sym))) 'symbolp)
   emacs-lisp-mode-syntax-table))

(defun tap-bounds-of-symbol-nearest-point (&optional non-nil)
  "Return (START . END) with START and END of `tap-symbol-nearest-point'.
If optional arg NON-NIL is non-nil, then the nearest symbol other
  than `nil' is sought."
  (let ((symb+bds  (tap-symbol-nearest-point-with-bounds non-nil)))
    (and symb+bds
         (cdr symb+bds))))

(defun tap-symbol-nearest-point (&optional non-nil)
  "Return the Emacs Lisp symbol nearest the cursor, or nil if none.
\"Nearest\" to point is determined as for `tap-thing-nearest-point'.
If optional arg NON-NIL is non-nil, then the nearest symbol other
  than `nil' is sought.

Some related functions:
 `tap-symbol-at-point' returns the symbol under the cursor,
   or nil if none.
 `tap-symbol-name-nearest-point' returns the name of
   `tap-symbol-nearest-point' as a string,
   or \"\" if none.
 `symbol-name-before-point' returns the string naming the symbol at or
   before the cursor (even if it is on a previous line),
   or \"\" if none.
 `word-at-point' returns the word at point,
   or nil if none.
 `tap-word-nearest-point' returns the word nearest point,
   or \"\" if none.
 `word-before-point' returns the word at or before the cursor as a string.
Note that these last three functions return strings, not symbols."
  (let ((symb+bds  (tap-symbol-nearest-point-with-bounds non-nil)))
    (and symb+bds
         (car symb+bds))))

(defun tap-non-nil-symbol-nearest-point ()
  "Return the Emacs Lisp symbol other than `nil' nearest the cursor.
Return nil if none is found.
\"Nearest\" to point is determined as for `tap-thing-nearest-point'.

Some related functions:
 `tap-symbol-at-point' returns the symbol under the cursor,
   or nil if none.
 `tap-symbol-name-nearest-point' returns the name of
   `tap-symbol-nearest-point' as a string,
   or \"\" if none.
 `symbol-name-before-point' returns the string naming the symbol at or
   before the cursor (even if it is on a previous line),
   or \"\" if none.
 `word-at-point' returns the word at point,
   or nil if none.
 `word-nearest-point' returns the word nearest point,
   or \"\" if none.
 `word-before-point' returns the word at or before the cursor as a string.
Note that these last three functions return strings, not symbols."
  (let ((symb+bds  (tap-symbol-nearest-point-with-bounds t)))
    (and symb+bds
         (car symb+bds))))
 
;;; LISTS ------------------------------------------------------------

(defun tap-list-at/nearest-point-with-bounds (at/near &optional up unquotedp)
  "Helper for `tap-list-at-point-with-bounds' and similar functions.
AT/NEAR is a function called to grab the initial list and its bounds.
UP (default: 0) is the number of list levels to go up to start with.
Non-nil UNQUOTEDP means remove the car if it is `quote' or
 `backquote-backquote-symbol'.
Return (LIST START . END) with START and END of the non-empty LIST.
Return nil if no non-empty list is found."
  (save-excursion
    (unless (eq at/near 'tap-sexp-at-point-with-bounds)
      (cond ((looking-at "\\s-*\\s(") (skip-syntax-forward "-"))
            ((looking-at "\\s)\\s-*") (skip-syntax-backward "-"))))
    (let ((sexp+bnds  (funcall at/near)))
      (condition-case nil               ; Handle an `up-list' error.
          (progn
            (when up
              (up-list (- up))
              (setq sexp+bnds  (tap-sexp-at-point-with-bounds)))
            (while (or (not (consp (car sexp+bnds)))
                       (and (memq (caar sexp+bnds) (list backquote-backquote-symbol 'quote))
                            (not (listp (cadr (car sexp+bnds))))))
              (up-list -1)
              (setq sexp+bnds  (tap-sexp-at-point-with-bounds)))
            (when (and unquotedp  (consp (car sexp+bnds))
                       (memq (caar sexp+bnds) (list backquote-backquote-symbol 'quote)))
              (cond ((eq 'quote (caar sexp+bnds))
                     (setq sexp+bnds  (cons (cadr (car sexp+bnds))
                                            (cons (+ 5 (cadr sexp+bnds)) (cddr sexp+bnds)))))
                    ((eq backquote-backquote-symbol (caar sexp+bnds))
                     (setq sexp+bnds  (cons (cadr (car sexp+bnds))
                                            (cons (+ 1 (cadr sexp+bnds)) (cddr sexp+bnds)))))))

            (while (not (consp (car sexp+bnds)))
              (up-list -1)
              (setq sexp+bnds  (tap-sexp-at-point-with-bounds))))
        (error (setq sexp+bnds  nil)))
      sexp+bnds)))

(defun tap-list-at-point-with-bounds (&optional up unquotedp)
  "Return (LIST START . END), boundaries of the `tap-list-at-point'.
Return nil if no non-empty list is found.
UP (default: 0) is the number of list levels to go up to start with.
Non-nil UNQUOTEDP means remove the car if it is `quote' or
 `backquote-backquote-symbol'."
  (tap-list-at/nearest-point-with-bounds 'tap-sexp-at-point-with-bounds up unquotedp))

(defun tap-list-nearest-point-with-bounds (&optional up unquotedp)
  "Return (LIST START . END), boundaries of the `tap-list-nearest-point'.
Return nil if no non-empty list is found.
UP (default: 0) is the number of list levels to go up to start with.
Non-nil UNQUOTEDP means remove the car if it is `quote' or
 `backquote-backquote-symbol'."
  (tap-list-at/nearest-point-with-bounds 'tap-sexp-nearest-point-with-bounds up unquotedp))


(put 'list 'bounds-of-thing-at-point 'tap-bounds-of-list-at-point)

(defun tap-bounds-of-list-at-point (&optional up unquotedp)
  "Return (START . END), boundaries of `tap-list-at-point'.
Return nil if no non-empty list is found.
UP (default: 0) is the number of list levels to go up to start with.
Non-nil UNQUOTEDP means remove the car if it is `quote' or
 `backquote-backquote-symbol'."
  (let ((thing+bds  (tap-list-at-point-with-bounds up unquotedp)))
    (and thing+bds
         (cdr thing+bds))))

(defun tap-bounds-of-list-nearest-point (&optional up unquotedp)
  "Return (START . END), boundaries of the `tap-list-nearest-point'.
Return nil if no non-empty list is found.
UP (default: 0) is the number of list levels to go up to start with.
Non-nil UNQUOTEDP means remove the car if it is `quote' or
 `backquote-backquote-symbol'."
  (let ((thing+bds  (tap-list-nearest-point-with-bounds up unquotedp)))
    (and thing+bds
         (cdr thing+bds))))


(put 'list 'thing-at-point 'tap-list-at-point)


;; REPLACE ORIGINAL defined in `thingatpt.el'.
;;
;; 1. Added optional arg UP.
;; 2. Better, consistent behavior.
;; 3. Let `(tap-)bounds-of-thing-at-point' do its job.
;;
(defun tap-list-at-point (&optional up)
  "Return the non-nil list at point, or nil if none.
If inside a list, return the enclosing list.

UP (default: 0) is the number of list levels to go up to start with.

Note: If point is inside a string that is inside a list:
 This can sometimes return nil.
 This can sometimes return an incorrect list value if the string or
 nearby strings contain parens.
 (These are limitations of function `up-list'.)"
  (let ((list+bds  (tap-list-at-point-with-bounds up)))
    (and list+bds
         (car list+bds))))


(put 'unquoted-list 'thing-at-point 'tap-unquoted-list-at-point)

(defun tap-unquoted-list-at-point (&optional up)
  "Return the non-nil list at point, or nil if none.
Same as `tap-list-at-point', but removes the car if it is `quote' or
 `backquote-backquote-symbol' (\`).
UP (default: 0) is the number of list levels to go up to start with."
  (let ((list+bds  (tap-list-at-point-with-bounds up 'UNQUOTED)))
    (and list+bds
         (car list+bds))))

;;; This simple definition is nowhere near as good as the one below.
;;;
;;; (defun tap-list-nearest-point (&optional syntax-table)
;;;   "Return the list nearest to point, if any, else nil.
;;; This does not distinguish between finding no list and finding
;;; the empty list.  \"Nearest\" to point is determined as for
;;; `tap-thing-nearest-point'.
;;; SYNTAX-TABLE is a syntax table to use."
;;;   (tap-form-nearest-point 'list 'listp syntax-table))

(defun tap-list-nearest-point (&optional up)
  "Return the non-nil list nearest point, or nil if none.
Same as `tap-list-at-point', but returns the nearest list.
UP (default: 0) is the number of list levels to go up to start with."
  (let ((list+bds  (tap-list-nearest-point-with-bounds up)))
    (and list+bds
         (car list+bds))))

(defun tap-unquoted-list-nearest-point (&optional up)
  "Return the non-nil list nearest point, or nil if none.
UP (default: 0) is the number of list levels to go up to start with.
Same as `tap-list-nearest-point', but removes the car if it is
`quote' or `backquote-backquote-symbol' (\`)."
  (let ((list+bds  (tap-list-nearest-point-with-bounds up 'UNQUOTED)))
    (and list+bds
         (car list+bds))))

;;; $$$$$$
;;; (defun tap-list-at/nearest-point (at/near &optional up unquotedp)
;;;   "Helper for `tap-list-at-point', `tap-list-nearest-point' and similar functions.
;;; AT/NEAR is a function that is called to grab the initial sexp.
;;; UP (default: 0) is the number of list levels to go up to start with..
;;; Non-nil UNQUOTEDP means remove the car if it is `quote' or
;;;  `backquote-backquote-symbol'."
;;;   (save-excursion
;;;     (cond ((looking-at "\\s-*\\s(") (skip-syntax-forward "-"))
;;;           ((looking-at "\\s)\\s-*") (skip-syntax-backward "-")))
;;;     (let ((sexp  (funcall at/near)))
;;;       (condition-case nil               ; Handle an `up-list' error.
;;;           (progn (when up (up-list (- up)) (setq sexp  (sexp-at-point)))
;;;                  (while (not (listp sexp)) (up-list -1) (setq sexp  (sexp-at-point)))
;;;                  (when (and unquotedp (consp sexp)
;;;                             (memq (car sexp) (list backquote-backquote-symbol 'quote)))
;;;                    (setq sexp  (cadr sexp)))
;;;                  (while (not (listp sexp)) (up-list -1) (setq sexp  (sexp-at-point))))
;;;         (error (setq sexp  nil)))
;;;       sexp)))


;; The following functions return a string, not a list.
;; They can be useful to pull a sexp into minibuffer.

(defun tap-list-nearest-point-as-string (&optional up)
  "Return a string of the non-nil list nearest point, or \"\" if none.
If not \"\", the list in the string is what is returned by
 `tap-list-nearest-point'.
UP (default: 0) is the number of list levels to go up to start with."
  (let ((list+bds  (tap-list-nearest-point-with-bounds up)))
    (if list+bds (format "%s" (car list+bds)) "")))

(defun tap-unquoted-list-nearest-point-as-string (&optional up)
  "Return a string of the non-nil list nearest point, or \"\" if none.
If not \"\", the list in the string is what is returned by
 `tap-unquoted-list-nearest-point'.
UP (default: 0) is the number of list levels to go up to start with."
  (let ((list+bds  (tap-list-nearest-point-with-bounds up 'UNQUOTED)))
    (if list+bds (format "%s" (car list+bds)) "")))
 
;;; MISC: SYMBOL NAMES, WORDS, SENTENCES, etc. -----------------------


(put 'non-nil-symbol-name 'thing-at-point 'tap-non-nil-symbol-name-at-point)

(defun tap-non-nil-symbol-name-at-point ()
  "String naming the Emacs Lisp symbol at point, or \"\" if none."
  (let ((symb+bds  (tap-symbol-at-point-with-bounds t)))
    (if symb+bds (symbol-name (car symb+bds)) "")))

(defun tap-symbol-name-nearest-point ()
  "String naming the Emacs Lisp symbol nearest point, or \"\" if none.
\"Nearest\" to point is determined as for `tap-thing-nearest-point'."
  ;; We do it this way to be able to pick symbol `nil' (name "nil").
  (let ((symb+bds  (tap-symbol-nearest-point-with-bounds)))
    (if symb+bds (symbol-name (car symb+bds)) "")))

(defun tap-non-nil-symbol-name-nearest-point ()
  "String naming the Emacs Lisp symbol nearest point, or \"\" if none.
Returns the name of the nearest symbol other than `nil'.
\"Nearest\" to point is determined as for `tap-thing-nearest-point'."
  (let ((symb+bds  (tap-symbol-nearest-point-with-bounds t)))
    (if symb+bds (symbol-name (car symb+bds)) "")))

(defun tap-region-or-non-nil-symbol-name-nearest-point (&optional quote-it-p)
  "Return non-empty active region or symbol nearest point.
Non-nil QUOTE-IT-P means wrap the region text in double-quotes (\").
The name of the nearest symbol other than `nil' is used.
See `tap-non-nil-symbol-name-nearest-point'."
  (if (and transient-mark-mode mark-active
           (not (eq (region-beginning) (region-end))))
      (let ((region-text  (buffer-substring-no-properties (region-beginning) (region-end))))
        (if quote-it-p
            (concat "\"" region-text "\"")
          region-text))
    (tap-non-nil-symbol-name-nearest-point)))

(defun word-nearest-point (&optional syntax-table)
  "Return the word (a string) nearest to point, if any, else \"\".
\"Nearest\" to point is determined as for `tap-thing-nearest-point'.
SYNTAX-TABLE is a syntax table to use."
  (tap-thing-nearest-point 'word syntax-table))

(defun tap-region-or-word-nearest-point (&optional syntax-table)
  "Return non-empty active region or word nearest point.
See `word-nearest-point'."
  (if (and transient-mark-mode mark-active
           (not (eq (region-beginning) (region-end))))
      (buffer-substring-no-properties (region-beginning) (region-end))
    (word-nearest-point syntax-table)))


(put 'region-or-word 'thing-at-point 'tap-region-or-word-at-point)

(defun tap-region-or-word-at-point ()
  "Return non-empty active region or word at point."
  (if (and transient-mark-mode mark-active
           (not (eq (region-beginning) (region-end))))
      (buffer-substring-no-properties (region-beginning) (region-end))
    (current-word)))

(defun tap-sentence-nearest-point (&optional syntax-table)
  "Return the sentence (a string) nearest to point, if any, else \"\".
\"Nearest\" to point is determined as for `tap-thing-nearest-point'.
SYNTAX-TABLE is a syntax table to use."
  (tap-thing-nearest-point 'sentence syntax-table))

(defun tap-sexp-nearest-point (&optional syntax-table)
  "Return the sexp (a string) nearest to point, if any, else \"\".
\"Nearest\" to point is determined as for `tap-thing-nearest-point'.
SYNTAX-TABLE is a syntax table to use."
  (tap-form-nearest-point 'sexp syntax-table))

(defun tap-number-nearest-point (&optional syntax-table)
  "Return the number nearest to point, if any, else nil.
\"Nearest\" to point is determined as for `tap-thing-nearest-point'.
SYNTAX-TABLE is a syntax table to use."
  (tap-form-nearest-point 'sexp 'numberp syntax-table))


;; `defun' type
(unless (get 'defun 'beginning-op)
  (put 'defun 'beginning-op 'beginning-of-defun))
(unless (get 'defun 'end-op)
  (put 'defun 'end-op 'end-of-defun))
(unless (get 'defun 'forward-op)
  (put 'defun 'forward-op 'end-of-defun))

;;; `number-at-point' returns the char value when point is on char syntax.
;;; E.g., when on ?A it returns 65 (not nil); when on ?\A-\^@ it returns 4194304.
;;; So we add these functions, which do what you would normally expect.

(put 'decimal-number 'thing-at-point 'tap-number-at-point-decimal)
(put 'decimal-number 'bounds-of-thing-at-point
     (lambda () (and (tap-number-at-point-decimal)
                     (tap-bounds-of-thing-at-point 'sexp))))

(defalias 'decimal-number-at-point 'tap-number-at-point-decimal)
(defun tap-number-at-point-decimal ()
  "Return the number represented by the decimal numeral at point.
Return nil if none is found."
  (let ((strg  (tap-thing-at-point 'sexp)))
    (and (stringp strg)        
         (if (fboundp 'string-match-p)
             (string-match-p "\\`[0-9]+\\'" strg)
           (string-match "\\`[0-9]+\\'" strg))
         (string-to-number strg))))


(put 'hex-number 'thing-at-point 'tap-number-at-point-hex)
(put 'hex-number 'bounds-of-thing-at-point
     (lambda () (and (tap-number-at-point-hex)
                     (tap-bounds-of-thing-at-point 'sexp))))

(defalias 'hex-number-at-point 'tap-number-at-point-hex)
(defun tap-number-at-point-hex ()
  "Return the number represented by the hex numeral at point.
Return nil if none is found."
  (let ((strg  (tap-thing-at-point 'sexp)))
    (and (stringp strg)
         (if (fboundp 'string-match-p)
             (string-match-p "\\`[0-9a-fA-F]+\\'" strg)
           (string-match "\\`[0-9a-fA-F]+\\'" strg))
         (string-to-number strg 16))))


;; Make these work for vanilla `number' too.
(put 'number 'thing-at-point 'number-at-point)
(put 'number 'bounds-of-thing-at-point
     (lambda () (and (number-at-point)
                     (tap-bounds-of-thing-at-point 'sexp))))


(when (fboundp 'syntax-ppss)            ; Based on `comint-extract-string'.

  (put 'string 'bounds-of-thing-at-point 'tap-bounds-of-string-at-point)

  (defun tap-bounds-of-string-at-point ()
    "Determine the start and end buffer locations for the string at point.
Return a consp `(START . END)' giving the START and END positions.
Return nil if no such string is found."
    (save-excursion
      (let ((syntax  (syntax-ppss))
            beg end)
        (and (nth 3 syntax)
             (condition-case ()
                 (setq beg  (1+ (nth 8 syntax))
                       end  (progn (goto-char (nth 8 syntax)) (forward-sexp) (1- (point))))
               (error nil))
             (cons beg end)))))

  (put 'string 'thing-at-point 'tap-string-at-point)

  (defun tap-string-at-point ()
    "Return the string at point."
    (let ((bounds  (tap-bounds-of-string-at-point)))
      (and bounds
           (buffer-substring (car bounds) (cdr bounds)))))

  (defun tap-string-nearest-point ()
    "Return the string nearest point."
    (tap-thing-nearest-point 'string)))
 
;;; COMMANDS ---------------------------------------------------------

(defun tap-redefine-std-fns ()
  "Redefine some standard `thingatpt.el' functions, to fix them.
The standard functions replaced are these:
 `bounds-of-thing-at-point' - Accept optional arg SYNTAX-TABLE.
 `form-at-point'            - Accept optional arg SYNTAX-TABLE.
 `list-at-point'            - Better behavior.
                              Accept optional arg SYNTAX-TABLE.
 `symbol-at-point'          - Accept optional arg NON-NIL.
 `thing-at-point'           - Accept optional arg SYNTAX-TABLE.
 `thing-at-point-bounds-of-list-at-point'
                            - Better behavior.  Accept optional args
                              UP and UNQUOTEDP."
  (interactive)

  ;; REPLACE ORIGINAL in `thingatpt.el'.
  ;;
  ;; 1. Fix Emacs bug #8667 (do not return an empty thing).
  ;; 2. Add optional argument SYNTAX-TABLE.
  ;;
  ;; NOTE: All of the other functions here are based on this function.
  ;;
  (defalias 'bounds-of-thing-at-point 'tap-bounds-of-thing-at-point)

  ;; REPLACE ORIGINAL in `thingatpt.el'.
  ;;
  ;; Add optional argument SYNTAX-TABLE.
  ;;
  (defalias 'form-at-point 'tap-form-at-point)

  ;; REPLACE ORIGINAL defined in `thingatpt.el'.
  ;;
  ;; 1. Added optional arg UP.
  ;; 2. Better, consistent behavior.
  ;; 3. Let `tap-bounds-of-thing-at-point' do its job.
  ;;
  (defalias 'list-at-point 'tap-list-at-point)

  ;; REPLACE ORIGINAL in `thingatpt.el':
  ;;
  ;; Original defn: (defun symbol-at-point () (form-at-point 'sexp 'symbolp))
  ;; With point on toto in "`toto'" (in Emacs Lisp mode), that definition
  ;; returned `toto, not toto.  With point on toto in "`toto'," (note comma),
  ;; that definition returned nil.  The definition here returns toto in both
  ;; of these cases.
  ;;
  ;; Note also that (form-at-point 'symbol) would not be a satisfactory
  ;; definition either, because it does not ensure that the symbol syntax
  ;; really represents an interned symbol.
  (defalias 'symbol-at-point 'tap-symbol-at-point)

  ;; REPLACE ORIGINAL in `thingatpt.el'.
  ;;
  ;; Add optional argument SYNTAX-TABLE.
  ;;
  (defalias 'thing-at-point 'tap-thing-at-point)

  ;; REPLACE ORIGINAL in `thingatpt.el'.
  ;;
  ;; Better behavior.
  ;; Accept optional args UP and UNQUOTEDP.
  ;;
  (when (fboundp 'thing-at-point-bounds-of-list-at-point)
    (defalias 'thing-at-point-bounds-of-list-at-point 'tap-bounds-of-list-at-point))
  )

(defun tap-define-aliases-wo-prefix ()
  "Provide aliases for `tap-' functions and variables, without prefix."
  (defalias 'bounds-of-form-at-point 'tap-bounds-of-form-at-point)
  (defalias 'bounds-of-form-nearest-point 'tap-bounds-of-form-nearest-point)
  (defalias 'bounds-of-list-nearest-point 'tap-bounds-of-list-nearest-point)
  (defalias 'bounds-of-sexp-at-point 'tap-bounds-of-sexp-at-point)
  (defalias 'bounds-of-sexp-nearest-point 'tap-bounds-of-sexp-nearest-point)
  (defalias 'bounds-of-string-at-point 'tap-bounds-of-string-at-point)
  (defalias 'bounds-of-symbol-at-point 'tap-bounds-of-symbol-at-point)
  (defalias 'bounds-of-symbol-nearest-point 'tap-bounds-of-symbol-nearest-point)
  (defalias 'bounds-of-thing-nearest-point 'tap-bounds-of-thing-nearest-point)
  (defalias 'form-at-point-with-bounds 'tap-form-at-point-with-bounds)
  (defalias 'form-nearest-point 'tap-form-nearest-point)
  (defalias 'form-nearest-point-with-bounds 'tap-form-nearest-point-with-bounds)
  (defalias 'list-at/nearest-point-with-bounds 'tap-list-at/nearest-point-with-bounds)
  (defalias 'list-at-point-with-bounds 'tap-list-at-point-with-bounds)
  (defalias 'list-nearest-point 'tap-list-nearest-point)
  (defalias 'list-nearest-point-with-bounds 'tap-list-nearest-point-with-bounds)
  (defalias 'list-nearest-point-as-string 'tap-list-nearest-point-as-string)
  (defalias 'non-nil-symbol-name-at-point 'tap-non-nil-symbol-name-at-point)
  (defalias 'non-nil-symbol-name-nearest-point 'tap-non-nil-symbol-name-nearest-point)
  (defalias 'non-nil-symbol-nearest-point 'tap-non-nil-symbol-nearest-point)
  (defalias 'number-at-point-decimal 'tap-number-at-point-decimal)
  (defalias 'number-at-point-hex 'tap-number-at-point-hex)
  (defalias 'number-nearest-point 'tap-number-nearest-point)
  (defalias 'region-or-word-at-point 'tap-region-or-word-at-point)
  (defalias 'region-or-word-nearest-point 'tap-region-or-word-nearest-point)
  (defalias 'region-or-non-nil-symbol-name-nearest-point
      'tap-region-or-non-nil-symbol-name-nearest-point)
  (defalias 'sentence-nearest-point 'tap-sentence-nearest-point)
  (defalias 'sexp-at-point-with-bounds 'tap-sexp-at-point-with-bounds)
  (defalias 'sexp-nearest-point 'tap-sexp-nearest-point)
  (defalias 'sexp-nearest-point-with-bounds 'tap-sexp-nearest-point-with-bounds)
  (defalias 'string-at-point 'tap-string-at-point)
  (defalias 'string-nearest-point 'tap-string-nearest-point)
  (defalias 'symbol-at-point-with-bounds 'tap-symbol-at-point-with-bounds)
  (defalias 'symbol-name-nearest-point 'tap-symbol-name-nearest-point)
  (defalias 'symbol-nearest-point 'tap-symbol-nearest-point)
  (defalias 'symbol-nearest-point-with-bounds 'tap-symbol-nearest-point-with-bounds)
  (defalias 'thing-at-point-with-bounds 'tap-thing-at-point-with-bounds)
  (defalias 'thing/form-nearest-point-with-bounds 'tap-thing/form-nearest-point-with-bounds)
  (defalias 'thing-nearest-point 'tap-thing-nearest-point)
  (defalias 'thing-nearest-point-with-bounds 'tap-thing-nearest-point-with-bounds)
  (defalias 'unquoted-list-at-point 'tap-unquoted-list-at-point)
  (defalias 'unquoted-list-nearest-point 'tap-unquoted-list-nearest-point)
  (defalias 'unquoted-list-nearest-point-as-string 'tap-unquoted-list-nearest-point-as-string)
  (defalias 'word-nearest-point 'tap-word-nearest-point)

  (when (fboundp 'defvaralias)          ; Emacs 22+
    (defvaralias 'near-point-x-distance 'tap-near-point-x-distance)
    (defvaralias 'near-point-y-distance 'tap-near-point-y-distance))
  )

;;;###autoload
;; This `intern' is in order to have the symbol, e.g., for `thing-types' in `thing-cmds.el'.
(intern "whitespace-&-newlines")
(defun forward-whitespace-&-newlines (arg)
  "Move forward over contiguous whitespace to non-whitespace.
Unlike `forward-whitespace', this moves over multiple contiguous
newlines."
  (interactive "p")
  (if (natnump arg)
      (re-search-forward "[ \t]+\\|\n+" nil 'move arg)
    (while (< arg 0)
      (when (re-search-backward "[ \t]+\\|\n+" nil 'move)  (skip-chars-backward " \t\n"))
      (setq arg  (1+ arg)))))

;; Copied from `misc-cmds.el'.
(intern "char-same-line") ; To have the symbol, e.g., for `thing-types' in `thing-cmds.el'.
(unless (fboundp 'forward-char-same-line)
  (defun forward-char-same-line (&optional arg)
    "Move forward a max of ARG chars on the same line, or backward if ARG < 0.
Return the signed number of chars moved if /= ARG, else return nil."
    (interactive "p")
    (let* ((start                      (point))
           (fwd-p                      (natnump arg))
           (inhibit-field-text-motion  t) ; Just to be sure, for end-of-line.
           (max                        (save-excursion
                                         (if fwd-p (end-of-line) (beginning-of-line))
                                         (- (point) start))))
      (forward-char (if fwd-p (min max arg) (max max arg)))
      (and (< (abs max) (abs arg))
           max))))

;; Inspired by `find-thing-at-point' at `http://www.emacswiki.org/cgi-bin/wiki/SeanO'.
;;;###autoload
(defun find-fn-or-var-nearest-point (&optional confirmp)
  "Go to the definition of the function or variable nearest the cursor.
With a prefix arg, or if no function or variable is near the cursor,
prompt for the function or variable to find, instead."
  (interactive "P")
  (let* ((symb  (tap-symbol-nearest-point))
         (var   (and (boundp symb)  symb))
         (fn    (or (and (fboundp symb)  symb)
                    (function-called-at-point))))
    (condition-case nil
        (progn (push-mark nil t)
               (cond ((or confirmp  (not (or var fn)))
                      (when (not (or var  fn))
                        (message "Symbol nearest cursor is not a function or variable")
                        (sit-for 1))
                      (call-interactively
                       (if (y-or-n-p "Find function? (n means find variable) ")
                           'find-function
                         'find-variable)))                   
                     (var (find-variable var))
                     ((and (fboundp 'help-C-file-name) ; Emacs 22
                           fn  (subrp (symbol-function fn)))
                      (let ((buf+pos  (find-function-search-for-symbol
                                       fn nil (help-C-file-name (symbol-function fn) 'subr))))
                        (when (car buf+pos) (pop-to-buffer (car buf+pos)))))
                     (fn (find-function fn))
                     (t (call-interactively 'find-function))))
      (quit (pop-mark)))))

;;;;;;;;;;;;;;;;;;;;;;;

(provide 'thingatpt+)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; thingatpt+.el ends here
