Inspired by game development frameworks, this was a research project that presents a domain-specific language, compiler, and runtime system that abstracts over some important aspects of game development. The language features a strong functional programming framework that is used to express object-oriented and event-driven programming design patterns. The language is not designed to be state-of-the-art, and there is much that could be improved. Figures 1 and 2 show some demos made using the language.

<div class="centre">
	<%= figure("/video/life.webm", desc: "John Conway's Game of Life", ref: 1, height: 240, type: :video) %>
	<%= figure("/video/breakout.webm", desc: "Atari Breakout", ref: 2, height: 240, type: :video) %>
</div>

<br>

The language is expressive enough to represent common Object-Oriented patterns, such as dynamic polymorphism and open recursion. Listing 1 shows a simple Class-like definition for a container that only allows natural numbers. An instance of this collection can then be created by calling the constructor `Natural()`. The methods `get`, `set`, and `inc` of this object are able to be used, but direct access to the `number` field is not possible.

```kats
let Natural = fun() {
  -- private and public interfaces
  let prv = { .number => 0 };
  let pub = { };
  -- populate the public interface
  pub.get = fun[prv]() {
    ret prv.number;
  };
  pub.set = fun[prv](value) {
    let n = :float(value);
    if n < 0 {
      :error(n ++ " must be >= 0");
    }
    prv.number = n;
  };
  pub.inc = fun[pub]() {
    -- open recursion on public `get` and `set` methods
    pub.set(pub.get() + 1);
  };
  -- return the public interface
  ret pub;
};

let nat = Natural();
nat.set(9);
nat.inc();
:println(nat.get());  -- 10
:println(nat.number); -- none, since `number` is not public
```
<%= caption(desc: "Open recursion on a class-like structure", ref: 1, type: :listing) %>
