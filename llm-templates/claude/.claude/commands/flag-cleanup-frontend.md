# /frontend-flag-cleanup

Systematically clean up a frontend release/feature flag and all its associated code, components, translations, and composables.

## Usage

```
/frontend-flag-cleanup <flag-name>
```

**Example:**
```
/frontend-flag-cleanup sched-864-toggle-reusable-filter-inputs
```

## Overview

This command performs a comprehensive cleanup of a release/feature flag that is no longer needed, following a systematic approach to ensure all related code, imports, translations, and dependencies are properly removed or simplified.

## Process

### Phase 1: Discovery & Analysis

1. **Find all flag references**
   - Search for the flag name in the codebase using `Grep`
   - Search for the flag constant name (e.g., `REUSABLE_SCHEDULING_FILTERS`)
   - Document all locations where the flag is used
   - Create output file: `.___scratch/llm-outs/<timestamp>-flag-references.txt`

2. **Identify affected components**
   - List all Vue components that reference the flag
   - List all composables that use the flag
   - List all translation keys related to the flag
   - Identify conditional logic that depends on the flag

3. **Map dependencies**
   - For each component/composable that uses the flag:
     - Check what it imports
     - Check what imports it
     - Identify if it becomes redundant after flag removal

### Phase 2: Flag Definition Removal

1. **Remove from release/feature flags definition**
   - Find the Location: e.g. `web/js/vue-components/common/feature-flags.js`
   - Remove the flag constant definition
   - Verify no other flags were accidentally affected

### Phase 3: Component Simplification

1. **Simplify components with flag-based conditionals**
   - For each component using the flag:
     - Remove toggle buttons related to the flag
     - Remove `v-if`/`v-else` conditionals based on the flag
     - Keep only the "new" or "enabled" code path
     - Remove unused imports (e.g., `AcToggleButton`, flag constants)
     - Remove unused computed properties
     - Remove unused `setup()` logic
     - Remove related styles

2. **Common patterns to clean up:**
   - Toggle buttons for enabling/disabling features
   - Conditional rendering of old vs new components
   - Feature flag checks in computed properties
   - Feature flag checks in setup functions

### Phase 4: Composable Cleanup

1. **Remove flag checks from composables**
   - Find Locations: e.g. `web/js/vue-components/scheduling/common/visit-filters/composables/useAlayaContext.js`
   - Remove computed properties that check the flag (e.g., `hasNewVisitFiltersFeature`)
   - Update exports to remove the flag-related properties

2. **Identify redundant composables**
   - Search for composables that only manage flag state
   - Example: `useIsUsingNewVisitFiltersFeature.js`
   - If a composable only:
     - Returns a hardcoded value (e.g., always `true`)
     - Has setters that are never called
     - Becomes empty after flag removal
   - Then mark for deletion

3. **Simplify components using removed composables**
   - Remove imports of deleted composables
   - Remove destructured variables from composable calls
   - Simplify conditional logic that used these variables
   - Example: Change `if (newValue && isUsingNewFiltersFeature.value)` to `if (newValue)`

### Phase 5: Translation Key Cleanup

1. **Find unused translation keys**
   - Common patterns:
     - `<feature>.toggle_button.enable_new_*`
     - `<feature>.toggle_button.enable_old_*`
     - `<feature>.legacy_*`
   - Search for each key in the codebase to confirm it's unused

2. **Remove from locale files**
   - `web/locales/en.json`
   - `web/locales/fr.json`
   - Remove the exact key-value pairs
   - Maintain proper JSON formatting

### Phase 6: Delete Redundant Files

1. **Delete unused composables**
   - Files that only managed flag state
   - Files that are no longer imported anywhere
   - Example: `useIsUsingNewVisitFiltersFeature.js`

