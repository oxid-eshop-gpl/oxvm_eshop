PHONY: install permissions

up: install
	docker-compose up -d

install: data/oxideshop/ permissions data/oxideshop/vendor/ data/oxideshop/source/config.inc.php

data/oxideshop/vendor/: data/oxideshop/composer.lock
	docker-compose run --rm --no-deps php composer install

data/oxideshop/composer.lock: data/oxideshop/composer.json
	docker-compose run --rm --no-deps php composer update

data/oxideshop/composer.json: data/oxideshop/

data/oxideshop/:
	git clone --depth=1 https://github.com/OXID-eSales/oxideshop_ce.git data/oxideshop

permissions: data/oxideshop/ data/oxideshop/source/config.inc.php
	chmod 777 data/oxideshop/source/tmp/ \
	          data/oxideshop/source/out/pictures/ \
	          data/oxideshop/source/out/media/ \
	          data/oxideshop/source/log/ \
	          data/oxideshop/source/config.inc.php \
	          data/oxideshop/source/.htaccess \
	          -R
	chmod +r data/oxideshop/source/export

data/oxideshop/source/config.inc.php: data/oxideshop/source/config.inc.php.dist
	cp data/oxideshop/source/config.inc.php.dist data/oxideshop/source/config.inc.php
