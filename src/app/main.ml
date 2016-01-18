open Lwt
open Cmdliner

let cli_gringotts stdout verbose retrieve =
  let handle = Stripe.make None in
  (* If I use 1.0 it fucks up *)
  (* Stripe.Charges.create ~description:"Hello World" (`Int 450) `USD authing handle >>= fun j -> *)
  Lwt_main.run begin
    Stripe.Charges.retrieve retrieve handle  >>= fun j ->
    Yojson.Basic.pretty_to_string j |> Lwt_io.printl
  end
  (* Stripe.Customers.list_all ~limit:3 handle >>= fun j -> *)

let stdout =
  let doc = "Send JSON response to Stdout" in
  Arg.(value & flag & info ["o"; "stdout"] ~doc)

let verbose =
  let doc = "Print out steps and error messages while Gringott's does work." in
  Arg.(value & flag & info ["v"; "verbose"] ~doc)

let retrieve =
  let doc = "Retrieve charges for charge id" in
  Arg.(value & opt string "ch_17UPyeGWBl4uBQUDIgnn47sK" & info ["r"; "retrieve"] ~doc)

let top_level_info =
  let doc = "An OCaml client for Stripe's API" in
  let man = [
      `S "BUGS & QUESTIONS";
      `P "Email them to <Gina at gina@beancode.io>";
    ]
  in
  Term.(pure cli_gringotts $ stdout $ verbose $ retrieve),
  Term.info "Gringotts" ~version:"1.0" ~doc ~man

let () =
  match Term.eval top_level_info with `Error _ -> exit 1 | _ -> exit 0

