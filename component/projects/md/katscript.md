Inspired by game development frameworks, this was a research project that presents a domain-specific language, compiler, and runtime system that abstracts over some important aspects of game development. The language features a strong functional programming framework that is used to express object-oriented and event-driven programming design patterns. The language is not designed to be state-of-the-art, and there is much that could be improved.

The following example shows how dynamic polymorphism is achieved using KatScript:

```kats
-- an interface that implements `name`, `sound`, and `speak` for this animal
let IAnimal = fun(animal) {
  animal.name  = "Animal";
  animal.sound = "nothing";
  animal.speak = fun[animal]() {
    :println(animal.name ++ " says " ++ animal.sound);
  };
};

-- construct a new dog instance with this name
let Dog = fun(name) {
  let dog = { };
  IAnimal(dog);     -- implement `IAnimal` for `dog`
  dog.name  = name; -- override `name` and `sound`
  dog.sound = "bark";
  ret dog;
};

-- construct a new cat instance with this name
let Cat = fun(name) {
  let cat = { };
  IAnimal(cat);     -- implement `IAnimal` for `cat`
  cat.name  = name; -- override `name` and `sound`
  cat.sound = "meow";
  ret cat;
};

let animals = [Dog("Rover"), Cat("Tom")];
for let i = 0; i < 2; i += 1 {
  let animal = animals[i];
  animal.speak(); -- Rover says bark
                  -- Tom says meow
}
```
