# Publishing Guide for smooth_scroll_web

This guide will help you publish the `smooth_scroll_web` package to pub.dev and Flutter Gem.

## Pre-Publishing Checklist

### 1. Repository URLs ✅
Repository URLs are already configured in `pubspec.yaml`:
- `homepage`: https://github.com/zenithsyntax/smooth_scroll_web
- `repository`: https://github.com/zenithsyntax/smooth_scroll_web
- `issue_tracker`: https://github.com/zenithsyntax/smooth_scroll_web/issues

### 2. Clean Git State
Ensure your git repository is in a clean state:
```bash
git add .
git commit -m "Prepare package for publishing"
```

### 3. Remove Build Artifacts from Git
If build artifacts are tracked in git, remove them:
```bash
git rm -r --cached example/build/
git rm -r --cached build/
git commit -m "Remove build artifacts from git tracking"
```

## Publishing to pub.dev

### Step 1: Verify Package
Run a dry-run to check for issues:
```bash
dart pub publish --dry-run
```

This will show:
- Files that will be included in the package
- Any validation warnings or errors
- Package size

### Step 2: Authenticate
If you haven't already, authenticate with pub.dev:
```bash
dart pub login
```

You'll need a Google account to publish to pub.dev.

### Step 3: Publish
Once everything looks good, publish the package:
```bash
dart pub publish
```

**Note:** Publishing is permanent. Once published, you cannot delete a version, only deprecate it.

### Step 4: Verify Publication
After publishing, verify your package appears on pub.dev:
- Visit: https://pub.dev/packages/smooth_scroll_web
- Check that all files are correct
- Verify the README displays properly

## Publishing to Flutter Gem

Flutter Gem is an alternative package repository. To publish there:

1. Visit: https://fluttergem.com/
2. Follow their publishing guidelines
3. You may need to create an account and follow their specific submission process

## Post-Publishing

### Update Version
After publishing, update the version in `pubspec.yaml` for the next release:
```yaml
version: 1.0.1  # or 1.1.0 for minor updates, 2.0.0 for major
```

### Update CHANGELOG
Add a new entry to `CHANGELOG.md` for the next version:
```markdown
## 1.0.1

* Bug fixes
* Performance improvements
```

## Package Information

- **Package Name:** smooth_scroll_web
- **Current Version:** 1.0.0
- **License:** MIT
- **SDK Constraints:** >=3.0.0 <4.0.0
- **Flutter Constraints:** >=3.0.0

## Resources

- [pub.dev Publishing Guide](https://dart.dev/tools/pub/publishing)
- [pub.dev Package Format](https://dart.dev/tools/pub/package-layout)
- [Flutter Gem](https://fluttergem.com/)

