.. contents:: Table of contents

Overview
========

This project extends the Base VM and is optimized for specific versions of the OXID eShop.

Final solution is composed of two repositories (*linked using git sub-modules*):

* `Base VM <https://github.com/OXID-eSales/oxvm_base>`_ - Base LAMP stack
* `eShop VM <https://github.com/OXID-eSales/oxvm_eshop>`_ - Current repository, eShop specific configuration and roles.

Getting started
===============

Before proceeding with `Quick start`_ please ensure that the
`Dependencies`_ listed below are installed.

.. _`Dependencies`

Dependencies
------------

* `Vagrant <https://www.vagrantup.com/downloads.html>`_ (>=1.8.6)
* `VirtualBox <https://www.virtualbox.org/>`_ [#virtualbox_dependency]_ (>=4.2, except 5.1.8, see `#29 <https://github.com/OXID-eSales/oxvm_eshop/issues/29>`_; Windows users see `#32 <https://github.com/OXID-eSales/oxvm_eshop/issues/32>`__)
* `Git <https://git-scm.com/downloads>`_
* `OpenSSH <http://www.openssh.com/>`_ (*Only client part is needed*)
* Vagrant plugins:

  * ``vagrant plugin install vagrant-hostmanager``
  * ``vagrant plugin install vagrant-lxc`` (*If* `LXC <https://github.com/fgrehm/vagrant-lxc>`_ *will be used for provision process.*)
  * ``vagrant plugin install vagrant-parallels`` (*If* `Parallels <https://github.com/Parallels/vagrant-parallels>`_ *will be used for provision process.*)

.. [#virtualbox_dependency] VirtualBox is listed as dependency due to the fact that it is the default chosen provider for the VM. In case other providers will be used there is no need to install VirtualBox. Please refer to the list of possible providers in the configuration section to get more information.

.. _`Troubleshooting`

Troubleshooting
---------------

Please see https://github.com/OXID-eSales/oxvm_base#troubleshooting for resolutions of common known issues.

.. _`Quick start`

Quick start
-----------

**Notice**: For OXID eShop Professional Edition or OXID eShop Enterprise Edition, you need to enter the credentials you should have received when purchasing the product.

**Note for Windows users**: Use console with **Administrator privileges** to run vagrant commands!

* Clone [#recursive_clone]_ out current repository:

.. code:: bash

  git clone -b b-6.2 --recursive https://github.com/OXID-eSales/oxvm_eshop.git

* Start the VM (Robust method on Windows to avoid filesystem issues) [#no_dev_option]_:

.. code:: bash

  cd oxvm_eshop
  vagrant up
  vagrant ssh
  # for the Community Edition
  composer create-project oxid-esales/oxideshop-project /tmp/oxideshop dev-b-6.2-ce
  # for the Professional Edition
  composer create-project oxid-esales/oxideshop-project /tmp/oxideshop dev-b-6.2-pe
  # for the Enterprise Edition
  composer create-project oxid-esales/oxideshop-project /tmp/oxideshop dev-b-6.2-ee
  cp -r /tmp/oxideshop /var/www && rm -rf /tmp/oxideshop

* Start the VM (Quicker method with direct installation to the shared directory) [#no_dev_option]_:

.. code:: bash

  cd oxvm_eshop
  vagrant up
  vagrant ssh
  # for the Community Edition
  composer create-project oxid-esales/oxideshop-project /var/www/oxideshop dev-b-6.2-ce
  # for the Professional Edition
  composer create-project oxid-esales/oxideshop-project /var/www/oxideshop dev-b-6.2-pe
  # for the Enterprise Edition
  composer create-project oxid-esales/oxideshop-project /var/www/oxideshop dev-b-6.2-ee

**Attention**: If you plan to facilitate the testing environment in your project, make sure that in your "config.inc.php" the setting "blDelSetupDir" is set to false. This prevents the setup folder from being deleted, which is needed for the shop resetting of the testing environment.

* Set up your shop via http://www.oxideshop.local/Setup

  * Database Name, User and Password: oxid
  * Keep track of the admin Email and Password you define

* After successful installation and setup use the following links to:

  * Open OXID eShop: http://www.oxideshop.local/
  * Access admin area: http://www.oxideshop.local/admin/

    * Username: Defined during the setup
    * Password: Defined during the setup

.. [#recursive_clone] Since the current eShop VM repository is linked through git sub-modules
  it is mandatory to use ``--recursive`` option to instruct ``git`` and clone
  base VM repository as well.
.. [#no_dev_option] You may skip the development requirements with "composer create-project --no-dev [...]", if you don't need to work on the source code.

SDK
===

* Out of the box the VM is equipped with the `Testing library <https://github.com/OXID-eSales/testing_library>`_ - a
  library for writing various kind of tests inside eShop and a set of tools for
  running those tests. It will not be installed if you use the --no-dev option for composer.

* Also you can easily install the `Module skeleton generator <https://github.com/OXID-eSales/module_skeleton_generator>`_ - module which helps to create new OXID eShop modules within the VM (remember to vagrant ssh).

.. code:: bash

  composer require oxid-esales/module-generator:v6.x-dev -d /var/www/oxideshop


Usage
-----

Testing library
^^^^^^^^^^^^^^^

This library is needed for various testing purposes. It is already installed in the VM
through the help of `composer <https://getcomposer.org/>`_, because it's defined
in ``composer.json`` as development requirement inside OXID eShop.

All binary tools are installed inside ``/var/www/oxideshop/vendor/oxid-esales/testing-library/bin``.

A list of available binary tools:

* ``reset-shop`` - restore eShop's database to it's default state (demo);
* ``runmetrics`` - run `pdepend <http://pdepend.org/>`_ against eShop and
  modules code to collect various code metrics information;
* ``runtests`` - run unit/integartion tests against eShop and modules code;
* ``runtests-coverage`` - generate coverage report by running unit/integration
  tests;
* ``runtests-selenium`` - run acceptance tests written for Selenium.

More details on how to use and configure the library can be found at:
https://github.com/OXID-eSales/testing_library

Module skeleton generator
^^^^^^^^^^^^^^^^^^^^^^^^^

The module needs to be activated manually. Further instructions on how to enable
and use the module can be found at (*installation part can be skipped*):
https://github.com/OXID-eSales/module_skeleton_generator#usage

How to update the VM
====================

* Open VM directory:

.. code:: bash

  cd oxvm_eshop

* Destroy old VM:

.. code:: bash

  vagrant destroy

* Update eShop VM:

.. code:: bash

  git pull

* Update Base VM:

.. code:: bash

  git submodule update --recursive

* Start VM:

.. code:: bash

  vagrant up

Configuration
=============

The default virtual environment configuration ensures the shop will run out of the box.
However, it is possible to adjust the configuration of the virtual environment to better match individual preferences.

All configuration changes should be done by overriding variables from:

* `default.yml <https://github.com/OXID-eSales/oxvm_base/blob/master/ansible/vars/default.yml>`_ - base vm variables;
* `oxideshop.yml <https://github.com/OXID-eSales/oxvm_eshop/blob/b-6.2/ansible/vars/oxideshop.yml>`_ - eShop specific variables.

These overridden values must be placed in ``personal.yml``
[#personal_git_ignore]_ file at the root level of current repository.

For the overridden values to take effect please run ``vagrant provision``. If
the changes are related to the shared folder use ``vagrant reload``. In case the
provision process will start to show any kind of errors, please try to use
``vagrant destroy && vagrant up`` for the process to start over from a clean
state.

To double check the merged version of configuration just run ``vagrant config``.

Hint: you have to care for the syntax/semantics for yourself. So, if you get an error while ``vagrant provision``
your personal.yml is the start point for troubleshooting.
Hint: Check if every entry has a value. At the moment no empty entries will work.

.. [#personal_git_ignore] ``personal.yml`` configuration file is already included in ``.gitignore`` and should not be visible as changes to the actual repository.

Shared Folder
-------------

The shared folder will be created at the first run of ``vagrant up`` and will reside within the VM folder at ``oxideshop``, within the guest machine this directory is located  at ``/var/www/oxideshop``.

.. code:: yaml

  ---
  vagrant_local:
    vm:
      app_shared_folder:
        source: oxideshop
        target: /var/www/oxideshop

For composer create-project the target folder has to be empty, so if you need to do another installation remember to either delete its contents or better do a ``vagrant destroy``

Setting up Varnish
------------------

**Notice:** Varnish integration is a feature of the Enterprise Edition (EE) of the OXID eShop.

The following steps are required to successfully activate varnish:

* Trigger Varnish installation in the VM
* Download and install composer package
* Adapt ``servers_conf.vcl``
* Restart Varnish service
* Update OXID eShop ``config.inc.php``
* Update OXID eShop admin settings

The above steps are described with more detail below.

Trigger Varnish installation
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code:: yaml

  ---
  varnish:
    install: true

The above change will only trigger installation of Varnish with the distributed
default configuration ``default.vcl`` which is not compatible with OXID eShop!
If you change the parameter for a running VM you can use ``vagrant provision`` to trigger the installation.

Download and install composer package
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Keep in mind that ``composer`` will ask for username and password as the package
is available only to users who have bought the **performance package**. Please use the credentials which
were provided during the purchase.

Because ``oxid-esales/varnish-configuration`` is a ``composer`` package and
``composer`` tool is available for VM by default we can use the following
OXID eShop version independent way to download the package:

.. code::

  # Register private password protected repository
  composer global config repositories.oxid-esales/varnish-configuration \
    composer https://varnish.packages.oxid-esales.com/

  # Download the actual package
  composer global require oxid-esales/varnish-configuration

Now the package has been downloaded into the global ``vendor`` directory
and we can transfer the configuration files into the system by using these commands:

.. code::

  sudo cp $HOME/.composer/vendor/oxid-esales/varnish-configuration/default.vcl \
    /etc/varnish/

  sudo cp $HOME/.composer/vendor/oxid-esales/varnish-configuration/servers_conf.vcl.dist \
    /etc/varnish/servers_conf.vcl

Adapt ``servers_conf.vcl``
^^^^^^^^^^^^^^^^^^^^^^^^^^

There are two mandatory placeholders which need to be updated inside the
``servers_conf.vcl`` file:

* ``<my_shop_hostname>`` - a valid host which could be used to communicate with
  the shop internaly;
* ``<my_shop_IP>`` - an inbound external IP address which has rights to trigger
  cache invalidation.

The following commands can be used with a default configuration of the VM to
replace the placeholder values with suitable ones:

.. code::

  sudo sed -i "s/<my_shop_hostname>/127.0.0.1/g" /etc/varnish/servers_conf.vcl

  sudo sed -i "s/<my_shop_IP>/$(ip addr | grep eth0 | tail -n 1 \
    | grep -oE "(\b([0-9]{1,3}\.){3}[0-9]{1,3}\b)" | head -n 1)/g" \
    /etc/varnish/servers_conf.vcl

Restart Varnish service
^^^^^^^^^^^^^^^^^^^^^^^

After adapting the configuration files we need to restart the Varnish
service in order for the updated configuration to take effect:

.. code::

  sudo /etc/init.d/varnish restart

Update OXID eShop ``config.inc.php``
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Because Varnish uses ``6081`` port by default this needs to be reflected in
the configuration file ``/var/www/oxideshop/source/config.inc.php``.

For a default setup we need to change ``$this->sShopURL = 'http://www.oxideshop.local';`` to ``$this->sShopURL = 'http://www.oxideshop.local:6081';``,
which can be automatically applied with:

.. code::

  sed -i "s/www\.oxideshop\.local/&:6081/g" /var/www/oxideshop/source/config.inc.php

Update OXID eShop admin settings
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After all of the steps above one must apply necessary changes in the admin
area of the OXID eShop:

* Visit http://www.oxideshop.local:6081/admin/ and select English as language
* Choose ``Master Settings``
* Select ``Core Settings``
* Switch to ``Caching``
* Expand ``Reverse Proxy``
* Tick ``Enable caching``

To check if Reverse proxy cache is active, please click
``Test Reverse Proxy's availability``. In case of successful configuration
the following green colored message will appear "Reverse Proxy test succeed".

More configuration options
--------------------------

There are more configuration settings that can be changed to adapt the virtual environment to your needs.
Be sure to take a look at the examples provided in the README of `Base VM <https://github.com/OXID-eSales/oxvm_base>`_.

Settings that can be changed include among other things:

* Use NFS for shared-folder
* Change PHP version
* Change MySQL version
* Change VM provider
* Change shared folder path
* Define github token for composer
* Change ubuntu repository mirror url
* Change virtual host
* Change the display mode of errors
* Change MySQL password
* Trigger Selenium installation
* Trigger IonCube integration
* Customize email monitoring integration
* Customize MySQL administration web app integration
* Composer parallel install plugin
