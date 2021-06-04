# clean resources
if [ -f ./index.html ]; then
	rm ./index.html
fi
if [ -f ./404.html ]; then
	rm ./404.html
fi
if [ -d ./content ]; then
	rm -r ./content
fi
# generate the website
ruby main.rb
# commit changes to gh-pages branch

# run the server
python3 -m http.server 8888
