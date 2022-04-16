[%%shared
(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)
(* Eliom_cscache demo *)

open Eliom_content.Html.F]

(* Service for this demo *)
let%server service =
  Eliom_service.create
    ~path:(Eliom_service.Path ["demo-cache"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit) ()

(* Make service available on the client *)
let%client service = ~%service
(* Name for demo menu *)
let%shared name () = [%i18n Demo.S.cache]
(* Class for the page containing this demo (for internal use) *)
let%shared page_class = "os-page-demo-cache"

(* Page for this demo *)
let%shared page () =
  Lwt.return
    [ h1 [%i18n Demo.cache_1]
    ; p
        [%i18n
          Demo.cache_2
            ~eliom_cscache:[code [txt "Eliom_cscache"]]
            ~os_user_proxy:[code [txt "Os_user_proxy"]]]
    ; p [%i18n Demo.cache_3 ~eliom_cscache:[code [txt "Eliom_cscache"]]]
    ; p [%i18n Demo.cache_4 ~eliom_cscache:[code [txt "Eliom_cscache"]]] ]
