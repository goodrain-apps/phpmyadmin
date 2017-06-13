release:
	@docker build  -t goodrainapps/phpmyadmin:$(shell cat VERSION) .
