# Ab-useful
**A`buse´ful**: 
1. Full of abuse; abusive.

**Ab-useful**: 
1. A Ruby gem for really useful extensions, but in ways that are probably a bad idea. 
2. Cool code that you *really* shouldn't use in production.

## What is this crap?
This Gem is a collection of useful hacks that woud get me fired at work, but they're 
handy shortcuts for my personal projects.

So without further ado, here are some fun hacks:

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