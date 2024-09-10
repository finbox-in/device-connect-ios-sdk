# Releasing

1. Update the `spec.version` in `RiskManager.podspec` to the release version.

2. Update the `CHANGELOG.md`

3. Commit

   ```
   $ git commit -am "Prepare version X.Y.Z"
   ```

5. Tag

   ```
   $ git tag -am "Version X.Y.Z" X.Y.Z
   ```

6. Push

   ```
   $ git push && git push --tags
   ```

7. Publish the pod

   ```
   $ pod trunk push RiskManager.podspec --allow-warnings
   ```
