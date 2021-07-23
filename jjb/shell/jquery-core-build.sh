#!/bin/sh -eux
# Deletes cache and artefacts of npm, bower, git submodules and jenkins builds
git clean -dffx
export COMMIT=${GIT_COMMIT:-$(git rev-parse HEAD)}
echo "Checking nodejs version"
which node
node --version
echo "Checking npm version"
which npm
npm --version
echo "Installing npm"
npm install
"`npm bin`/grunt" custom:slim --filename=jquery.slim.js
npm run jenkins
echo "Coping files to codeorigin.jquery.com"
scp dist/jquery.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-git.js
scp dist/jquery.min.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-git.min.js
scp dist/jquery.slim.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-git.slim.js
scp dist/jquery.slim.min.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-git.slim.min.js
echo "Refreshing cache"
set +e
curl -s http://codeorigin.jquery.com/jquery-git.js?reload
curl -s http://codeorigin.jquery.com/jquery-git.min.js?reload
curl -s http://codeorigin.jquery.com/jquery-git.slim.js?reload
curl -s http://codeorigin.jquery.com/jquery-git.slim.min.js?reload
echo "Running jenkins-testswarm-static-copy.sh"
set -e
/usr/local/bin/tools/jenkins-testswarm-static-copy.sh jquery ${COMMIT}
echo "Creating and running new testswarm job"
set +e
grunt testswarm:${COMMIT}:/usr/local/bin/tools/node-testswarm-config.json:jquery:jquery
exit 0
