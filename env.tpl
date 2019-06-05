##### For a development setup based on oxideshop_ce
# COMPILATION_VERSION=v6.1.3-dev
# host mountpoint for the shop sourcecode files, directory has to exist
# SHOP_DIRECTORY=./data/oxideshop-dev
# SHOP_TESTS_PATH=/var/www/oxideshop/tests

##### For a demo setup based on oxideshop_project
COMPILATION_VERSION=v6.1.3
# host mountpoint for the shop sourcecode files, directory has to exist
SHOP_DIRECTORY=./data/oxideshop
SHOP_TESTS_PATH=/var/www/oxideshop/vendor/oxid-esales/oxideshop-ce/tests

# host mountpoint for the database files, directory has to exist
DATABASE_DIRECTORY=./data/database

SHOP_SETUP_PATH=/var/www/oxideshop/source/Setup

HOST_USER_ID=[id -u]
HOST_GROUP_ID=[id -g]
HOST_USER_NAME=[id -un]
HOST_GROUP_NAME=[id -gn]
