;;; ob-graphql.el --- Org-Babel execution backend for GraphQL source blocks  -*- lexical-binding: t; -*-

;; Copyright (C) 2019 Jeremy Dormitzer

;; Author: Jeremy Dormitzer <jeremy.dormitzer@gmail.com>
;; Version: 1.0
;; Package-Requires: ((graphql-mode "20191024.1221") (request "20191211.2051"))
;; URL: https://github.com/jdormit/ob-graphql

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; This package provides an org-babel execution backend for GraphQL code blocks.

;;; Code:

(provide 'ob-graphql)

(require 'graphql-mode)
(require 'json)
(require 'ob-ref)
(require 'request)

;;;###autoload
(defun org-babel-execute:graphql (body params)
  (let* ((url (cdr (assq :url params)))
	 (op-name (cdr (assq :operation params)))
	 (variables (cdr (assq :variables params)))
	 (variables-val (when variables
			  (json-read-from-string (org-babel-ref-resolve variables))))
	 (headers (cdr (assq :headers params)))
	 (graphql-extra-headers
	  (when headers (org-babel-ref-resolve headers)))
         (response (if variables-val
		       (graphql-post-request url body op-name variables-val)
		     (graphql-post-request url body op-name))))
    (with-temp-buffer
      (insert (json-encode (request-response-data response)))
      (json-pretty-print-buffer)
      (buffer-substring (point-min) (point-max)))))

(provide 'ob-graphql)
;;; ob-graphql.el ends here
