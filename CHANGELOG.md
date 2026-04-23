# Changelog

## [Released]

## [0.0.2] - 2026-04-24

### Fixed

- Added missing documentation to `form_autosave_kit` library export.
- Added documentation to `AutosaveFormState` constructor.
- Added documentation to `AutosaveStorage` abstract class constructor.

### Added

- Comprehensive example code snippets to library documentation for pub.dev display.
- Full working code examples in README for Checkout, Registration, and Survey forms.
- Example usages showcasing `AutosaveDraftBanner`, dropdowns, checkboxes, and `AutosaveController` API.

## [0.0.1] - 2026-04-23

### Added

- Initial release.
- `AutosaveForm`, `AutosaveField`, `AutosaveDraftBanner`, `AutosaveController`.
- `shared_preferences` storage backend.
- Debounced persistence (default 800ms).
- Restore on init via `onRestored` callback.
- Multi-type support: String, bool, int, double, List<String>.