2. **Identify and delete unused components**
   - Components that were only used when the flag was disabled (old/legacy versions)
   - Example: `search-criteria.vue` (when replaced by `search-criteria-v2.vue`)
   - Common patterns:
     - Components with `-old` suffix
     - Components without version suffix when a `-v2` version exists
     - Components that were conditionally rendered based on the flag

3. **Check component usage**
   - Search for all imports of the component: `grep -r "from.*component-name.vue"`
   - Search for component registration: `grep -r "ComponentName.*:"`
   - Search for dynamic imports: `grep -r "import(.*component-name.vue"`
   - If ONLY referenced in its own test file → safe to delete

4. **Delete associated test files**
   - When deleting a component, also delete its test file
   - Example: `search-criteria.test.js` when deleting `search-criteria.vue`

5. **Update metadata files**
   - Check `web/js/vue-components/app-tools/components-usage-stats.json`
   - Remove entries for deleted components
   - Maintain proper JSON formatting

6. **Verify deletion safety**
   - Use `Grep` to confirm no remaining references
   - Check for dynamic imports or string-based references
   - Verify no route configurations reference the component

### Phase 7: Rename V2 Suffixes (Optional but Recommended)

After removing the flag and old components, rename V2 components to remove the suffix since they're now the only versions.

1. **Identify V2 components to rename**
   - Find all components with `-v2` suffix: `find . -name "*-v2.vue"`
   - Check if each has an old version that was deleted
   - Verify the component is ONLY used by the cleaned-up flag
   - Check if other flags use the component (e.g., calendar flags)

2. **Criteria for renaming**
   - ✅ Old version was deleted (e.g., `search-criteria.vue` deleted)
   - ✅ Component only used by the cleaned-up flag
   - ✅ No other feature flags reference this component
   - ❌ DO NOT rename if old version still exists
   - ❌ DO NOT rename if used by other flags

3. **Common V2 components to check**
   - `search-criteria-v2.vue` → `search-criteria.vue`
   - `bulk-action-form-v2.vue` → `bulk-action-form.vue`
   - `visit-datagrid-v2.vue` (check if old version exists)
   - `bulk-visit-edit-actions-v2.vue` (check if old version exists)

4. **Renaming process**
   - Use `git mv` to rename files (preserves history)
   - Rename both component and test files
   - Update component name inside the file
   - Update all imports
   - Update test descriptions
   - Update component registrations

5. **Example renaming**
   ```bash
   # Rename component and test file
   git mv search-criteria-v2.vue search-criteria.vue
   git mv search-criteria-v2.test.js search-criteria.test.js

   # Update component name in file
   # name: 'SearchCriteriaV2' → name: 'SearchCriteria'

   # Update imports in other files
   # from './search-criteria-v2.vue' → from './search-criteria.vue'

   # Update test imports
   # import SearchCriteriaV2 from './search-criteria-v2.vue'
   # → import SearchCriteria from './search-criteria.vue'
   ```

6. **Verification after renaming**
   - Search for old references: `git grep "component-v2"`
   - Search for old component names: `git grep "ComponentV2"`
   - Exclude calendar components if they have same name but different flags
   - Verify all imports updated
   - Verify test files updated

7. **Why rename?**
   - ✅ Cleaner codebase
   - ✅ No confusion about which version to use
   - ✅ Consistent naming (no unnecessary suffixes)
   - ✅ Easier to understand the code
   - ✅ Signals that the old version is gone

### Phase 8: Update Test Files with Renamed References

After renaming V2 components, update test files that reference the old component names or keys.

1. **Find test files with outdated references**
   - Search for old component names in test files: `grep -r "ComponentV2" --include="*.test.js"`
   - Search for old file paths in test files: `grep -r "component-v2.vue" --include="*.test.js"`
   - Search for old keys/identifiers: `grep -r "component-v2" --include="*.test.js"`
   - Common patterns to search:
     - `'scheduling-search-criteria-v2'` → should be `'scheduling-search-criteria'`
     - `'bulk-action-form-v2'` → should be `'bulk-action-form'`
     - Filter keys, preset keys, localStorage keys, etc.

