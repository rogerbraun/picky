module Picky

  module Query

    # An allocation has a number of combinations:
    # [token, index] [other_token, other_index], ...
    #
    class Allocation # :nodoc:all

      attr_reader :count,
                  :score,
                  :combinations,
                  :result_identifier

      #
      #
      def initialize index, combinations
        @combinations = combinations

        # Could this be rewritten?
        #
        @result_identifier = index.result_identifier
        @backend           = index.backend
      end

      def hash
        @combinations.hash
      end
      # def eql? other
      #   self.class == other.class && combinations.eql?(other.combinations)
      # end

      # Asks the backend for the total score and
      # adds the boosts to it.
      #
      # THINK Can the combinations be empty?
      #
      def calculate_score weights
        @score ||= if @combinations.empty?
          0
        else
          @backend.weight(@combinations) +
            @combinations.boost_for(weights)
        end
      end

      # Asks the backend for the (intersected) ids.
      #
      # THINK Can the combinations be empty?
      #
      def calculate_ids amount, offset
        return [] if @combinations.empty?
        @backend.ids @combinations, amount, offset
      end

      # Ids return by default [].
      #
      def ids
        @ids ||= []
      end

      # This starts the searching process.
      #
      # Returns the calculated ids (from the offset).
      #
      def process! amount, offset
        ids    = calculate_ids amount, offset
        @count = ids.size                         # cache the count before throwing away the ids
        @ids   = ids.slice!(offset, amount) || [] # slice out the relevant part
      end

      #
      #
      def remove categories = []
        @combinations.remove categories
      end

      # Sort highest score first.
      #
      def <=> other_allocation
         other_allocation.score <=> self.score
      end

      # Transform the allocation into result form.
      #
      def to_result
        [self.result_identifier, self.score, self.count, @combinations.to_result, self.ids] if self.count && self.count > 0
      end

      # Json representation of this allocation.
      #
      # Note: Delegates to to_result.
      #
      def to_json options = {}
        Yajl::Encoder.encode to_result, options
      end

      #
      #
      def to_s
        "Allocation(#{to_result})"
      end

    end

  end

end