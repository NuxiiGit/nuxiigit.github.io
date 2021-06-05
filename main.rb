require "erb"
require "commonmarker"
require "rouge"
require "yaml"
require "fileutils"
load "rouge/cosy.rb"
load "rouge/gml.rb"

##
# Helper function for reading files at this location.
def read(path)
    content = ""
    abspath = "./component/" + path
    if File.file? abspath
        content = File.read abspath, mode: "rb", encoding: "utf-8"
    else
        puts "file does not exist " + abspath
    end
    content
end

##
# Helper function for simply writing a string to a file.
def write(path, page)
    abspath = "./content/" + path
    dir = File.dirname abspath
    unless File.directory? dir
        puts "creating path " + dir
        FileUtils.mkdir_p dir
    end
    File.write abspath, page
    abspath
end

##
# Templates an eRuby file with this variable binding.
def template(src, context)
    erb = ERB.new src, trim_mode: "->"
    erb.result context
end

##
# Converts a tex string to html.
def sanitise_tex(src, inline=false)
    l, r = if inline
        ["tex$", "$xet"]
    else
        ["tex$$", "$$xet"]
    end
    tex = "#{l}#{src}#{r}"
    tex = tex.gsub /\\/, '\&\&'
    "<span class=\"tex\">#{tex}</span>"
end

##
# Wraps a string in quotes `"` if it contains whitespace characters.
def stringify(src)
    if src.match? /\s/
        "\"" + src + "\""
    else
        src
    end
end

##
# Creates a reference string.
def ref(bib)
    categories = []
    category = []
    if bib.has_key? :author
        category << "#{bib[:author]}"
    end
    categories << category
    category = []
    if bib.has_key? :title
        category << "#{bib[:title]}"
    end
    categories << category
    category = []
    if bib.has_key? :booktitle
        category << "In <i>#{bib[:booktitle]}</i>"
    end
    if bib.has_key? :pages
        category << "Pages #{bib[:pages]}"
    end
    categories << category
    category = []
    if bib.has_key? :publisher
        category << "#{bib[:publisher]}"
    end
    if bib.has_key? :address
        category << "#{bib[:address]}"
    end
    if bib.has_key? :edition
        category << "#{bib[:edition]}"
    end
    if bib.has_key? :year
        category << "#{bib[:year]}"
    end
    categories << category
    category = []
    if bib.has_key? :url
        category << "<a href=\"#{bib[:url]}\"><code>#{bib[:url]}</code></a>"
    end
    if bib.has_key? :visitedon
        category << "Visited on #{bib[:visitedon]}"
    end
    categories << category
    category = []
    if bib.has_key? :note
        category << "#{bib[:note]}"
    end
    categories << category
    categories
            .select{|category| !category.empty?}
            .flat_map{|category| [category.join(", "), ". "]}
            .reduce(:+)
end

##
# Converts a title into an equivalent id.
def convert_id(src)
    src.downcase.gsub /\s+/, "+"
end

##
# Converts markdown header tags into respective html header tags.
def header_tag_md_to_html(tags)
    case tags
        when "#" then "h2"
        when "##" then "h3"
        when "###" then "h4"
        when "####" then "h5"
        else "h6"
    end
end

##
# Converts a piece of source code written in Markdown into HTML code.
def markup(src, index=false)
    pattern = /^(#+)\s+(.*)\n/
    if index
        src = src.gsub /```(.|\n)*?```/, "" # ignore potential `#`s inside code blocks
        src = src.gsub /`.*?`/, "" # same here
        src = src.gsub /<code>(.|\n)*?<\/code>/, "" # this too
        src.scan pattern
    else
        src = src.gsub /```.*\n(.|\n)*?```/ do |html|
            if (m = html.match /```(.*)\n((?:.|\n)*?)```/)
                type, code = m.captures
                fmt = Rouge::Formatters::HTML.new
                lex = if type == "cosy"
                    Cosy.new
                elsif type == "gml"
                    Gml.new
                elsif type == "gmlext"
                    GmlExt.new
                else
                    Rouge::Lexer.find type
                end
                if lex == nil
                    lex = Rouge::Lexers::PlainText.new
                end
                outhtml = fmt.format lex.lex code
                "<pre><code class=\"hl\">#{outhtml}</code></pre>"
            else
                "(malformed code block)"
            end
        end
        src = src.gsub /tex\$[^$](.*?)\$/ do |tex|
            if (m = tex.match /tex\$(.*?)\$/)
                inner_tex = m.captures[0]
                sanitise_tex inner_tex, true
            else
                "(malformed inline tex: #{tex})"
            end
        end
        src = src.gsub /tex\$\$[^$](.*?)\$\$/ do |tex|
            if (m = tex.match /tex\$\$(.*?)\$\$/)
                inner_tex = m.captures[0]
                sanitise_tex inner_tex, false
            else
                "(malformed multi-line tex)"
            end
        end
        src = src.gsub /tex\[.*\]/ do |url|
            if (m = url.match /tex\[(.*)\]/)
                inner_url = m.captures[0]
                tex = read "tex/#{inner_url}.tex"
                sanitise_tex tex, false
            else
                "(malformed tex path: #{url})"
            end
        end
        src = src.gsub pattern, <<~HTML
            <<%= header_tag_md_to_html("\\1") %> id="<%= convert_id("\\2") -%>"><a href="#<%= convert_id("\\2") -%>">\\1</a> \\2</<%= header_tag_md_to_html("\\1") %>>
        HTML
        src = template src, binding
        src = CommonMarker.render_html src, [:UNSAFE, :FOOTNOTES], [:tagfilter, :strikethrough, :table]
        src
    end
end

##
# Decodes a YAML file.
def unmarshal_yaml(src)
    YAML.load src
end

$urls = unmarshal_yaml read "common/urls.yaml"
$header = read "common/header.html"
$meta = read "common/meta.html"
$homepage = read "common/homepage.html"
$lang = "lang=\"en\""

# load all files in `ruby` directory
filenames = Dir.entries "ruby"
filenames.each do |filename|
    if filename.match? /.rb$/
        puts "loading " + filename
        load "ruby/" + filename
    end
end