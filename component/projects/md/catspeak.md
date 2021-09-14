Designed as a dual language for modding and configuration, Catspeak is a domain-specific language, compiler, and runtime system that resembles the Lisp-family of programming languages. The language is entirely customisable, with only a few primitive constructs, such as variable assignment and control-flow statements. Custom operators and functions are exposed to the Catspeak virtual machine under the discretion of developers, in order to limit how much access a modder has to the game environment.

Catspeak is implemented in GameMaker Language in order to be stable across many different platforms, and is designed be evaluated over multiple frames in order to avoid freezing the game. In order to achieve this, both the compiler and virtual machine use a flat execution model; that is, no recursive descent parsing or tree-walk interpreters. This enables Catspeak programs to be passively compiled, executed, and paused at any time. Despite this, it is still possible for Catspeak scripts to be compiled and evaluated eagerly within a single step if desired.

Below are some example programs written in Catspeak:

```cats
-- structs
position = {
  .x : 12
  .y : -3
}
print : -position.x * position.{"y"} -- 36
```

```cats
-- spicy foreach loops
for [1, 2].[_] = outer {
  for [3, 4].[_] = inner {
    if (outer == 1) {
      continue 2
    }
    result = inner * outer
    break 2
  }
}
print result -- 6
```

```cats
-- functions
factorial = fun n {
  if (n <= 1) {
    return 1
  }
  return : factorial (n - 1) * n
}
print : factorial 10 -- 3628800

-- variadic functions
mean = fun {
  count = 0
  for arg.[_] = n {
    count = count + n
  }
  return : count / length arg
}
print : mean 10 15 30 -- 18.3
```
