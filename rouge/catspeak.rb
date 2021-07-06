##
# A lexer for the Catspeak language.
class Catspeak < Rouge::RegexLexer
    tag "catspeak"
    filenames "*.cats"
    title "Catspeak"
    desc "The Catspeak Language"

    def keyword_reserved
        Set.new %w(if else while break continue return print run)
    end

    def keyword_constant
        Set.new %w(true false infinity NaN undefined)
    end

    state :root do
        rule %r/\s+/, Text::Whitespace
        rule %r/--[^\n]*/, Comment::Single
        rule %r/\d+\.\d+/, Num::Float
        rule %r/\d+/, Num::Integer
        rule %r/"[^"]*"?/, Str
        rule %r/[()\[\]{};:,.]/, Punctuation
        rule %r/[*\/!#@~&+%|^<>=?\-]/, Operator
        rule %r/`[^`]*`/, Name::Variable::Magic
        rule %r/[A-Za-z_']+[A-Za-z0-9_']*/ do |m|
            chunk = m[0]
            if keyword_reserved.include? chunk
                token Keyword
            elsif keyword_constant.include? chunk
                token Keyword::Constant
            else
                token Name::Variable
            end
        end
    end
end
