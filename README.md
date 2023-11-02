# Ab-useful
**A`buse´ful**: 
1. Full of abuse; abusive.

**Ab-useful**: 
1. A Ruby gem collecting really useful extensions, but implemented in ways that are probably a bad idea.
2. Cool code that you *really* shouldn't use in production.

# What is this?
Lately, I've been interested in language design. And one of the best ways to learn a thing is to push
the boundaries of what you understand. so this Gem collects some fun code that 
a. pokes at the limits of what I can do with Ruby
b. would likely get me fired at work

## Can I use this code?
Knock yourself out, kid. Just don't expect any support.
Any issues reported will be printed out and bound into a book for me to look at when I need a laugh.

# Ok, but what _exactly_ is in here?
* **Iffy:** An OO implementation of the Maybe monad with a little Ruby-ish syntax tossed on.
* **Peach:** A fluent interface for performing parallelized iteration. That'll make more sense when you look at the example below.

## Iffy
An implementation of the Maybe pattern that looks Ruby-ish.


**Usage:**
```rb
# Without Iffy:
x = get_a_thing
if x.nil?
  send_out(x)
else
  report_err("x-less")
end

# With Iffy - .do {} runs if the value is present, .or {} runs if it's nil 
get_a_thing
  .do { |x| send_out(x) }
  .or { report_err("x-less") }
```

## Peach
Easy to use, parallelized each/map for all `Enumerable`s.

**Usage:**
```rb
some_enumerable
    .peach { |i| process(i) } # each, but parallelized with threads

some_enumerable
    .pmap { |i| i.field } # map, but parallelized with threads
    .each { |f| puts f }
```

Under the hood, this pushes all contents of `some_enumerable` into 
a `Queue`, then creates N `Thread`s to execute the provided 
block against the Queue's contents in parallel.

Access to the contents of the starting enumerable will be 
synchronized by the `Queue`, but it's up to you to ensure the code in 
your block is also threadsafe.

The number of threads defaults to 5 and is controlled by a single 
argument to `.peach`/`.pmap`. 

It's best suited to situations where the number of items in your 
enumerable is reasonably small and the blocks just have a long execution 
time. 
```rb
# With 10 threads:
some_enumerable.peach(10) { |f| puts f }

# With 2 threads:
some_enumerable.peach(2) { |f| puts f } 
```
