# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Fixed
- `Update-Profile` with the `-AsJob` switch always copied `profile.ps1` to the current working directory and not `$profile.CurrentUserAllHosts`

## [5.0.1] - 2022-03-17
### Added
- Improvements for handling profile and profile module async updates

### Fixed
- Fixed incorrect logic when trying to set OMP theme

## [5.0.0] - 2022-03-17
### Added
- `Update-ProfileModule` also copies `profile.ps1` if module was updated

### Changed
- `Update-Profile` no longer prompts when clobbering
- Removed prompt from `profile.ps1`
- `profile.ps1` no longer changes env var `PSModulePath`

### Fixed
- `Update-ProfileModule` never actually worked, doh

## [4.1.0] - 2022-02-24
### Changed
- `profile.ps1` no longer checks for PS7 to set PSReadline options as listview and history is now supported on 5.1 and 7+

## [4.0.0] - 2022-02-09
### Added
- New alias `ctj` for `ConvertTo-Json`

### Removed
- Removed alias `eps` for `Enter-PSSession`

## [3.2.0] - 2021-12-08
### Changed
- Updated `profile.ps1` to change `$env:PSModulePath` to not use OneDrive folders

## [3.1.2] - 2021-12-08
### Fixed
- Fixed `Install-Profile`

## [3.1.1] - 2021-12-07
### Fixed
- Fixed `Install-Profile`

## [3.1.0] - 2021-12-07
### Added
- New function `Install-Profile`

### Fixed
- Improve detection of PSReadline >= 2.2.0 in profile.ps1

## [3.0.14] - 2021-12-07
### Changed
- No longer force install PSReadline, warn instead

## [3.0.12] - 2021-11-30
### Added
- New function `Add-WorkingDays`

## [3.0.10] - 2021-11-19
### Added
- Test run for pipeline troubleshooting

## [3.0.9] - 2021-11-19
### Added
- Test run for pipeline troubleshooting

## [3.0.8] - 2021-11-18
### Removed
- l alias from profile.ps1

## [3.0.6] - 2021-11-15
### Fixed
- Better error handling in `Update-Profile`
- Imports codaamok module before updating profile

## [3.0.5] - 2021-11-13
### Fixed
- Updated Update-Profile function in profile.ps1 to use this module's profile.ps1 (actually did it this time)

## [3.0.3] - 2021-11-13
### Fixed
- Updated Update-Profile function in profile.ps1 to use this module's profile.ps1

## [3.0.2] - 2021-11-13
### Fixed
- Removed duplicate Update-Profile function in the module, in favour of the one defined in profile.ps1

## [3.0.1] - 2021-11-13
### Changed
- Renamed some functions to use approved verbs

## [2.0.3] - 2021-11-11
### Fixed
- Fixed PSReadline module check in profile.ps1
- Fixed PSReadline module check in profile.ps1

## [2.0.2] - 2021-11-10
### Changed
- Update-Profile now updates with local profile.ps1 from module, not internet

[Unreleased]: https://github.com/codaamok/codaamok/compare/5.0.1..HEAD
[5.0.1]: https://github.com/codaamok/codaamok/compare/5.0.0..5.0.1
[5.0.0]: https://github.com/codaamok/codaamok/compare/4.1.0..5.0.0
[4.1.0]: https://github.com/codaamok/codaamok/compare/4.0.0..4.1.0
[4.0.0]: https://github.com/codaamok/codaamok/compare/3.2.0..4.0.0
[3.2.0]: https://github.com/codaamok/codaamok/compare/3.1.2..3.2.0
[3.1.2]: https://github.com/codaamok/codaamok/compare/3.1.1..3.1.2
[3.1.1]: https://github.com/codaamok/codaamok/compare/3.1.0..3.1.1
[3.1.0]: https://github.com/codaamok/codaamok/compare/3.0.14..3.1.0
[3.0.14]: https://github.com/codaamok/codaamok/compare/3.0.12..3.0.14
[3.0.12]: https://github.com/codaamok/codaamok/compare/3.0.10..3.0.12
[3.0.10]: https://github.com/codaamok/codaamok/compare/3.0.9..3.0.10
[3.0.9]: https://github.com/codaamok/codaamok/compare/3.0.8..3.0.9
[3.0.8]: https://github.com/codaamok/codaamok/compare/3.0.6..3.0.8
[3.0.6]: https://github.com/codaamok/codaamok/compare/3.0.5..3.0.6
[3.0.5]: https://github.com/codaamok/codaamok/compare/3.0.3..3.0.5
[3.0.3]: https://github.com/codaamok/codaamok/compare/3.0.2..3.0.3
[3.0.2]: https://github.com/codaamok/codaamok/compare/3.0.1..3.0.2
[3.0.1]: https://github.com/codaamok/codaamok/compare/2.0.3..3.0.1
[2.0.3]: https://github.com/codaamok/codaamok/compare/2.0.2..2.0.3
[2.0.2]: https://github.com/codaamok/codaamok/tree/2.0.2