(***********************************************************************)
(*                                                                     *)
(*                          HEVEA                                      *)
(*                                                                     *)
(*  Luc Maranget, projet Moscova, INRIA Rocquencourt                   *)
(*                                                                     *)
(*  Copyright 2001 Institut National de Recherche en Informatique et   *)
(*  Automatique.  Distributed only by permission.                      *)
(*                                                                     *)
(*  $Id: lexeme.mli,v 1.4 2001-05-28 17:28:56 maranget Exp $           *)
(***********************************************************************)
type tag =
  | TT |I |B |BIG |SMALL
  | STRIKE | S |U |FONT
  | EM |STRONG |DFN |CODE |SAMP
  | KBD |VAR |CITE |ABBR |ACRONYM 
  | Q |SUB |SUP | A | SCRIPT | SPAN

type atag =
  | SIZE of string | COLOR of string | FACE of string | OTHER

type attr = atag * string

type attrs = attr list

type token =
  | Open of tag * attrs * string
  | Close of tag * string
  | Text of string
  | Blanks of string
  | Eof

type style =
 {tag : tag ; attrs : attrs ; txt : string ; ctxt : string}