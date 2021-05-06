sync: docker_stop new_client docker_run
new_client:
	wget  --mirror --convert-links --adjust-extension --page-requisites --no-parent --no-directories --directory-prefix=./client https://www.chiark.greenend.org.uk/~sgtatham/bugs-ru.html
	ssh fairy@130.193.46.126 \
		"rm -r client"
	scp -r $(shell pwd)/client  fairy@130.193.46.126:~/
	rm -r client
build:
	docker build -t fairybeana/lighttpd-mirror .
docker_run:
	ssh fairy@130.193.46.126 \
		"docker run --rm -it -d --name "my_ltpd" -p 80:80 -v ~/client:/var/www fairybeana/lighttpd-mirror"
docker_stop:
	ssh fairy@130.193.46.126 \
		"docker stop my_ltpd"

start_cron: 
	(crontab -l 2>/dev/null; echo "45 3 * * 6 /usr/sbin/make -C /home/fairy/repo/devops_tasks/task_client sync") | crontab -