2. **Types of test file updates needed**
   - **String literals**: Keys used in tests (e.g., `filterKey: 'scheduling-search-criteria-v2'`)
   - **Import paths**: Already handled in Phase 7, but verify
   - **Component names**: Already handled in Phase 7, but verify
   - **Test descriptions**: Already handled in Phase 7, but verify
   - **Mock data**: Keys in mock responses or test fixtures

3. **Common test files to check**
   - `filters-management-old.test.js` - May reference old filter keys
   - `filters-presets.test.js` - May reference old preset keys
   - `*-old.test.js` files - May reference old component names
   - Integration tests that use component keys

4. **Update process**
   - For each test file with outdated references:
     - Read the file to understand context
     - Update string literals to use new names (without `-v2`)
     - Verify the test still makes sense
     - Ensure consistency across all test files

5. **Example updates**
   ```javascript
   // Before
   const persistentFiltersTestingKey = 'scheduling-search-criteria-v2';

   // After
   const persistentFiltersTestingKey = 'scheduling-search-criteria';
   ```

   ```javascript
   // Before
   props: {
     filterKey: 'scheduling-search-criteria-v2',
   }

   // After
   props: {
     filterKey: 'scheduling-search-criteria',
   }
   ```

6. **Verification**
   - Run tests to ensure they still pass
   - Search for remaining `-v2` references in test files: `grep -r "\-v2" --include="*.test.js"`
   - Verify consistency: all references to renamed components use new names

7. **Why update test files?**
   - ✅ Tests use correct component/key names
   - ✅ Tests remain meaningful and accurate
   - ✅ No confusion about which version is being tested
   - ✅ Consistency across codebase
   - ✅ Tests will continue to work if keys are used in localStorage/API

### Phase 9: Final Verification

1. **Search for remaining references**
   - Flag name: `grep -r "<flag-name>"`
   - Flag constant: `grep -r "<FLAG_CONSTANT>"`
   - Related composables: `grep -r "useIsUsing<Feature>"`
   - Translation keys: `grep -r "toggle_button"`
   - V2 references: `grep -r "component-v2"`
   - V2 references in tests: `grep -r "\-v2" --include="*.test.js"`

2. **Review changes**
   - Run `git diff --stat` to see all modified files
   - Run `git diff` to review actual changes
   - Ensure no unintended modifications

3. **Document cleanup**
   - Create summary file: `.___scratch/llm-outs/<timestamp>-cleanup-summary.txt`
   - Include:
     - Files modified (with line counts)
     - Files deleted
     - Files renamed
     - Test files updated
     - Translation keys removed
     - Components simplified
     - Composables removed

## Output Files

All analysis and summary files should be written to:
```
.___scratch/llm-outs/
```

**Naming convention:** `<timestamp>-<description>.txt`

**DO NOT** overwrite existing output files - always prefix with timestamp.

**Example files:**
- `20251023-010203-flag-references.txt`
- `20251023-020304-translation-keys-removed.txt`
- `20251023-030405-cleanup-summary.txt`

## Common Patterns

### Pattern 1: Toggle Button Removal

**Before:**
```vue
<template>
  <div>
    <AcToggleButton
      v-if="isFiltersToggleEnabled"
      :model-value="showV2Filters"
      @update:model-value="toggleFilters"
    >
      <template #on>{{ $t('visit_search.toggle_button.enable_new_filters') }}</template>
      <template #off>{{ $t('visit_search.toggle_button.enable_old_filters') }}</template>
    </AcToggleButton>
    <NewComponent v-if="showV2Filters" />
    <OldComponent v-else />
  </div>
</template>
```

**After:**
```vue
<template>
  <div>
    <NewComponent />
  </div>
</template>
```

### Pattern 2: Composable Simplification

