module Lib.ByteSequence

open FStar.Mul

open Lib.IntTypes
open Lib.Sequence

/// Definition of byte-based sequences
///

type bytes = seq uint8

type lbytes (len:size_nat) = lseq uint8 len

let to_lbytes (b:bytes{length b > 0 /\ length b < max_size_t}) : lbytes (length b) = to_lseq #uint8 b


/// Conversions between natural numbers and sequences
///

val nat_from_intseq_be: #t:inttype -> b:seq (uint_t t) -> Tot (n:nat{n < pow2 (length b * bits t)})

val nat_from_intseq_le: #t:inttype -> b:seq (uint_t t) -> Tot (n:nat{n < pow2 (length b * bits t)})

val nat_from_bytes_be: b:bytes -> Tot (n:nat{n < pow2 (length b * 8)})

val nat_from_bytes_le: b:bytes -> Tot (n:nat{n < pow2 (length b * 8)})

val nat_to_bytes_be: len:nat -> n:nat{n < pow2 (8 * len)} ->  Tot (b:bytes{length b == len /\ n == nat_from_intseq_be #U8 b})

val nat_to_bytes_le: len:nat -> n:nat{n < pow2 (8 * len)} ->  Tot (b:bytes{length b == len /\ n == nat_from_intseq_le #U8 b})

val uint_to_bytes_le: #t:inttype -> u:uint_t t -> lbytes (numbytes t)

val index_uint_to_bytes_le: #t:inttype -> u:uint_t t
  -> Lemma
    (forall (i:nat{i < numbytes t}). index (uint_to_bytes_le u) i ==
                              u8 (uint_v u / pow2 (op_Multiply 8 i) % pow2 8))
val uint_to_bytes_be: #t:inttype -> u:uint_t t -> lbytes (numbytes t)

val uint_from_bytes_le: #t:inttype -> lbytes (numbytes t) -> u:uint_t t

val uint_from_bytes_be: #t:inttype -> lbytes (numbytes t) -> u:uint_t t

val uints_to_bytes_le: #t:inttype -> #len:size_nat{len * numbytes t < pow2 32} 
  -> s:lseq (uint_t t) len -> b:lbytes (len * numbytes t)
val uints_to_bytes_be: #t:inttype -> #len:size_nat{len * numbytes t < pow2 32}
  -> s:lseq (uint_t t) len -> b:lbytes (len * numbytes t)


val uints_from_bytes_le: #t:inttype -> #len:size_nat{len * numbytes t < pow2 32} 
  -> b:lbytes (len * numbytes t) -> s:lseq (uint_t t) len 
val uints_from_bytes_be: #t:inttype -> #len:size_nat{len * numbytes t < pow2 32} 
  -> b:lbytes (len * numbytes t) -> s:lseq (uint_t t) len 
