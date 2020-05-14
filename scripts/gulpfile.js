const browserSync = require('browser-sync');
const child = require('child_process')
const fs = require('fs');
const path = require('path');
const yaml = require('js-yaml');

const { series, watch } = require('gulp');

const buildRoot = '/_mkdocs/build';
const siteRoot = '/_mkdocs/site';
const mkdocsRoot = process.env.MKDOCS_ROOT;
const mkdocsConf = yaml.safeLoad(fs.readFileSync(path.join(mkdocsRoot, 'mkdocs.yml'), 'utf8'));


const server = browserSync.create();

function build(done) {
  return child.execFile('/_mkdocs/bin/build-docs.sh', [ mkdocsRoot, buildRoot ]);
}

function reload(done) {
  server.reload();
  done();
}

function rsync(done) {
  return child.execFile('/usr/bin/rsync', [ '-a', '--delete', buildRoot + '/', siteRoot + '/' ]);
}

function serve(done) {
  server.init({
    cors: false,
    notify: false,
    open: false,
    port: 8080,
    server: "/_mkdocs/site",
    ui: false,
  });
  server.reload();
  done();
}

function monitor(done) {
  // TODO: Use `mkdocsConf` to narrow the watch list
  const options = {
    cwd: mkdocsRoot,
    ignored: process.env.MKDOCS_IGNORE ? process.env.MKDOCS_IGNORE.split(/s+/) : [],
  };

  process.on('SIGINT', function() {
    setTimeout(function() {
      console.log('\n\nExiting on CTRL+C.\n');
      process.exit(1);
    }, 1);
  });

  watch([ '*', '**/*' ], options, series(build, rsync, reload));
  done();
}

exports.default = series(build, rsync, serve, monitor);
exports.build = build;
