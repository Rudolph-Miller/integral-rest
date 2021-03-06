(in-package :cl-user)
(defpackage integral-rest-test.route
  (:use :cl
        :prove
        :integral
        :integral-rest-test.init
        :integral-rest.route))
(in-package :integral-rest-test.route)

(defclass sample ()
  ((id :initarg :id)
   (name :initarg :name))
  (:metaclass <dao-table-class>)
  (:primary-key (id name)))

(plan nil)

(subtest "api-path"
  (is (api-path *user-table*)
      "/api/users"
      "with *api-prefix*.")

  (let ((*api-prefix* nil))
    (is (api-path *user-table*)
        "/users"
        "without *api-prefix*.")))

(subtest "resources-path"
  (is (resources-path *user-table*)
      "/api/users"
      "can return the valid path."))

(subtest "resource-path"
  (is (resource-path *user-table*)
      "/api/users/:id"
      "with one primary-key.")

  (let ((*api-conjunctive-string* "/"))
    (is (resource-path (find-class 'sample))
        "/api/samples/:id/:name"
        "with more than one primary-keys.")))

(subtest "resources-action"
  (with-init-users
    (create-dao 'user :name "Rudalph")
    (subtest ":get"
      (is (funcall (resources-action *user-table* :get) nil)
          "[{\"id\":1,\"name\":\"Rudalph\"}]"
          "can return the valid lambda."))

    (subtest ":post"
      (funcall (resources-action *user-table* :post)
               '(("name" . "Miller")))
      (is (user-name (find-dao 'user 2))
          "Miller"
          "can return the valid lambda."))))

(subtest "resource-action"
  (with-init-users
    (create-dao 'user :name "Rudolph")
    (subtest ":get"
      (is (funcall (resource-action *user-table* :get)
                   '(("id" . "1")))
          "{\"id\":1,\"name\":\"Rudolph\"}"
          "can return the valid lambda."))

    (subtest ":put"
      (funcall (resource-action *user-table* :put)
               '(("id" . "1") ("name" . "Tom")))
      (is (user-name (find-dao 'user 1))
          "Tom"
          "can return the valid lambda."))

    (subtest ":delete"
      (funcall (resource-action *user-table* :delete)
               '(("id" . "1")))
      (ok (not (find-dao 'user 1))
          "can return the valid lambda."))))

(finalize)
