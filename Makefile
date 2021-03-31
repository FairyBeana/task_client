sync:
	rm -r client
	wget  --mirror --convert-links --adjust-extension --page-requisites --no-parent --no-directories --directory-prefix=./client https://www.chiark.greenend.org.uk/~sgtatham/bugs-ru.html
	scp -r $(shell pwd)/client  fairy@130.193.46.126:~/
download:
	wget  --mirror --convert-links --adjust-extension --page-requisites --no-parent --no-directories --directory-prefix=./client https://www.chiark.greenend.org.uk/~sgtatham/bugs-ru.html
build:
	docker build -t fairybeana/lighttpd-mirror .
run:
	ssh fairy@130.193.46.126 \
		"docker run --rm -it -d --name "my_ltpd" -p 80:80 -v $(pwd)/client:/var/www fairybeana/lighttpd-mirror"
stop:
	ssh fairy@130.193.46.126 \
		"docker stop my_ltpd"