**Before:**
```javascript
import { useAlayaContext } from './composables/useAlayaContext';
import { useIsUsingNewFiltersFeature } from './composables/useIsUsingNewFiltersFeature';

setup() {
  const { hasNewFiltersFeature, isMultiOffice } = useAlayaContext();
  const { isUsingNewFiltersFeature } = useIsUsingNewFiltersFeature();

  const isVisible = computed(() => {
    return isMultiOffice.value && isUsingNewFiltersFeature.value;
  });

  return { isVisible };
}
```

**After:**
```javascript
import { useAlayaContext } from './composables/useAlayaContext';

setup() {
  const { isMultiOffice } = useAlayaContext();

  const isVisible = computed(() => {
    return isMultiOffice.value;
  });

  return { isVisible };
}
```

### Pattern 3: Feature Flag Definition Removal

**Before:**
```javascript
export const FEATURES = {
  REUSABLE_SCHEDULING_FILTERS: 'sched-864-toggle-reusable-filter-inputs',
  OTHER_FEATURE: 'other-feature-flag',
};
```

**After:**
```javascript
export const FEATURES = {
  OTHER_FEATURE: 'other-feature-flag',
};
```

### Pattern 4: Identifying Unused Components

**Check component usage:**
```bash
# Search for imports
grep -r "from.*search-criteria\.vue" --include="*.{js,vue}"

# Search for component registration
grep -r "SearchCriteria.*:" --include="*.vue"

# Search for dynamic imports
grep -r "import(.*search-criteria\.vue" --include="*.{js,vue}"
```

**If results show:**
- ✅ Only referenced in `search-criteria.test.js` → **SAFE TO DELETE**
- ❌ Referenced in other components → **DO NOT DELETE** (investigate further)

**Components to look for:**
- Old versions when a new version exists (e.g., `component.vue` vs `component-v2.vue`)
- Components with `-old` suffix
- Components that were only rendered when flag was `false`

### Pattern 5: Renaming V2 Components

**Before renaming, verify:**
```bash
# Check if old version exists
ls search-criteria.vue  # Should not exist if deleted

# Check if V2 is used by other flags
git grep "search-criteria-v2" | grep -v "SCHED-864"

# Find all V2 components
find . -name "*-v2.vue"
```

**Renaming steps:**
```bash
# 1. Rename files with git mv (preserves history)
git mv search-criteria-v2.vue search-criteria.vue
git mv search-criteria-v2.test.js search-criteria.test.js

# 2. Update component name in file
# Change: name: 'SearchCriteriaV2'
# To: name: 'SearchCriteria'

# 3. Update imports in other files
# Change: from './search-criteria-v2.vue'
# To: from './search-criteria.vue'

# 4. Update component usage
# Change: <SearchCriteriaV2 />
# To: <SearchCriteria />

# 5. Update test file
# Change: import SearchCriteriaV2 from './search-criteria-v2.vue'
# To: import SearchCriteria from './search-criteria.vue'
# Change: describe('search-criteria-v2.vue', () => {
# To: describe('search-criteria.vue', () => {
```

**Verification:**
```bash
# Verify no references to old names
git grep "search-criteria-v2"  # Should return nothing
git grep "SearchCriteriaV2"    # Should return nothing (except in other unrelated components)
```

### Pattern 6: Updating Test File References

After renaming components, test files may still reference old names in string literals.

**Find outdated references:**
```bash
# Search for V2 references in test files
grep -r "\-v2" --include="*.test.js" web/js/vue-components/scheduling/

# Search for specific old keys
grep -r "scheduling-search-criteria-v2" --include="*.test.js"
grep -r "bulk-action-form-v2" --include="*.test.js"
```

**Before:**
```javascript
// filters-presets.test.js
const persistentFiltersTestingKey = 'scheduling-search-criteria-v2';

renderComponent(FiltersPresets, {
  props: {
    value: {},
    filterPresetsKey: persistentFiltersTestingKey,
  },
});
```

