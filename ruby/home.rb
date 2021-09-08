vars = binding
page = read("index.html")
page = template(page, vars)
write("../index.html", page)
page = read("404.html")
page = template(page, vars)
write("../404.html", page)
