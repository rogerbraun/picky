module Picky

  class Try

    attr_reader :text, :specific

    def initialize text, index = nil, category = nil
      @text = text
      @specific = Picky::Indexes
      @specific = @specific[index.intern]    if index
      @specific = @specific[category.intern] if category
    end

    def saved
      specific.tokenizer.tokenize(text.dup).first
    end

    def searched
      Picky::Tokenizer.searching.tokenize(text.dup).first
    end

    def output
      <<-OUTPUT
\"#{text}\" is saved in the #{specific.identifier} index as #{saved}
\"#{text}\" as a search will be tokenized as #{searched}

(category qualifiers, e.g. title: are removed if they do not exist as a qualifier, so 'toitle:bla' -> 'bla')
      OUTPUT
    end

    def to_stdout
      puts output
    end

  end

end