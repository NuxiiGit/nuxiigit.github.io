vars = binding
page = read("contact.html")
page = template(page, vars)
write("contact.html", page)
