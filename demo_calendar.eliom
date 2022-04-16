[%%shared
(* This file was generated by Ocsigen Start.
   Feel free to use it, modify it, and redistribute it as you wish. *)
(* Calendar demo *)

open Eliom_content.Html.D]

(* Service for this demo *)
let%server service =
  Eliom_service.create
    ~path:(Eliom_service.Path ["demo-calendar"])
    ~meth:(Eliom_service.Get Eliom_parameter.unit) ()

(* Make service available on the client *)
let%client service = ~%service
(* A reactive value containing the currently selected date *)
(* NOTE: in this example, we define a shared signal on the server side. Its
   original value can only be read when the server generates the first page
   (declaring it `%client`-only would obviously not work) and injected to be
   read-/writable on the (possibly disconnected) client side since any
   *shared value* is injectable; subsequent updates won't be sent to the server.
   Declaring this signal as `%shared` wouldn't work either, as you'd end up with
   two different signals (one for each side): a Reactive `map` in `page` would
   use the server's signal when it's first generated on the server, while the
   client-side click event would use its own `f`, so nothing would actually
   happen. You can observe this duplication by replacing `%server` below with
   `%shared`: the compiler will emit an error because the type of one of those
   signals can't be inferred (it remains unknown at the end of the typing pass)
   since it's never used throughout the program. *)
let%server s, f = Eliom_shared.React.S.create None

let%client action y m d =
  ~%f (Some (y, m, d));
  Lwt.return_unit

let%shared string_of_date = function
  | Some (y, m, d) ->
      [%i18n
        Demo.S.you_click_on_date ~y:(string_of_int y) ~m:(string_of_int m)
          ~d:(string_of_int d)]
  | None -> ""

let%server date_as_string () : string Eliom_shared.React.S.t =
  Eliom_shared.React.S.map [%shared string_of_date] s

let%rpc date_reactive () : string Eliom_shared.React.S.t Lwt.t =
  Lwt.return @@ date_as_string ()

(* Name for demo menu *)
let%shared name () = [%i18n Demo.S.calendar]
(* Class for the page containing this demo (for internal use) *)
let%shared page_class = "os-page-demo-calendar"

(* Page for this demo *)
let%shared page () =
  let calendar =
    Ot_calendar.make ~click_non_highlighted:true ~action:[%client action] ()
  in
  let%lwt dr = date_reactive () in
  Lwt.return
    [ h1 [%i18n Demo.calendar]
    ; p [%i18n Demo.this_page_show_calendar]
    ; div ~a:[a_class ["os-calendar"]] [calendar]
    ; p [Eliom_content.Html.R.txt dr] ]
