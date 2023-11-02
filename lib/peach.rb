require 'thread'

module Enumerable
  def peach(size=5) # parallel threaded each
    q = Queue.new
    each { q << _1 }
    size.times
        .map { Thread.new { yield q.pop until q.empty? } }
        .each(&:join)
    self
  end

  def pmap(size=5) # parallel threaded map
    in_q = Queue.new
    out_q = Queue.new
    each { in_q << _1 }

    size.times
        .map { Thread.new { yield(in_q.pop).tap { out_q << _1 } until in_q.empty? } }
        .each(&:join)

    q_to_a out_q
  end
end

def q_to_a(q)
  # Helper function to convert Queue contents into an Array
  [].tap { _1 << q.pop until q.empty? }
end
