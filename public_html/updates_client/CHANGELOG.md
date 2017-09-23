
# Updates Client Change Log

## [1.7.2] - 2017-08-03

- Fixed issue on updates extraction log that caused cumulative output.

## [1.7.1] - 2017-07-29

- Switched updates server URL to HTTP by default to prevent errors on WAMP environments.

## [1.7.0] - 2017-07-12

- Fixed issues on error handling of package downloads.
- Added local component installation.

## [1.6.1] - 2017-07-07

- Removed mandatory checks over HTTPs.

## [1.6.0] - 2017-07-03

- Added support for remote packages deployment.

## [1.5.2] - 2017-06-27

- Switched calls to bardcanvas.com through HTTPS instead of HTTP.

## [1.5.1] - 2017-06-26

- Tuned package naming and extraction logic to avoid leftover files.

## [1.5.0] - 2017-06-19

- Refactoring to improve CGI-based installs.
- Switched shell calls for PHP funcitons to extract/update packages.

## [1.4.1] - 2017-06-17

- Changed account detection scheme to properly show warnings.

## [1.4.0] - 2017-06-16

- Changed usage of temp location to avoid triggering server security alerts.
- Replaced rsync with cp for package updates.

## [1.3.0] - 2017-06-12

- Added support for web browser based manual updates.

## [1.2.1] - 2018-06-09

- Added support for hardcoded updates token set in the configuration file.

## [1.2.0] - 2017-05-01

- Added support for detached libraries.

## [1.1.0] - 2017-04-28

- Made default the application of updates by removing the -u argument from cli_check.php.
  Now, if a check wants to be done with no downloads, the -n argument should be used.

## [1.0.9] - 2017-04-05

- Added settings variable to keep track of the updater.

## [1.0.7] - 2017-03-28

- Fixed wrong template versions being delivered to the updates server.
