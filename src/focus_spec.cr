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

  def Spec::RootContext.fit(
    description = "assert",
    file = __FILE__,
    line = __LINE__,
    end_line = __END_LINE__,
    &block
  )
    execute_it(description.to_s, file, line, end_line, &block)
  end

  def Spec::RootContext.describe(description, file, line, &block)
    if FocusSpec.focussed_contexts_stack.size.zero?
      execute_describe(description, file, line, &block) 
    end
  end

  def Spec::RootContext.execute_describe(description, file, line, &block)
    describe = Spec::NestedContext.new(description, file, line, @@contexts_stack.last)
    @@contexts_stack.push describe
    Spec.formatters.each(&.push(describe))
    block.call
    Spec.formatters.each(&.pop)
    @@contexts_stack.pop
  end

  def Spec::RootContext.execute_it(description = "assert", file = __FILE__, line = __LINE__, end_line = __END_LINE__, &block)
    description = description.to_s

    Spec::RootContext.check_nesting_spec(file, line) do
      return unless Spec.matches?(description, file, line, end_line)

      Spec.formatters.each(&.before_example(description))

      start = Time.monotonic
      begin
        Spec.run_before_each_hooks
        block.call
        Spec::RootContext.report(:success, description, file, line, Time.monotonic - start)
      rescue ex : Spec::AssertionFailed
        Spec::RootContext.report(:fail, description, file, line, Time.monotonic - start, ex)
        Spec.abort! if Spec.fail_fast?
      rescue ex
        Spec::RootContext.report(:error, description, file, line, Time.monotonic - start, ex)
        Spec.abort! if Spec.fail_fast?
      ensure
        Spec.run_after_each_hooks

        # We do this to give a chance for signals (like CTRL+C) to
        # be handled,
        # which currently are only handled when there's a fiber
        # switch
        # (IO stuff, sleep, etc.). Without it the user might wait
        # more than needed
        # after pressing CTRL+C to quit the tests.
        Fiber.yield
      end
    end
  end

  def fcontext(description, file = __FILE__, line = __LINE__, &block)
    Spec::RootContext.fdescribe(description.to_s, file, line, &block)
  end

  def fdescribe(description, file = __FILE__, line = __LINE__, &block)
    Spec::RootContext.fdescribe(description.to_s, file, line, &block)
  end

  def fit(description = "assert", file = __FILE__, line = __LINE__, end_line = __END_LINE__, &block)
    Spec::RootContext.fit(description.to_s, file, line, end_line, &block)
  end
end

