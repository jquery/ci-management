#!/bin/sh -eux
# Deletes cache and artefacts of npm, bower, git submodules and jenkins builds
git clean -dffx
export COMMIT=${GIT_COMMIT:-$(git rev-parse HEAD)}
export branch=$(git branch | sed -n -e 's/^\* \(.*\)/\1/p')
echo "Checking nodejs version"
which node
node --version
echo "Checking npm version"
which npm
npm --version
echo "Installing npm dependencies"
npm install
"$(npm bin)/grunt" custom:slim --filename=jquery.slim.js
npm run jenkins
echo "Coping files to codeorigin.jquery.com"
if [ `git branch --list main` ]
then
    scp dist/jquery.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-git.js
    scp dist/jquery.min.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-git.min.js
    scp dist/jquery.slim.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-git.slim.js
    scp dist/jquery.slim.min.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-git.slim.min.js
elif [ `git branch --list 3.x-stable` ]
    scp dist/jquery.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-3.x-git.js
    scp dist/jquery.min.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-3.x-git.min.js
    scp dist/jquery.slim.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-3.x-git.slim.js
    scp dist/jquery.slim.min.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-3.x-git.slim.min.js
fi

#echo "Refreshing cache" To be remved, not needed anymore
#set +e
#curl -s http://codeorigin.jquery.com/jquery-git.js?reload
#curl -s http://codeorigin.jquery.com/jquery-git.min.js?reload
#curl -s http://codeorigin.jquery.com/jquery-git.slim.js?reload
#curl -s http://codeorigin.jquery.com/jquery-git.slim.min.js?reload

echo "Running jenkins-testswarm-static-copy.sh"
set -e
/usr/local/bin/tools/jenkins-testswarm-static-copy.sh jquery "${COMMIT}"
echo "Creating and running new testswarm job"
set +e
grunt testswarm:"${COMMIT}":/usr/local/bin/tools/node-testswarm-config.json:jquery:jquerytesting
exit 0
