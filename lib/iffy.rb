# An implementation of the Maybe pattern.
#
# Usage:
# foo.do { |f| use_my_foo(f) }.or { raise FooLessError, "no foos here" }
# nil foo will execute the 'or' path, while non-nil foo will execute the 'do' path.
#
# Best used with one-liners, so you don't have `foo.do do |foo|` in your code someplace.
# This code is essentially equivalent to:
#   foo&.tap { |f| use_my_foo(foo) } || raise FooLessError, "no foos here"
# But I like this better.

class Object
  def do
    yield self
    self
  end

  def or
    # noop
    self
  end
end

class NilClass
  def do
    nil  # Noop
  end

  def or
    yield
    nil
  end
end