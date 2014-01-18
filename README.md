Git Web Development Environment
===============================

This project does several things to make my life easier.

1. It lets me configure sub-projects (not submodules) to check out to easily
   build out a development environment.
2. Automatically checks out and upates all submodules to their current refspec
3.  Installs a git pre-commit hook that
    * Runs PHP Code Sniffer on all PHP files
    * Runs JSHint on all Javascript files
    * Compiles and minifies all CSS files using YUI Compressor
    * Compiles and minifies all Javascript files using Google Closure Complier
4. Installs the default prepare-commit-msg hook
5. Installs a commit-msg hook that creates Commit-Ids appropriate for Gerrit

Installation
------------

1. Add this project as a submodule at the root of your web project with a path of git-webdev-tools

        $> git submodule add https://github.com/mkenney/git_webdev_tools.git git-webdev-tools

2. Copy the devsetup scripts to the root of your project and add them

        $> cp git-webdev-tools/devsetup.* .
        $> git add devsetup.*

3. Add any git projects you want checked out into this one.  This is convenient for large web projects

        $> echo "MODULE_URL[1]=https://github.com/mkenney/my_awesome_project.git" >> devsetup.conf
        $> echo "MODULE_path[1]=my/awesome/path" >> devsetup.conf

   This will clone my_awesome_project and put it in the my/awesome/path folder whenever devsetup.sh is
   run.  It does not add it as a submodule.  Be sure to increment the array key for each new project!

4. Run the devsetup script

        $> ./devsetup.sh

https://github.com/mkenney/git_webdev_tools.git

