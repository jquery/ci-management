#!/bin/sh -exu

node --version
npm --version

npm install
npm test

export COMMIT=${GIT_COMMIT:-$(git rev-parse HEAD)}
"`npm bin`/grunt"

scp dist/jquery.color.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/color/jquery.color-git.js
scp dist/jquery.color.min.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/color/jquery.color-git.min.js
scp dist/jquery.color.svg-names.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/color/jquery.color.svg-names-git.js
scp dist/jquery.color.svg-names.min.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/color/jquery.color.svg-names-git.min.js
scp dist/jquery.color.plus-names.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/color/jquery.color.plus-names-git.js
scp dist/jquery.color.plus-names.min.js jenkins@wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/color/jquery.color.plus-names-git.min.js

/usr/local/bin/tools/jenkins-testswarm-static-copy.sh jquery-color ${COMMIT}

set +e
"`npm bin`/grunt" testswarm:${COMMIT}:/usr/local/bin/tools/node-testswarm-config.json:jquerycolor:jquery-color
exit 0