# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # This cop checks for redundant `return` expressions.
      #
      # @example
      #
      #   def test
      #     return something
      #   end
      #
      #   def test
      #     one
      #     two
      #     three
      #     return something
      #   end
      #
      # It should be extended to handle methods whose body is if/else
      # or a case expression with a default branch.
      class RedundantReturn < Cop
        MSG = 'Redundant `return` detected.'

        def on_def(node)
          _method_name, _args, body = *node

          check(body)
        end

        def on_defs(node)
          _scope, _method_name, _args, body = *node

          check(body)
        end

        private

        def check(node)
          return unless node

          if node.type == :return
            convention(node, :keyword, MSG)
          elsif node.type == :begin
            expressions = *node
            last_expr = expressions.last

            if last_expr && last_expr.type == :return
              convention(last_expr, :keyword, MSG)
            end
          end
        end
      end
    end
  end
end
