Git Web Development Environment
===============================

This project does several things to make my life easier.

1.  It lets me configure sub-projects (not submodules) to check out to easily
    build out a development environment.
2.  Automatically checks out and upates all submodules to their current refspec
3.  Installs a set of commit hooks

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

   This will:
   1. init any submodules and checkout the current commit unless they contain uncommitted
   changes.
   2. Add this project as a submodule if it doesn't exist already, so really all you need to do is run
   the devsetup.sh script.
   3. Update itself from the latest master and re-run itself
   4. Install a git pre-commit hook that
       * Runs PHP Code Sniffer on all PHP files
       * Runs JSHint on all Javascript files
       * Compiles and minifies all CSS files using YUI Compressor
       * Compiles and minifies all Javascript files using Google Closure Complier
   5. Install the default prepare-commit-msg hook
   6. Install a commit-msg hook that creates Commit-Ids appropriate for Gerrit
   7. Scan the root of each submodule for a devsetup.sh script and, if it exists, run it
   7. Scan the root of each configured module from devsetup.conf for a devsetup.sh script and, if it
   exists, run it


https://github.com/mkenney/git_webdev_tools.git

