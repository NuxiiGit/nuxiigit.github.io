# Introduction

## Why

# The Language (Cosy)

```cosy
def std = import!("std");
def io = std::io;

def Set = type;
def BigSet = type#2;

--- represents a pair of values
def Vec2 = struct {
  --- the x position
  x : i32,
  --- the y position
  y : i32,
  --- the null vector
  def null = self { x = 0, y = 0 }
};

--- adds two vectors together
def `+>` = fn(v : Vec2, u : Vec2) : Vec2 {
  self {
    x = v.x + u.x,
    y = v.y + u.y
  }
};

def main = fn() {
  let v = Vec2 { x = 1, y = 2 };
  let u = Vec2 { x = 4, y = -7 };
  let w = v `+>` u;
  io::println(w.x); -- 5
  io::println(w.y); -- -5
};
```

## Progress So Far

# Influences From Existing Languages

## Go

- Simple design
- Interfaces
- No parenthesis around control statement components
- Single unified loop structure `for`

## Rust

- `const fn` for functions that can be evaluated at compile-time
- Move semantics by default
- Algebraic data types
- Powerful functional standard library
- Pattern matching
- Implicit return on blocks and control structures
- `loop` keyword for infinite loops

## Ruby

- Powerful functional standard library
- Pattern matching
- Implicit return on blocks and control structures
- `loop` method for infinite loops

## Scala

- Identifier literals using accents <code>`</code>
- Infix function application `a mod b`
- Algebraic data types
- Pattern matching
- Implicit return on blocks and control structures

## Haskell

- Powerful functional standard library
- Algebraic data types
- Pattern matching
- Type ascription

## Pascal

- Postfix pointer dereference operator (`^`)

## Idris

- Universal polymorphism
- Algebraic data types
- Pattern matching
- Type ascription
- Types as expressions
- Types with types `let a = true : bool : type : type#2 : type#3 : ...`

## Zig

- Compile-time code reflection and metaprogramming
- Compile-time evaluation and generics
- Compile-time struct members
- Types as expressions
- Control flow restricted to keywords
- No function overloading
- Built-in compiler intrinsic functions within their own namespace

# Summary