**After:**
```javascript
// filters-presets.test.js
const persistentFiltersTestingKey = 'scheduling-search-criteria';

renderComponent(FiltersPresets, {
  props: {
    value: {},
    filterPresetsKey: persistentFiltersTestingKey,
  },
});
```

**Another example - filters-management-old.test.js:**

**Before:**
```javascript
renderComponent(FiltersManagement, {
  props: {
    value: {},
    filterKey: 'scheduling-search-criteria-v2',
    getDefaultFilters: () => {
      return {};
    },
  },
});
```

**After:**
```javascript
renderComponent(FiltersManagement, {
  props: {
    value: {},
    filterKey: 'scheduling-search-criteria',
    getDefaultFilters: () => {
      return {};
    },
  },
});
```

**Why update these?**
- These keys are often used for localStorage, API calls, or data persistence
- Tests should use the same keys as production code
- Ensures tests remain valid after component renaming
- Prevents confusion about which version is being tested

## Checklist

Use this checklist to ensure complete cleanup:

- [ ] Phase 1: Discovery
  - [ ] Found all flag references
  - [ ] Identified affected components
  - [ ] Mapped dependencies
  - [ ] Created reference output file

- [ ] Phase 2: Flag Definition
  - [ ] Removed from `feature-flags.js`
  - [ ] Verified removal

- [ ] Phase 3: Components
  - [ ] Removed toggle buttons
  - [ ] Simplified conditional rendering
  - [ ] Removed unused imports
  - [ ] Removed unused computed properties
  - [ ] Removed unused setup logic
  - [ ] Cleaned up styles

- [ ] Phase 4: Composables
  - [ ] Removed flag checks from shared composables
  - [ ] Identified redundant composables
  - [ ] Simplified components using removed composables
  - [ ] Deleted redundant composable files

- [ ] Phase 5: Translations
  - [ ] Found unused translation keys
  - [ ] Removed from `en.json`
  - [ ] Removed from `fr.json`

- [ ] Phase 6: File Deletion
  - [ ] Deleted redundant composables
  - [ ] Identified unused components (old/legacy versions)
  - [ ] Verified component usage (only in test files)
  - [ ] Deleted unused components
  - [ ] Deleted associated test files
  - [ ] Updated metadata files (components-usage-stats.json)
  - [ ] Verified no remaining references

- [ ] Phase 7: Rename V2 Suffixes (Optional)
  - [ ] Identified V2 components to rename
  - [ ] Verified old versions were deleted
  - [ ] Verified components only used by cleaned-up flag
  - [ ] Renamed component files (git mv)
  - [ ] Renamed test files (git mv)
  - [ ] Updated component names in files
  - [ ] Updated all imports
  - [ ] Updated test descriptions
  - [ ] Verified no broken references

- [ ] Phase 8: Update Test Files
  - [ ] Found test files with outdated references
  - [ ] Updated string literals (keys, identifiers)
  - [ ] Updated filter keys and preset keys
  - [ ] Verified test consistency
  - [ ] Searched for remaining `-v2` in test files
  - [ ] Confirmed tests still pass

- [ ] Phase 9: Final Verification
  - [ ] Searched for remaining flag references (none found)
  - [ ] Searched for remaining constant references (none found)
  - [ ] Searched for remaining composable references (none found)
  - [ ] Searched for remaining V2 references (none found)
  - [ ] Searched for remaining V2 in test files (none found)
  - [ ] Reviewed `git diff --stat`
  - [ ] Created cleanup summary file

## Important Notes

- **Always keep the "new" or "enabled" code path** - remove the old/legacy path
- **Be thorough with imports** - remove unused imports to keep code clean
- **Check both direct and indirect usage** - a composable might be used by components you haven't checked yet
- **Maintain code functionality** - simplify, don't break
- **Preserve formatting** - maintain existing code style and indentation
- **Document everything** - write comprehensive output files for review

