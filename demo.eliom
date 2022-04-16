(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)

[%%shared open Eliom_content.Html.D]

(* drawer / demo welcome page ***********************************************)

let%shared handler myid_o () () =
  Web2_container.page
    ~a:[a_class ["os-page-demo"]]
    myid_o
    [ h2 [%i18n Demo.general_principles]
    ; p [%i18n Demo.intro_1]
    ; p [%i18n Demo.intro_2]
    ; p [%i18n Demo.widget_ot]
    ; p [%i18n Demo.widget_see_drawer]
    ; p [%i18n Demo.widget_feel_free]
    ; p [%i18n Demo.intro_3] ]

let%shared () =
  let registerDemo (module D : Demo_tools.Page) =
    Web2_base.App.register ~service:D.service
      ( Web2_page.Opt.connected_page @@ fun myid_o () () ->
        let%lwt p = D.page () in
        Web2_container.page ~a:[a_class [D.page_class]] myid_o p )
  in
  List.iter registerDemo Demo_tools.demos;
  Web2_base.App.register
    ~service:Web2_services.demo_service
    (Web2_page.Opt.connected_page handler)

(* [detail_page_handler] is not registered in [Demo_tools] because we
   - don't want to show detail pages in the menu. *)
let%shared () =
  let detail_page_handler myid_o page () =
    Web2_container.page
      ~a:[a_class ["os-page-demo-transition"]]
      myid_o
      (Demo_pagetransition.make_detail_page page ())
  in
  Web2_base.App.register
    ~service:Demo_pagetransition.detail_page_service
    (Web2_page.Opt.connected_page detail_page_handler)