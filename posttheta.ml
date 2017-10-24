open Circuit

(* C.init s : Crée le circuit en fonction de la chaine s *)
(* C.size() : donne le nombre d'états *)
(* C.queue() : donne la queue sous forme de chaine *)
(* C.next() : exécute une transision *)

let compute_queue = ref false
       
let in_out (s : string) : string * string =
  let rec separate_in_out list_trans = match list_trans with
      [] -> ("","")
    | R(c) :: q -> let (input, output) = separate_in_out q in
                   (Char.escaped c ^ input, output)
    | S(c) :: q -> let (input, output) = separate_in_out q in
                   (input, Char.escaped c ^ output)
  in separate_in_out (C.transitions_of_string s) 

let rec compute_power (x : string) (i : int) : string = match i with
    0 -> ""
  | k -> x ^ (compute_power x (k-1))
                     
let loop_test (input : string) (output : string) : bool =
  let inOut = compute_power input (String.length output) in
  let outIn = compute_power output (String.length input) in 
  inOut = outIn && (String.length output) >= (String.length input)


let val_queue (s : string) (k : int) : string =
  (* Compute the contents of the queue at iteration k *)
  C.init s;
  let size = C.size() in 
  for i=0 to size*k-1 do 
    C.next()
  done;
  C.queue()
    
let _ =

  Arg.parse
    [("-c", Arg.Unit (fun () -> compute_queue := true),
      "compute the queue in iteration k given")] (fun _ -> ()) "";
                                                          
  
  let args = Sys.argv in
  if (!compute_queue)
  then begin
      try
        let k = int_of_string (args.(3)) in
        let queue = (val_queue (args.(2)) k) in
        Printf.printf "The queue of the circuit at iteration %d contains :\n" k;
        Printf.printf "%s\n" queue
      with
      | Invalid_argument(_) | Failure("int_of_string") ->
         begin
           Printf.printf "Invalid arguments \n";
           Printf.printf "To compute the queue at some iteration k, use argument -c \n with circuit as first argument and k as second\n"
         end
    end
  else
    try
      let (input, output) = in_out (args.(1)) in
      Printf.printf "In : %s\n" input;
      Printf.printf "Out : %s\n" output;
      if loop_test input output
      then begin
          Printf.printf "The queue at iteration k contains :\n";
          Printf.printf "(%s) ^ k minus the prefix (%s) ^ k\n" output input
        end
      else begin
          Printf.printf "Circuit blocked at some iteration\n"
        end;
      Printf.printf "To compute the queue at some iteration k, use argument -c \n with circuit as first argument and k as second\n";
      
    with
    | Invalid_argument(f) ->
       Printf.printf "Please give a circuit in argument\n"
         
