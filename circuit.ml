type 'a transition = 
  | S of 'a (* it is "!" *)
  | R of 'a (* it is "?" *)        

module type CIRCUIT = sig
  val init : string -> unit
  val next : unit -> unit (*'a transition*)
  val queue : unit -> string
  val size : unit -> int
end

exception Queue_is_blocked
        
module C : CIRCUIT = struct

  let q = Queue.create()
  let circuit = Queue.create()

  let transitions_of_string (s : string) : char transition list =
    let n = String.length s in
    if n mod 2 = 1 then
      failwith "Odd string"
    else
      let t = Array.init (n/2) (fun i -> (Char.escaped s.[2*i]) ^ (Char.escaped s.[2*i+1])) in
      Array.to_list (Array.map (fun x -> if x.[0]='?' then R x.[1] else if x.[0]='!' then S x.[1] else failwith "Not a good symbol") t)

  let init (s : string) : unit =
    Queue.clear circuit;
    List.iter (fun t -> Queue.add t circuit) (transitions_of_string s)
    
  let next () =
    let t = Queue.pop circuit in
    Queue.add t circuit;
    match t with
    | S x -> Queue.add x q
    | R x ->
       begin
         try
           let t = Queue.peek q in
           if t = x then
             let _ = Queue.pop q in ()
           else
             raise
               Queue_is_blocked                                                            
         with
         | Queue.Empty -> raise Queue_is_blocked
                        
       end

  let queue () : string =
    Queue.fold (fun s e -> s^(Char.escaped e)) "" q

  let size () : int =
    Queue.length circuit
    
end
