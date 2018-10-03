module Hacl.SHA2

module U8 = FStar.UInt8
module U32 = FStar.UInt32
module U64 = FStar.UInt64
module S = FStar.Seq
module B = LowStar.Buffer
module HS = FStar.HyperStack
module ST = FStar.HyperStack.ST
module M = LowStar.Modifies

module Spec = Spec.SHA2

open Spec.Hash.Helpers

include Hacl.Hash.Common


(** A series of functions; we only expose the monomorphic variants, and leave it
  * up to EverCrypt.Hash to perform multiplexing. *)

val alloca_224: alloca_st SHA2_224
val alloca_256: alloca_st SHA2_256
val alloca_384: alloca_st SHA2_384
val alloca_512: alloca_st SHA2_512

val init_224: init_st SHA2_224
val init_256: init_st SHA2_256
val init_384: init_st SHA2_384
val init_512: init_st SHA2_512

val update_224: update_st SHA2_224
val update_256: update_st SHA2_256
val update_384: update_st SHA2_384
val update_512: update_st SHA2_512

val pad_224: pad_st SHA2_224
val pad_256: pad_st SHA2_256
val pad_384: pad_st SHA2_384
val pad_512: pad_st SHA2_512

val finish_224: finish_st SHA2_224
val finish_256: finish_st SHA2_256
val finish_384: finish_st SHA2_384
val finish_512: finish_st SHA2_512