## Related Files

Common locations for feature flag usage:
- `web/js/vue-components/common/feature-flags.js` - Flag definitions
- `web/js/vue-components/scheduling/common/` - Scheduling components
- `web/js/vue-components/scheduling/common/visit-filters/composables/` - Composables
- `web/locales/en.json` - English translations
- `web/locales/fr.json` - French translations

## Example Session Summary

For reference, here's what a complete cleanup might involve:

**Files Modified:**
- `web/js/vue-components/common/feature-flags.js` (-1 line)
- `web/js/vue-components/scheduling/common/visit-search.vue` (-87 lines, +15 lines)
- `web/js/vue-components/scheduling/common/visit-search-old.vue` (-78 lines, +12 lines)
- `web/js/vue-components/scheduling/common/visit-filters/composables/useAlayaContext.js` (-6 lines)
- `web/js/vue-components/scheduling/common/bulk-visit-edit-action/bulk-action-branch-dropdown.vue` (-8 lines, +2 lines)
- `web/locales/en.json` (-2 keys)
- `web/locales/fr.json` (-2 keys)

**Files Deleted:**
- `web/js/vue-components/scheduling/common/visit-filters/composables/useIsUsingNewVisitFiltersFeature.js`
- `web/js/vue-components/scheduling/common/search-criteria.vue` (old/unused component)
- `web/js/vue-components/scheduling/common/search-criteria.test.js` (test for deleted component)
- `web/js/vue-components/scheduling/common/bulk-visit-edit-action/bulk-action-form.vue` (old version)
- `web/js/vue-components/scheduling/common/bulk-visit-edit-action/bulk-action-form.test.js`

**Files Renamed:**
- `search-criteria-v2.vue` → `search-criteria.vue`
- `search-criteria-v2.test.js` → `search-criteria.test.js`
- `bulk-action-form-v2.vue` → `bulk-action-form.vue`
- `bulk-action-form-v2.test.js` → `bulk-action-form.test.js`

**Test Files Updated:**
- `filters-management-old.test.js` - Updated `filterKey: 'scheduling-search-criteria-v2'` → `'scheduling-search-criteria'`
- `filters-presets.test.js` - Updated `persistentFiltersTestingKey: 'scheduling-search-criteria-v2'` → `'scheduling-search-criteria'`

**Translation Keys Removed:**
- `visit_search.toggle_button.enable_new_filters`
- `visit_search.toggle_button.enable_old_filters`

## Tips for Success

1. **Work in phases** - Don't try to do everything at once
2. **Verify after each phase** - Use `Grep` to confirm changes
3. **Keep track of what you've done** - Update the checklist
4. **Save your work** - Write output files at each major step
5. **Think about dependencies** - A component might import something that imports the flag
6. **Be systematic** - Follow the process, don't skip steps
7. **When in doubt, search** - Use `Grep` liberally to find references

## Success Criteria

The cleanup is complete when:
1. ✅ No references to the flag name exist in the codebase
2. ✅ No references to the flag constant exist in the codebase
3. ✅ All toggle buttons for the release/feature are removed
4. ✅ All conditional logic based on the flag is simplified
5. ✅ All unused translation keys are removed
6. ✅ All redundant composables are deleted
7. ✅ All unused components (old/legacy versions) are deleted
8. ✅ All associated test files for deleted components are removed
9. ✅ Metadata files are updated (components-usage-stats.json)
10. ✅ All unused imports are removed
11. ✅ V2 suffixes removed from components (if applicable)
12. ✅ All renamed files use `git mv` (preserves history)
13. ✅ No references to old V2 names remain in code
14. ✅ No references to old V2 names remain in test files
15. ✅ Test files updated with new component/key names
16. ✅ `git diff` shows clean, intentional changes
17. ✅ Comprehensive summary file is created

Ready to commit! 🎉
