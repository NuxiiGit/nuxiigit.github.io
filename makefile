all:
	@ruby main.rb

server:
	@python3 -m http.server 8888

clean:
	@if [ -f ./index.html ]; then rm ./index.html; fi;
	@if [ -f ./404.html ]; then rm ./404.html; fi;
	@if [ -d ./content ]; then rm -R ./content; fi;

run: clean all server
