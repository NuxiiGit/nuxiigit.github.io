vars = binding
page = read("works.html")
page = template(page, vars)
write("works.html", page)
