Designed as a dual language for modding and configuration, Catspeak is a domain-specific language, compiler, and runtime system that resembles the Lisp-family of programming languages. The language is entirely customisable, with only a few primitive constructs, such as variable assignment and control-flow statements. Custom operators and functions are exposed to the Catspeak virtual machine under the discretion of developers, in order to limit how much access a modder has to the game environment.

Catspeak is implemented in GameMaker Language in order to be stable across many different platforms, and is designed be evaluated over multiple frames in order to avoid freezing the game. In order to achieve this, both the compiler and virtual machine use a flat execution model; that is, no recursive descent parsing or tree-walk interpreters. This enables Catspeak programs to be passively compiled, executed, and paused at any time. Despite this, it is still possible for Catspeak scripts to be compiled and evaluated eagerly within a single step if desired.

Below are some example programs written in Catspeak:

```cats
-- arrays and loops
planets = [
  "Venus"
  "Earth"
  "Mars"
]
n = 3
i = 0
while (i < n) {
  planet = planets.[i]
  print planet -- Venus
  i = i + 1    -- Earth
}              -- Mars
```

```cats
-- structs
position = {
  .x : 12
  .y : -3
}
return : -position.x * position.{"y"} -- 36
```
