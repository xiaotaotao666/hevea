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

let header = "$Id: out.ml,v 1.9 1999-02-19 18:00:11 maranget Exp $" 
let verbose = ref 0
;;

type buff = {
  mutable buff : string;
  mutable bp : int;
}
;;

type t = Buff of buff | Chan of out_channel | Null
;;


let create_buff () = Buff {buff = String.create 128 ; bp = 0}
and create_chan chan = Chan chan
and create_null () = Null
;;

let reset = function
  Buff b -> b.bp <- 0
| _      -> raise (Misc.Fatal "Out.reset")
;;

let is_empty = function
  Buff b -> b.bp = 0
| _      -> raise (Misc.Fatal "Out.is_empty")
;;

let realloc out =
  let new_b = String.create (2*String.length out.buff) in
  String.blit out.buff 0 new_b 0 out.bp ;
  out.buff <- new_b
;;

let rec put out s = match out with
  (Buff out) as b ->
    let l = String.length s in
    if out.bp + l < String.length out.buff then begin
      String.blit s 0 out.buff out.bp l ;
      out.bp <- out.bp + l
    end else begin
      realloc out ;
      put b s
    end
| Chan chan -> output_string chan s
| Null -> ()
;;

let rec put_char out c = match out with
  Buff out as b ->
    if out.bp + 1 < String.length out.buff then begin
      String.set out.buff out.bp c ;
      out.bp <- out.bp + 1
    end else begin
      realloc out ;
      put_char b c
    end
| Chan chan ->
   output_char chan c
| Null -> ()
;;

let flush = function
  Chan chan -> flush chan
| _         -> ()
;;

let to_string out = match out with
  Buff out ->
    let r = String.sub out.buff 0 out.bp in
    out.bp <- 0 ; r
| _ -> raise (Misc.Fatal "Out.to_string")
;;

let to_chan chan out = match out with
  Buff out ->
    output chan out.buff 0 out.bp ;
    out.bp <- 0
| _  -> raise (Misc.Fatal "to_chan")
;;

let debug chan out = match out with
  Buff out ->
   output_char chan '*' ;
   output chan out.buff 0 out.bp ;
   output_char chan '*'
| Chan _   ->
   output_string chan "*CHAN*"
| Null ->
   output_string chan "*NULL*"
;;

let hidden_copy from to_buf i l = match to_buf with
  Chan chan -> output chan from.buff i l
| Buff out   ->
    while out.bp + l >= String.length out.buff do
      realloc out
    done ;
    String.blit from.buff i out.buff out.bp l ;
    out.bp <- out.bp + l
| Null -> ()
;;

let copy from_buff to_buff = match from_buff with
  Buff from -> hidden_copy from to_buff 0 from.bp
| _         -> raise (Misc.Fatal "Out.copy")
;;

let copy_no_tag from_buff to_buff =
  if !verbose > 2 then begin
    prerr_string "copy no tag from_buff";
    debug stderr from_buff ;
    prerr_endline ""
  end ;
  match from_buff with
    Buff from -> begin
      try
        let i = String.index from.buff '>'
        and j = String.rindex_from from.buff (from.bp-1) '<' in
        hidden_copy from to_buff (i+1) (j-i-1) ;
        if !verbose > 2 then begin
          prerr_string "copy no tag to_buff";
          debug stderr to_buff ;
          prerr_endline ""            
        end
      with Not_found ->  raise (Misc.Fatal "Out.copy_no_tag, no tag found")
    end
  | _         -> raise (Misc.Fatal "Out.copy_no_tag")
;;

let close = function
| Chan c -> close_out c
| _ -> ()
;;
