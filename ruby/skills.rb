vars = binding
page = read "skills.html"
page = template page, vars
write "skills.html", page
