module Picky

  module Query

    class IndexesCheck

      class << self

        # Returns the right combinations strategy for
        # a number of query indexes.
        #
        # Currently it isn't possible using Memory and Redis etc.
        # indexes in the same query index group.
        #
        # Picky will raise a Query::Indexes::DifferentBackendsError.
        #
        def check_backends indexes # :nodoc:
          backends = indexes.map &:backend
          backends.uniq! &:class
          raise_different backends if backends.size > 1
          backends
        end
        def raise_different backends # :nodoc:
          raise DifferentBackendsError.new(backends)
        end

      end

    end

    # Currently it isn't possible using Memory and Redis etc.
    # indexes in the same query index group.
    #
    class DifferentBackendsError < StandardError # :nodoc:all
      def initialize backends
        @backends = backends
      end
      def to_s
        "Currently it isn't possible to mix Indexes with backends #{@backends.join(" and ")} in the same Search instance."
      end
    end

  end

end