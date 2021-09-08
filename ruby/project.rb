$project_layout = read("projects/section.html")

##
# Templates this project list.
def render_projects(list)
    list = list.sort do |x, y|
        cmp = 0
        if x.key?("end") and y.key?("end")
            cmp = x["end"] <=> y["end"]
        elsif x.key?("end")
            cmp = -1
        elsif y.key?("end")
            cmp = 1
        end
        if cmp == 0
            if x.key?("begin") and y.key?("begin")
                cmp = x["begin"] <=> y["begin"]
            elsif x.key?("begin")
                cmp = -1
            elsif y.key?("begin")
                cmp = 1
            end
        end
        -cmp
    end
    template($project_layout, binding)
end

##
# Renders a markdown page.
def render_project_page(name)
    page = read("projects/md/#{name}.md")
    markup(page)
end

project_info = unmarshal_yaml(read("projects/list.yaml"))
vars = binding
page = read("projects/list.html")
page = template(page, vars)
write("projects.html", page)
