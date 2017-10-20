open Circuit

(*C.init s : Crée le circuit en fonction de la chaine s*)
(*C.size() : donne le nombre d'états*)
(*C.queue() : donne la queue sous forme de chaine*)
(*C.next() : exécute une transision*)
   
let test (s : string) : unit =
  C.init s; 
  let size = C.size() in 
  Printf.printf "Circuit : %s\n" s;
  Printf.printf "Taille : %i\n"size;
  Printf.printf "Contenu de la file :\n";
  
  for i=0 to size*4-1 do
    begin
      if i mod size = 0 then
        Printf.printf "\n%i : %s\n" i (C.queue())
      else
        Printf.printf "%i : %s\n" i (C.queue()) 
    end;
      C.next(); 
  done

let _ =
  let args = Sys.argv in
  try
    test (args.(1))
  with
  | Invalid_argument(f) ->
     begin
       Printf.printf "Test par défaut : \n";
       test "!a!b?a?b"
     end
