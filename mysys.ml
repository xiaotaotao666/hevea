(***********************************************************************)
(*                                                                     *)
(*                          HEVEA                                      *)
(*                                                                     *)
(*  Luc Maranget, projet PARA, INRIA Rocquencourt                      *)
(*                                                                     *)
(*  Copyright 2001 Institut National de Recherche en Informatique et   *)
(*  Automatique.  Distributed only by permission.                      *)
(*                                                                     *)
(***********************************************************************)

let header = "$Id: mysys.ml,v 1.1 2001-05-25 09:07:26 maranget Exp $" 

exception Error of string

let put_from_file name put =
  try
    let size = 1024 in
    let buff = String.create size in
    let chan_in = open_in_bin name in
    let rec do_rec () =
      let i = input chan_in buff 0 size in
      if i > 0 then begin
        put (String.sub buff 0 i) ;
        do_rec ()
      end in
    do_rec () ;
    close_in chan_in
  with Sys_error _ ->
    raise (Error ("Cannot read file "^name))
;;

let copy_from_lib dir name =
  let chan_out =
    try open_out_bin name
    with Sys_error _ -> raise (Error ("Cannot open file: "^name)) in
  try
    put_from_file
      (Filename.concat dir name)
      (fun s -> output_string chan_out s) ;
    close_out chan_out
  with
  | e -> close_out chan_out ; raise e
;;


(* handle windows/Unix dialectic => no error when s2 exists *)
let rename s1 s2 =
  if Sys.file_exists s2 then
    Sys.remove s2 ;
  Sys.rename s1 s2

let remove s =
  if Sys.file_exists s then
    Sys.remove s
