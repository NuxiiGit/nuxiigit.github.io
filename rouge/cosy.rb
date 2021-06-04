##
# A lexer for the Cosy programming language.
class Cosy < Rouge::RegexLexer
    tag "cosy"
    filenames "*.cosy"
    title "Cosy"
    desc "The Cosy programming language"

    state :root do
        rule %r/\s+/, Text::Whitespace
        rule %r/--[^\n]*/, Comment::Single
        rule %r/def|let|struct|fn|_|for|in|if|else/, Keyword
        rule %r/\b([iu](8|16|32|64|128|size))\b/, Keyword::Type
        rule %r/\b(f(32|64|128))\b/, Keyword::Type
        rule %r/self|type|bool|char|string|void|nothing/, Keyword::Type
        rule %r/[()\[\]{}#;,]/, Punctuation
        rule %r/[*\/!@~&+%|^<>=?\-:.]/, Operator
        rule %r/(\p{L}|\p{N})*\s*!/, Name::Builtin
        rule %r/\p{Lu}(\p{L}|\p{N})*/, Keyword::Type
        rule %r/\p{Ll}(\p{L}|\p{N})*/, Name
        rule %r/\d+\.\d+/, Num::Float
        rule %r/\d+/, Num::Integer
        rule %r/"[^"]*"/, Str
        rule %r/'(.|(\\.))'/, Str::Char
        rule %r/`[^`]*`/, Str::Other
    end
end
