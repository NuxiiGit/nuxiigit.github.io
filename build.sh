# generate the website
ruby main.rb
if [ "$1" != "submit" ]; then
	# preview the website
	python3 -m http.server 8888
else
	# commit changes to gh-pages branch
	if [ -z "$COMMIT_REMOTE" ]; then
		COMMIT_REMOTE=origin
	fi
	CURRENT_BRANCH="$(git branch --show-current)"
	if [ "$CURRENT_BRANCH" != gh-pages ] && [[ -z $(git status -s) ]]; then
		git branch -D gh-pages
		git branch gh-pages
		git checkout gh-pages
		IGNORE=$(head -n 2 .gitignore)
		echo $IGNORE > .gitignore
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
		git push "$COMMIT_REMOTE" gh-pages --force
		git checkout "$CURRENT_BRANCH"
	else
		echo "make sure you are not on the gh-pages branch, and that there are no uncommitted changes"
	fi
fi
