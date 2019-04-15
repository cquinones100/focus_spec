require "spec"

module FocusSpec
  include Spec

  @@focussed_contexts_stack = [] of Context

  def self.focussed_contexts_stack
    @@focussed_contexts_stack
  end

  def Spec::RootContext.fdescribe(description, file, line, &block) 
    describe = execute_describe(description, file, line, &block)

    FocusSpec.focussed_contexts_stack.push describe
  end

  def Spec::RootContext.describe(description, file, line, &block)
    execute_describe(description, file, line, &block) if FocusSpec.focussed_contexts_stack.size.zero?
  end

  def Spec::RootContext.execute_describe(description, file, line, &block)
    describe = Spec::NestedContext.new(description, file, line, @@contexts_stack.last)
    @@contexts_stack.push describe
    Spec.formatters.each(&.push(describe))
    block.call
    Spec.formatters.each(&.pop)
    @@contexts_stack.pop
  end

  def fcontext(description, file = __FILE__, line = __LINE__, &block)
    Spec::RootContext.fdescribe(description.to_s, file, line, &block)
  end
end
