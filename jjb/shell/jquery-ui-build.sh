#!/bin/sh -exu

node --version
npm --version

npm install

export COMMIT=${GIT_COMMIT:-$(git rev-parse HEAD)}
/usr/local/bin/tools/jenkins-testswarm-static-copy.sh jquery-ui ${COMMIT}

"`npm bin`/grunt" jenkins
scp dist/jquery-ui.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/ui/jquery-ui-git.js
scp dist/jquery-ui.css jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/ui/jquery-ui-git.css

## disable exit-on-error to mark builds as unstable
set +e
"`npm bin`/grunt" testswarm-multi-jquery:${COMMIT}:/usr/local/bin/tools/node-testswarm-config.json:git:jquery-ui-future
exit 0