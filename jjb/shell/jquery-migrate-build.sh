#!/bin/sh -exu

node --version
npm --version

npm install

export COMMIT=${GIT_COMMIT:-$(git rev-parse HEAD)}
npm run build

scp dist/jquery-migrate.js wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-migrate-git.js
scp dist/jquery-migrate.min.js wp-03.ops.jquery.net:/var/www/codeorigin.jquery.com/git/jquery-migrate-git.min.js

/usr/local/bin/tools/jenkins-testswarm-static-copy.sh jquery-migrate ${COMMIT}

"`npm bin`/grunt" testswarm:${COMMIT}:/usr/local/bin/tools/node-testswarm-config.json:jquerymigrate:jquery-3:3600000
