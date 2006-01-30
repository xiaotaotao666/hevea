(***********************************************************************)
(*                                                                     *)
(*                          HEVEA                                      *)
(*                                                                     *)
(*  Luc Maranget, projet PARA, INRIA Rocquencourt                      *)
(*                                                                     *)
(*  Copyright 1998 Institut National de Recherche en Informatique et   *)
(*  Automatique.  Distributed only by permission.                      *)
(*                                                                     *)
(***********************************************************************)

(* "$Id: cut.mli,v 1.2 2006-01-30 08:56:26 maranget Exp $" *)
val real_name : string -> string
val verbose : int ref
val name : string ref
val base : string option ref
val language : string ref
val check_changed : string -> string
type toc_style = Normal | Both | Special
val toc_style : toc_style ref
val cross_links : bool ref
val some_links : bool ref
exception Error of string
val start_phase : string -> unit
val main : Lexing.lexbuf -> unit
