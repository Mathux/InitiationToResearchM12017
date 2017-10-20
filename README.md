# InitiationToResearchM12017
Module and algorithms for Queue automaton

## Compiling 

```bash
make
```

## Usage

Module C :

- C.init s : Crée le circuit en fonction de la chaine s
- C.size() : donne le nombre d'états
- C.queue() : donne la queue sous forme de chaine
- C.next() : exécute une transision

## Testing

You can do test with :

```bash
./test.byte s
```

s is in the form : '!a?b!e?i' (be careful, it is simple quotation mark)
