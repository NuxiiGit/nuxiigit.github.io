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
current_branch="$(git branch --show-current)"
if [ "$current_branch" != gh-pages ] && [[ -z $(git status -s) ]]; then
	git branch -D gh-pages
	git branch gh-pages
	git checkout gh-pages
	ignore=$(head -n 2 .gitignore)
	echo $ignore
	echo $ignore > .gitignore
	cat <<-EOF >> .gitignore
		/component
		/rouge
		/ruby
		.gitignore
		Gemfile
		*.sh
		*.rb
	EOF
	git rm -r --cached .
	git add .
	git commit -m "published website"
	python3 -m http.server 8888
	git checkout "$current_branch"
else
	echo "make sure you are not on the gh-pages branch, and that there are no uncommitted changes"
fi
